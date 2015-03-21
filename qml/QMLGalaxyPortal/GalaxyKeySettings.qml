import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    // Set rect to size of all children (+ margin) - minus API Key field if not shown.
    height: showAPIKey.checked ? childrenRect.height + Screen.pixelDensity * 2 : childrenRect.height + Screen.pixelDensity * 2 - galaxyAPIKey.height

    property alias editFocus: galaxyAPIKey.hasActiveFocus

    function pasteKey(){
        galaxyAPIKey.paste();
    }

    CheckBox {
        id: showAPIKey
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: Screen.pixelDensity * 9
        scale: main.scale >= 2 ? 1.5 : 1
        text: qsTr("Show API Key")
        checked: false
    }
    EditBox {
        id: galaxyAPIKey
        visible: showAPIKey.checked ? true : false
        anchors.top: showAPIKey.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        text: dataKey
        onEditDone: {
            // Edit field lost focus, or return/enter was pressed so update current app URL.
            dataKey = galaxyAPIKey.text;
        }
    }
}
