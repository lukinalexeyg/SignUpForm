import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import "qrc:/qml/components" 1.0 as My
import Theme 1.0

Dialog {
    id: control
    anchors.centerIn: parent
    visible: false
    contentWidth: Theme.em(26)
    contentHeight: Theme.em(24)
    Material.background: Theme.backgroundColor

    signal again

    header: Rectangle {
        height: Theme.em(5)
        color: Theme.backgroundColor

        Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "You have signed up successfully!"
            font: Theme.largeFont
            color: Theme.textColor
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Theme.em(0.1)
            color: Theme.viewBackgroundColor
        }
    }

    contentItem: Rectangle {
        color: Theme.backgroundColor

        Column {
            anchors.fill: parent
            spacing: 10

            Label {
                width: parent.width
                text: "First name: " + signUpForm.firstName
                font: Theme.font
                color: Theme.textColor
                elide: Text.ElideRight
            }

            Label {
                width: parent.width
                text: "Last name: " + signUpForm.lastName
                font: Theme.font
                color: Theme.textColor
                elide: Text.ElideRight
            }

            Label {
                width: parent.width
                text: "Country: " + signUpForm.country
                font: Theme.font
                color: Theme.textColor
                elide: Text.ElideRight
            }

            Label {
                width: parent.width
                text: "Email: " + signUpForm.email
                font: Theme.font
                color: Theme.textColor
                elide: Text.ElideRight
            }

            Label {
                width: parent.width
                text: "Password: " + signUpForm.password
                font: Theme.font
                color: Theme.textColor
                elide: Text.ElideRight
            }
        }
    }

    footer: Rectangle {
        height: button.height + 2*button.anchors.bottomMargin
        color: Theme.backgroundColor

        My.Button {
            id: button
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: Theme.em(1)
            anchors.bottomMargin: Theme.em(1)
            width: Theme.em(16)
            height: Theme.em(4.1)
            text: "Sign Up Again"
            outline: true
            onClicked: {
                control.again();
                control.close();
            }
        }
    }
}
