import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Theme 1.0

Item {
    id: control
    implicitHeight: target.implicitHeight
                    + backgroundRect.anchors.topMargin
                    + backgroundRect.anchors.bottomMargin

    property QtObject target: null
    property int horizontalLabelPadding: 12
    property alias placeholder: placeholderLabel.text
    property alias note: noteLabel.text
    property bool noteEnabled: false
    property bool mandatory: false
    property bool ready: !mandatory || (mandatory && target.text !== "")
    property int placeholderAnimationDuration: 100
    property int errorDuration: 10000

    signal clicked

    Connections {
        target: control.target
        function onCursorVisibleChanged() {
            if (!control.target.cursorVisible)
                control.target.deselect()
        }
    }

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        border.width: Theme.borderWidth
        radius: Theme.radius
        color: Theme.viewBackgroundColor

        Label {
            id: mandatoryLabel
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 5
            font: Theme.font
            color: Theme.warningColor
            text: "*"
            visible: control.mandatory && control.target.text === ""
        }
    }

    MouseArea {
        anchors.fill: parent
        z: 1
        acceptedButtons: (!control.target.readOnly || control.target.text !== "")
                         ? Qt.RightButton
                         : Qt.AllButtons
        cursorShape: Qt.IBeamCursor
        hoverEnabled: true
        onClicked: {
            if (mouse.button === Qt.LeftButton)
                control.clicked();
            else if (mouse.button === Qt.RightButton)
                contextMenu.open(mouse.x, mouse.y);             
        }
    }

    ContextMenu {
        id: contextMenu
        target: control.target
    }

    Label {
        id: placeholderLabel
        z: 1
        width: Math.min(parent.width - 2*control.horizontalLabelPadding, implicitWidth)
        font: Theme.font
        color: Theme.altTextColor
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

        Behavior on x {
            NumberAnimation {
                duration: control.placeholderAnimationDuration
                easing.type: Theme.animationEasingType
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: control.placeholderAnimationDuration
                easing.type: Theme.animationEasingType
            }
        }

        Behavior on font.pointSize {
            NumberAnimation {
                duration: control.placeholderAnimationDuration
                easing.type: Theme.animationEasingType
            }
        }
    }

    Label {
        id: noteLabel
        anchors.left: parent.left
        anchors.leftMargin: control.horizontalLabelPadding
        anchors.bottom: control.bottom
        anchors.bottomMargin: Theme.borderWidth - implicitHeight/2
        width: Math.min(parent.width - 2*control.horizontalLabelPadding, implicitWidth)
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
                name: "edit"
                when: control.target.cursorVisible || contextMenu.opened

                PropertyChanges {
                    target: backgroundRect
                    border.color: Theme.accentColor
                    color: Theme.viewBackgroundColor
                }

                PropertyChanges {
                    target: placeholderLabel
                    x: control.horizontalLabelPadding
                    y: -placeholderLabel.implicitHeight/2
                    font.pointSize: Theme.font.pointSize
                }

                PropertyChanges {
                    target: noteLabel
                    opacity: 0
                }
            },

            State {
                name: "empty"
                when: control.target.text === "" && !control.target.cursorVisible && !control.noteEnabled

                PropertyChanges {
                    target: backgroundRect
                    border.color: Theme.viewBackgroundColor
                    color: Theme.viewBackgroundColor
                }

                PropertyChanges {
                    target: placeholderLabel
                    x: control.target.x + control.target.leftPadding
                    y: backgroundRect.anchors.topMargin + (backgroundRect.height - placeholderLabel.height) / 2
                    font.pointSize: control.target.font.pointSize
                }

                PropertyChanges {
                    target: noteLabel
                    opacity: 0
                }
            },

            State {
                name: "filled"
                when: control.target.text !== "" && !control.target.cursorVisible && !control.noteEnabled

                PropertyChanges {
                    target: backgroundRect
                    border.color: Theme.viewBackgroundColor
                    color: Theme.viewBackgroundColor
                }

                PropertyChanges {
                    target: placeholderLabel
                    x: control.horizontalLabelPadding
                    y: -placeholderLabel.implicitHeight/2
                    font.pointSize: Theme.font.pointSize
                }

                PropertyChanges {
                    target: noteLabel
                    opacity: 0
                }
            },

            State {
                name: "empty_error"
                when: control.target.text === "" && !control.target.cursorVisible && control.noteEnabled

                PropertyChanges {
                    target: backgroundRect
                    border.color: Theme.warningColor
                    color: Theme.viewBackgroundColor
                }

                PropertyChanges {
                    target: placeholderLabel
                    x: control.target.x + control.target.leftPadding
                    y: backgroundRect.anchors.topMargin + (backgroundRect.height - placeholderLabel.height) / 2
                    font.pointSize: control.target.font.pointSize
                }

                PropertyChanges {
                    target: noteLabel
                    opacity: 1
                }
            },

            State {
                name: "filled_error"
                when: control.target.text !== "" && !control.target.cursorVisible && control.noteEnabled

                PropertyChanges {
                    target: backgroundRect
                    border.color: Theme.warningColor
                    color: Theme.viewBackgroundColor
                }

                PropertyChanges {
                    target: placeholderLabel
                    x: control.horizontalLabelPadding
                    y: -placeholderLabel.implicitHeight/2
                    font.pointSize: Theme.font.pointSize
                }

                PropertyChanges {
                    target: noteLabel
                    opacity: 1
                }
            }
        ]

        transitions: [
            Transition {
                from: "empty_error"
                to: "empty"
                animations: animation
            },

            Transition {
                from: "filled_error"
                to: "filled"
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
            if (state == "empty_error" || state == "filled_error")
                timer.start();
        }

        Timer {
            id: timer
            interval: control.errorDuration
            onTriggered: control.noteEnabled = false
        }

        Connections {
            target: control.target
            function onCursorVisibleChanged() {
                control.noteEnabled = false
            }
        }
    }
}
