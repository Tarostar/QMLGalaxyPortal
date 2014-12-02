import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    // Set rect to size of all children (+ margin).
    height: childrenRect.height + Screen.pixelDensity * 2

    property alias baseAuth: enableBaseAuth.checked
    property alias editFocus: galaxyKey.hasActiveFocus

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
        id: galaxyKeyTitle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: separator.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("API Key")
        font.pointSize: 15
        font.bold: true
    }
    Text {
        id: galaxyKeyTitleDescription
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: galaxyKeyTitle.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("(Generate 'API Keys' in the Galaxy User menu)")
        font.pointSize: 12
    }
    EditBox {
        id: galaxyKey
        anchors.top: galaxyKeyTitleDescription.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        text: dataKey
        onEditDone: {
            dataKey = galaxyKey.text;
        }
    }
    CheckBox {
        id: enableBaseAuth
        anchors.top: galaxyKey.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        height: Screen.pixelDensity * 9
        text: qsTr("Retrieve API Key with login")
        checked: false
    }
}
