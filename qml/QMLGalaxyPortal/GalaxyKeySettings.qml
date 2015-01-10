import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    // Set rect to size of all children (+ margin) - minus API Key field if not shown.
    height: showAPIKey.checked ? childrenRect.height + Screen.pixelDensity * 2 : childrenRect.height + Screen.pixelDensity * 2 - galaxyAPIKey.height

    property alias editFocus: galaxyAPIKey.hasActiveFocus

    function pasteKey(){
        galaxyKey.paste();
    }

    Separator {
        id: separator
        anchors.top: parent.top
        width: parent.width
        margin: Screen.pixelDensity * 5
        color: parent.color
    }

    Text {
        id: galaxyLogin
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: separator.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("Login")
        font.pointSize: 15
        font.bold: true
    }
    GalaxyKeyBaseAuth {
        id: galaxyKeyBaseAuth
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: galaxyLogin.bottom
        color: settings.color
    }
    CheckBox {
        id: showAPIKey
        anchors.top: galaxyKeyBaseAuth.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: Screen.pixelDensity * 9
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
