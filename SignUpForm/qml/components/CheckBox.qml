import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtQuick.Controls.Material 2.12
import Theme 1.0

T.CheckBox {
    id: control
    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                                         contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                                          Math.max(contentItem.implicitHeight,
                                                   indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)

    property bool mandatory: false
    property bool ready: !mandatory || (mandatory && checked)

    contentItem: Text {
        id: contentItemText
        leftPadding: control.indicator.width + Theme.em(1)
        text: control.text
        font: Theme.font
        color: Theme.altTextColor
        elide: Text.ElideRight
        visible: control.text
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    Text {
        id: mandatoryLabel
        x: contentItemText.implicitWidth + 2
        anchors.top: parent.top
        anchors.topMargin: 7
        font: Theme.font
        color: Theme.warningColor
        text: "*"
        visible: control.mandatory && !control.checked
    }

    indicator: Rectangle {
        id: checkboxHandle
        implicitWidth: Theme.em(1.2)
        implicitHeight: Theme.em(1.2)
        x: control.leftPadding
        anchors.verticalCenter: parent.verticalCenter
        radius: Theme.radius - 1
        border.color: Theme.altTextColor
        color: Theme.viewBackgroundColor

        Rectangle {
            id: rectangle
            anchors.fill: parent
            radius: Theme.radius
            visible: false
            color: Theme.accentColor
        }

        states: [
            State {
                name: "unchecked"
                when: !control.checked && !control.down
            },

            State {
                name: "checked"
                when: control.checked && !control.down

                PropertyChanges {
                    target: rectangle
                    visible: true
                }
            },

            State {
                name: "unchecked_down"
                when: !control.checked && control.down

                PropertyChanges {
                    target: rectangle
                    color: Theme.accentColor
                }

                PropertyChanges {
                    target: checkboxHandle
                    border.color: Theme.accentColor
                }
            },

            State {
                name: "checked_down"
                extend: "unchecked_down"
                when: control.checked && control.down

                PropertyChanges {
                    target: rectangle
                    visible: true
                }
            }
        ]
    }
}
