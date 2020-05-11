import QtQuick 2.12
import QtQuick.Controls 2.12
import "qrc:/qml/components" 1.0
import Theme 1.0

ApplicationWindow {
    id: mainWindow
    minimumWidth: 300
    minimumHeight: 300
    width: 400
    height: 520
    color: Theme.backgroundColor
    visible: true

    SignUpForm {
        id: signUpForm
        anchors.fill: parent
        onSignUp: signUpDialog.open()
        onThemeChanged: Theme.current = light ? Theme.light : Theme.dark
    }

    BackRectangle {
        visible: signUpDialog.visible
    }

    SignUpDialog {
        id: signUpDialog
        onAgain: signUpForm.clear()
    }
}
