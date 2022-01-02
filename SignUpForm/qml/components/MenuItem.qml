import QtQuick 2.12
import QtQuick.Controls 2.12
import Theme 1.0

MenuItem {
    contentItem: Text {
        id: contetItemText
        verticalAlignment: Text.AlignVCenter
        text: parent.text
        font: Theme.font
        color: parent.enabled ? Theme.textColor : Theme.altTextColor
    }
}
