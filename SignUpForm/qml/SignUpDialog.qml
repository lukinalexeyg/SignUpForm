import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import LukQml 1.0 as Luk

Dialog {
    id: control
    anchors.centerIn: parent
    visible: false
    contentWidth: Luk.Theme.em(26)
    contentHeight: Luk.Theme.em(24)
    Material.background: Luk.Theme.backgroundColor

    signal again

    header: Rectangle {
        height: Luk.Theme.em(5)
        color: Luk.Theme.backgroundColor

        Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: "You have signed up successfully!"
            font: Luk.Theme.largeFont
            color: Luk.Theme.textColor
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Luk.Theme.em(0.1)
            color: Luk.Theme.viewBackgroundColor
        }
    }

    contentItem: Rectangle {
        color: Luk.Theme.backgroundColor

        Column {
            anchors.fill: parent
            spacing: 10

            Label {
                width: parent.width
                text: "First name: " + signUpForm.firstName
                font: Luk.Theme.font
                color: Luk.Theme.textColor
                elide: Text.ElideRight
            }

            Label {
                width: parent.width
                text: "Last name: " + signUpForm.lastName
                font: Luk.Theme.font
                color: Luk.Theme.textColor
                elide: Text.ElideRight
            }

            Label {
                width: parent.width
                text: "Country: " + signUpForm.country
                font: Luk.Theme.font
                color: Luk.Theme.textColor
                elide: Text.ElideRight
            }

            Label {
                width: parent.width
                text: "Email: " + signUpForm.email
                font: Luk.Theme.font
                color: Luk.Theme.textColor
                elide: Text.ElideRight
            }

            Label {
                width: parent.width
                text: "Password: " + signUpForm.password
                font: Luk.Theme.font
                color: Luk.Theme.textColor
                elide: Text.ElideRight
            }
        }
    }

    footer: Rectangle {
        height: button.height + 2*button.anchors.bottomMargin
        color: Luk.Theme.backgroundColor

        Luk.Button {
            id: button
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.rightMargin: Luk.Theme.em(1)
            anchors.bottomMargin: Luk.Theme.em(1)
            width: Luk.Theme.em(16)
            height: Luk.Theme.em(4.1)
            text: "Sign Up Again"
            outline: true
            onClicked: {
                control.again();
                control.close();
            }
        }
    }
}
