import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import "." as My
import Theme 1.0

Item {
    id: contextMenu
    implicitWidth: full ? Theme.em(20) : Theme.em(10)

    property QtObject target: null
    property int itemsHeight: Theme.em(3)
    property bool full: false
    property bool opened: menu.visible

    Menu {
        id: menu
        topPadding: Theme.em(0.5)
        bottomPadding: Theme.em(0.5)
        font: Theme.font

        background: Pane {
            id: pane
            implicitWidth: contextMenu.width
            implicitHeight: contextMenu.height
            Material.elevation: 6
        }

        onOpened: contextMenu.target.select(internal.selectionStart, internal.selectionEnd);

        My.MenuItem {
            height: visible ? contextMenu.itemsHeight : 0
            text: contextMenu.full ? qsTr("Cut selected") : qsTr("Cut")
            enabled: internal.selectedText != ""
            visible: !contextMenu.target.readOnly
            onTriggered: {
                Core.clipboardAdapter.text = internal.selectedText;
                contextMenu.target.remove(internal.selectionStart, internal.selectionEnd);
                contextMenu.target.deselect();
            }
        }

        My.MenuItem {
            height: visible ? contextMenu.itemsHeight : 0
            text: qsTr("Cut all")
            enabled: contextMenu.target.text !== ""
            visible: !contextMenu.target.readOnly && contextMenu.full
            onTriggered: {
                Core.clipboardAdapter.text = contextMenu.target.text;
                contextMenu.target.clear();
            }
        }

        MenuSeparator {
            height: visible ? implicitHeight : 0
            visible: !contextMenu.target.readOnly && contextMenu.full
        }

        My.MenuItem {
            height: visible ? contextMenu.itemsHeight : 0
            text: contextMenu.full ? qsTr("Copy selected") : qsTr("Copy")
            enabled: internal.selectedText != ""
            onTriggered: Core.clipboardAdapter.text = internal.selectedText;
        }

        My.MenuItem {
            height: visible ? contextMenu.itemsHeight : 0
            text: qsTr("Copy all")
            enabled: contextMenu.target.text !== ""
            visible: contextMenu.full
            onTriggered: Core.clipboardAdapter.text = contextMenu.target.text;
        }

        MenuSeparator {
            height: visible ? implicitHeight : 0
            visible: !contextMenu.target.readOnly && contextMenu.full
        }

        My.MenuItem {
            height: visible ? contextMenu.itemsHeight : 0
            text: qsTr("Paste")
            enabled: Core.clipboardAdapter.text !== ""
            visible: !contextMenu.target.readOnly
            onTriggered: contextMenu.target.paste()
        }

        MenuSeparator {
            height: visible ? implicitHeight : 0
            visible: !contextMenu.target.readOnly && contextMenu.full
        }

        My.MenuItem {
            height: visible ? contextMenu.itemsHeight : 0
            text: contextMenu.full ? qsTr("Delete selected") : qsTr("Delete")
            enabled: internal.selectedText != ""
            visible: !contextMenu.target.readOnly
            onTriggered: {
                contextMenu.target.remove(internal.selectionStart, internal.selectionEnd);
                contextMenu.target.deselect();
            }
        }

        My.MenuItem {
            height: visible ? contextMenu.itemsHeight : 0
            text: qsTr("Delete all")
            enabled: contextMenu.target.text !== ""
            visible: !contextMenu.target.readOnly && contextMenu.full
            onTriggered: contextMenu.target.clear()
        }
    }

    Binding {
        target: pane
        property: "background.color"
        value: internal.backgroundColor
    }

    Item {
        id: internal
        property string selectedText
        property int selectionStart
        property int selectionEnd
        property color backgroundColor: Theme.altBackgroundColor
    }

    function open(x, y) {
        internal.selectedText = contextMenu.target.selectedText;
        internal.selectionStart = contextMenu.target.selectionStart;
        internal.selectionEnd = contextMenu.target.selectionEnd;
        menu.x = x;
        menu.y = y;
        menu.open();
    }
}
