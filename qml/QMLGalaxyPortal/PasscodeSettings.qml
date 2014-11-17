import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    // Set rect to size of all children (+ margin).
    height: childrenRect.height + Screen.pixelDensity * 2

    Separator {
        id: separator
        anchors.top: parent.top
        width: parent.width
        margin: Screen.pixelDensity * 5
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
        font.pointSize: 15
        font.bold: true
    }
    Text {
        id: passcodeDescription
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: passcodeTitle.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("When enabled must type passcode for access.")
        font.pointSize: 12
    }
    CheckBox {
        id: passcodeEnabledField
        anchors.top: passcodeDescription.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        text: qsTr("Enable Passcode")
        checked: passcodeEnabled
        onClicked: {
            passcodeEnabled = passcodeEnabledField.checked;
        }
    }
    EditBox {
        id: passcodeField
        visible: passcodeEnabledField.checked ? true : false
        anchors.top: passcodeEnabledField.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        text: passcode
        echo: TextInput.PasswordEchoOnEdit
        onEditDone: {
            passcode = passcodeField.text;
        }
    }
}
