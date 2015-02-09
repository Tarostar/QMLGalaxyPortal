import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    // Set rect to size of all children (+ margin). - minus description and edit field if not shown.
    height: passcodeEnabledField.checked ? childrenRect.height + Screen.pixelDensity * 2 : childrenRect.height + Screen.pixelDensity * 2 - passcodeDescription.height - passcodeField.height

    property alias editFocus: passcodeField.hasActiveFocus

    function pasteKey(){
        passcodeField.paste();
    }

    Separator {
        id: separator
        anchors.top: parent.top
        width: parent.width
        color: parent.color
    }

    Text {
        id: passcodeTitle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: separator.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("Passcode")
        font.pointSize: largeFonts ? 20 : 15
        font.bold: true
    }
    CheckBox {
        id: passcodeEnabledField
        anchors.top: passcodeTitle.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        text: qsTr("Enable Passcode")
        checked: passcodeEnabled
        onClicked: {
            passcodeEnabled = passcodeEnabledField.checked;
        }
    }
    Text {
        id: passcodeDescription
        visible: passcodeEnabledField.checked ? true : false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: passcodeEnabledField.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("When enabled must type passcode for access.")
        font.pointSize: largeFonts ? 16 : 12
    }
    EditBox {
        id: passcodeField
        visible: passcodeEnabledField.checked ? true : false
        anchors.top: passcodeDescription.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        text: passcode
        echo: TextInput.Password
        onEditDone: {
            passcode = passcodeField.text;
        }
    }
}
