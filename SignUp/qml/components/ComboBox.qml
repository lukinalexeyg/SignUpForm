import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Theme 1.0

ComboBox {
    id: control

    property string placeholder: ""
    property alias note: noteLabel.text
    property bool noteEnabled: false
    property int errorDuration: 10000
    property bool mandatory: false
    property bool ready: !mandatory || (mandatory && currentIndex != -1)
    property var result: []

    Component.onCompleted: currentIndex = -1

    background: Rectangle {
        id: backgroundRect
        anchors.fill: parent
        border.width: Theme.borderWidth
        radius: Theme.radius

        Label {
            id: mandatoryLabel
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: parent.width - indicator.x + 5
            anchors.topMargin: 5
            font: Theme.font
            color: Theme.warningColor
            text: "*"
            visible: control.mandatory && control.currentIndex == -1
        }
    }

    contentItem: Text {
        leftPadding: Theme.em(0.5)
        rightPadding: control.indicator.width + control.spacing
        text: control.currentIndex === -1 ? control.placeholder : control.currentText
        color: control.currentIndex === -1 ? Theme.altTextColor : Theme.textColor
        font: Theme.font
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    popup: Popup {
        id: popup
        y: control.height - Theme.borderWidth
        width: control.width
        padding: Theme.borderWidth

        background: Rectangle {
            border.width: Theme.borderWidth
            border.color: Theme.accentColor
            radius: Theme.radius
            color: Theme.backgroundColor
        }

        contentItem: ListView {
            implicitHeight: contentHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator {}
        }
    }

    indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) * 0.5
        width: 8
        height: 5
        contextType: "2d"

        Connections {
            target: control
            onDownChanged: canvas.requestPaint()
        }

        onPaint: {
            context.reset();
            context.fillStyle = Theme.altTextColor;
            if (!control.down) {
                context.moveTo(0, 0);
                context.lineTo(width, 0);
                context.lineTo(width/2, height);
            }
            else {
                context.moveTo(0, height);
                context.lineTo(width, height);
                context.lineTo(width/2, 0);
            }
            context.closePath();
            context.fill();
        }
    }

    delegate: Rectangle {
        width: control.width - 2*Theme.borderWidth
        height: control.height - 2*Theme.borderWidth
        border.width: 0
        radius: Theme.radius
        color: mouseArea.containsMouse
               ? (control.currentIndex === index ? Theme.altHighlightColor : Theme.viewBackgroundColor)
               : (control.currentIndex === index ? Theme.highlightColor : Theme.backgroundColor)

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                currentIndex = index;
                control.result = control.model[index];
                control.popup.close();
            }
        }

        Text {
            anchors.fill: parent
            leftPadding: control.leftPadding
            text: modelData[textRole]
            font: control.font
            color: Theme.textColor
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    Label {
        id: noteLabel
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.bottom: control.bottom
        anchors.bottomMargin: Theme.borderWidth - implicitHeight/2
        width: Math.min(parent.width - 2*12, implicitWidth)
        z: 1
        font: Theme.smallFont
        color: Theme.warningColor
        elide: Text.ElideRight

        background: Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: -5
            anchors.rightMargin: -5
            y: parent.height/2
            height: backgroundRect.border.width
            color: backgroundRect.color
        }
    }

    Item {
        states: [
            State {
                name: "selecting"
                when: control.down

                PropertyChanges {
                    target: backgroundRect
                    border.color: Theme.accentColor
                    color: Theme.viewBackgroundColor
                }

                PropertyChanges {
                    target: noteLabel
                    opacity: 0
                }
            },

            State {
                name: "not_selected"
                when: !control.down && control.currentIndex === -1 && !control.noteEnabled

                PropertyChanges {
                    target: backgroundRect
                    border.color: Theme.viewBackgroundColor
                    color: Theme.viewBackgroundColor
                }

                PropertyChanges {
                    target: noteLabel
                    opacity: 0
                }
            },

            State {
                name: "selected"
                when: !control.down && control.currentIndex >= 0 && !control.noteEnabled

                PropertyChanges {
                    target: backgroundRect
                    border.color: Theme.viewBackgroundColor
                    color: Theme.viewBackgroundColor
                }

                PropertyChanges {
                    target: noteLabel
                    opacity: 0
                }
            },

            State {
                name: "not_selected_error"
                when: !control.down && control.currentIndex === -1 && control.noteEnabled

                PropertyChanges {
                    target: backgroundRect
                    border.color: Theme.warningColor
                    color: Theme.viewBackgroundColor
                }

                PropertyChanges {
                    target: noteLabel
                    opacity: 1
                }
            },

            State {
                name: "selected_error"
                when: !control.down && control.currentIndex >= 0 && control.noteEnabled

                PropertyChanges {
                    target: backgroundRect
                    border.color: Theme.warningColor
                    color: Theme.viewBackgroundColor
                }

                PropertyChanges {
                    target: noteLabel
                    opacity: 1
                }
            }
        ]

        transitions: [
            Transition {
                from: "not_selected_error"
                to: "not_selected"
                animations: animation
            },

            Transition {
                from: "selected_error"
                to: "selected"
                animations: animation
            }
        ]

        ParallelAnimation {
            id: animation

            ColorAnimation {
                target: backgroundRect
                property: "border.color"
                duration: Theme.animationDuration
                easing.type: Theme.animationEasingType
            }

            NumberAnimation {
                target: noteLabel
                property: "opacity"
                from: 1
                to: 0
                duration: Theme.animationDuration
                easing.type: Theme.animationEasingType
            }
        }

        onStateChanged: {
            if (state == "not_selected_error" || state == "selected_error")
                timer.start();
        }

        Timer {
            id: timer
            interval: control.errorDuration
            onTriggered: control.noteEnabled = false
        }
    }

    onDownChanged: {
        if (control.down)
            control.noteEnabled = false;
    }
}
