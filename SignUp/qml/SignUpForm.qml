import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import "qrc:/qml/components" 1.0 as My
import Theme 1.0

Item {
    id: signUpForm

    property int itemsHeight: Theme.em(4.1)
    property var emailRegExp: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
    property alias firstName: firstNameTextField.text
    property alias lastName: lastNameTextField.text
    property alias country: countryComboBox.currentText
    property alias email: emailTextField.text
    property alias password: passwordTextField.text

    signal signUp()
    signal themeChanged(bool light)

    Flickable {
        anchors.centerIn: parent
        width: parent.width
        height: Math.min(parent.height, mainRowLayout.implicitHeight)
        contentHeight: mainRowLayout.implicitHeight

        ScrollBar.horizontal: ScrollBar {}
        ScrollBar.vertical: ScrollBar {}

        RowLayout {
            id: mainRowLayout
            anchors.fill: parent

            Item {
                Layout.fillWidth: true
                Layout.minimumWidth: Theme.em(2)
            }

            ColumnLayout {
                Layout.minimumWidth: Theme.em(20)
                Layout.maximumWidth: Theme.em(50)
                spacing: Theme.em(2)

                Item {
                    Layout.fillHeight: true
                }

                Label {
                    Layout.fillWidth: true
                    Layout.topMargin: -Theme.em(1.3)
                    text: "Sign Up"
                    font.pointSize: 22
                    font.family: "Liberation Sans"
                    font.bold: true
                    color: Theme.textColor
                }

                Label {
                    Layout.fillWidth: true
                    Layout.topMargin: -Theme.em(0.9)
                    text: "Please fill in this form to create an account!"
                    font.family: "Liberation Sans"
                    color: Theme.altTextColor
                    wrapMode: Text.WordWrap
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.topMargin: -Theme.em(1.3)
                    Layout.leftMargin: -Theme.em(4)
                    Layout.rightMargin: -Theme.em(4)
                    height: Theme.em(0.1)
                    color: Theme.viewBackgroundColor
                }

                GridLayout {
                    id: gridLayout
                    Layout.topMargin: -Theme.em(0.6)
                    width: parent.width
                    columnSpacing: Theme.em(2)
                    rowSpacing: Theme.em(2)

                    My.TextField {
                        id: firstNameTextField
                        Layout.fillWidth: true
                        Layout.maximumWidth: parent.width
                        Layout.preferredHeight: itemsHeight
                        placeholder: "First Name"
                        mandatory: true
                    }

                    My.TextField {
                        id: lastNameTextField
                        Layout.fillWidth: true
                        Layout.maximumWidth: parent.width
                        Layout.preferredHeight: itemsHeight
                        placeholder: "Last Name"
                    }
                }

                My.ComboBox {
                    id: countryComboBox
                    Layout.fillWidth: true
                    Layout.preferredHeight: itemsHeight
                    leftPadding: 12
                    font: Theme.font
                    textRole: "name"
                    placeholder: "Select your country"
                    mandatory: true
                    model: Core.countries
                }

                My.TextField {
                    id: emailTextField
                    Layout.fillWidth: true
                    Layout.preferredHeight: itemsHeight
                    validator: RegExpValidator { regExp: signUpForm.emailRegExp }
                    placeholder: "Email"
                    note: "Enter valid email"
                    mandatory: true
                }

                My.TextField {
                    id: passwordTextField
                    Layout.fillWidth: true
                    Layout.preferredHeight: itemsHeight
                    echoMode: TextInput.Password
                    placeholder: "Password"
                    note: "Password must be at least 5 characters"
                    mandatory: true
                }

                My.CheckBox {
                    id: termsOfUseCheckbox
                    Layout.fillWidth: true
                    Layout.topMargin: -Theme.em(1.2)
                    Layout.preferredHeight: itemsHeight
                    mandatory: true
                    text: "I accept the Terms of Use"
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: itemsHeight + 12
                    Layout.topMargin: -Theme.em(1.5)

                    My.Button {
                        id: button
                        Layout.preferredWidth: Theme.em(14)
                        Layout.preferredHeight: itemsHeight
                        text: "Sign Up"
                        flat: true
                        enabled: (firstNameTextField.ready
                                  && countryComboBox.ready
                                  && emailTextField.ready
                                  && passwordTextField.ready
                                  && emailTextField.ready
                                  && termsOfUseCheckbox.ready)
                        onClicked: signUpForm.check()
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Label {
                        id: mandatoryLabel
                        horizontalAlignment: Text.AlignHCenter
                        text: "Fields marked with *<br>are mandatory"
                        font: Theme.smallFont
                        color: Theme.warningColor
                        opacity: button.enabled ? 0 : 1
                        Behavior on opacity {
                            NumberAnimation {
                                duration: Theme.animationDuration
                                easing.type: Theme.animationEasingType
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.minimumWidth: Theme.em(2)
            }
        }

        Connections {
            target: mainWindow
            function onWidthChanged(width) {
                gridLayout.columns = (width >= Theme.em(40)) ? 2 : 1
            }
        }
    }

    My.Switch {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        onOnChanged: themeChanged(!this.on)
    }

    function check() {
        var error = false;

        if (!signUpForm.emailRegExp.test(emailTextField.text)) {
            emailTextField.noteEnabled = true;
            error = true;
        }

        if (passwordTextField.text.length < 5) {
            error = true;
            passwordTextField.noteEnabled = true;
        }

        if (!error) {
            var data = [];
            data.push({ "first_name": firstNameTextField.text });
            data.push({ "last_name": lastNameTextField.text });
            data.push({ "country": countryComboBox.result["code"] });
            data.push({ "email": emailTextField.text });
            data.push({ "password": passwordTextField.text });

            if (Core.signUp(data))
                signUpForm.signUp();

            delete data;
        }
    }

    function clear() {
        firstNameTextField.text = "";
        lastNameTextField.text = "";
        countryComboBox.currentIndex = -1;
        emailTextField.text = "";
        passwordTextField.text = "";
        termsOfUseCheckbox.checked = false;
    }
}
