import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Theme 1.0

AbstractTextInput {
    id: control
    target: textField

    property alias background: textField.background
    property alias text: textField.text
    property alias validator: textField.validator
    property alias echoMode: textField.echoMode
    property alias passwordCharacter: textField.passwordCharacter
    property alias readOnly: textField.readOnly
    property alias autoScroll: textField.autoScroll
    property alias cursorPosition: textField.cursorPosition
    property alias hovered: textField.hovered
    property alias edited: textField.cursorVisible

    TextField {
        id: textField
        anchors.fill: parent
        anchors.topMargin: 3
        anchors.bottomMargin: -3
        leftPadding: height / 3
        rightPadding: height / 3
        font: Theme.font
        color: Theme.textColor
        selectByMouse: true
        verticalAlignment: Qt.AlignVCenter
        background: Rectangle { color: "transparent" }
    }
}
