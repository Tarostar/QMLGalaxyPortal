import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    id: settings
    width: screen.width
    height: screen.height
    color:"ivory"

    // Action bar
    ActionBar {
        id: settingsActionBar
        width: screen.width
        height: Screen.pixelDensity * 9
        settingsButton.visible: false
        backButton.visible: true
        backState: screen.state
    }
    // Text input for Galaxy URL for API access.
    Text {
        id: galaxyUrlTitle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: settingsActionBar.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "Galaxy URL"
        font.pixelSize: 15
        font.bold: true
    }
    EditBox {
        id: galaxyUrl
        anchors.top: galaxyUrlTitle.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        text: dataSource
        onEditDone: {
            // edit field lost focus, or return/enter was pressed so update current app URL
            dataSource = galaxyUrl.text;
        }
    }
    // Text input for Galaxy key for API access (masked).
    Text {
        id: galaxyKeyTitle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: galaxyUrl.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "API Key"
        font.pixelSize: 15
        font.bold: true
    }
    Text {
        id: galaxyKeyTitleDescription
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: galaxyKeyTitle.bottom
        anchors.topMargin: 1
        elide: Text.ElideMiddle
        text: "(Generate 'API Keys' in User menu)"
        font.pixelSize: 12
    }
    EditBox {
        id: galaxyKey
        anchors.top: galaxyKeyTitleDescription.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        text: dataKey
        echo: TextInput.PasswordEchoOnEdit
        onEditDone: {
            // edit field lost focus, or return/enter was pressed so update current app URL
            dataKey = galaxyKey.text;
        }
    }
    CheckBox {
        id: passcodeEnabledField
        anchors.top: galaxyKey.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        text: qsTr("Enable Passcode")
        checked: passcodeEnabled
        onClicked: {
            passcodeEnabled = passcodeEnabledField.checked;
        }
    }
    Text {
        id: passcodeTitle
        visible: passcodeEnabledField.checked ? true : false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: passcodeEnabledField.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "Passcode"
        font.pixelSize: 15
        font.bold: true
    }
    EditBox {
        id: passcodeField
        visible: passcodeEnabledField.checked ? true : false
        anchors.top: passcodeTitle.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        text: passcode
        onEditDone: {
            // edit field lost focus, or return/enter was pressed so update current app URL
            passcode = passcodeField.text;
        }
    }
}
