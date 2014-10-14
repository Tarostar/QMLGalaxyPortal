import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    id: settings
    width: screen.width
    height: screen.height
    color:"ivory"

    function findField(fieldName) {
        if (screen.fieldList.indexOf(fieldName) >= 0) {
            return true;
        }

        return false;
    }

    function toggleField(fieldName) {
        if (findField(fieldName)) {
            // remove
            if (screen.fieldList.indexOf(fieldName) === 0) {
                // first entry
                screen.fieldList = screen.fieldList.replace(fieldName, "");
            } else {
                // not first entry, so remove comma
                screen.fieldList = screen.fieldList.replace("," + fieldName, "");
            }

            if (screen.fieldList[0] === ",") {
                // remove any comma at start of string
                screen.fieldList = screen.fieldList.substring(1);
            }

        } else {
            // add
            if (screen.fieldList.length === 0) {
                screen.fieldList = fieldName;
            } else {
                screen.fieldList += "," + fieldName;
            }
        }
    }

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
        font.pointSize: 15
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
        font.pointSize: 15
        font.bold: true
    }
    Text {
        id: galaxyKeyTitleDescription
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: galaxyKeyTitle.bottom
        anchors.topMargin: 1
        elide: Text.ElideMiddle
        text: "(Generate 'API Keys' in User menu)"
        font.pointSize: 12
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
        font.pointSize: 15
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
    // Config settings for fields.
    Text {
        id: fieldConfigTitle
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: passcodeField.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "Job Fields"
        font.pointSize: 15
        font.bold: true
    }
    Column {
        id: fieldConfig
        anchors.top: fieldConfigTitle.bottom
        /*ComboBox {
            id: firstField
            width: parent.width
            model: [ "empty", "update_time", "misc_blurb", "data_type", "genome_build", "metadata_data_lines", "history_content_type", "file_ext", "file_size" ]
        }*/
        CheckBox {
            id: update_time
            anchors.left: parent.left
            anchors.margins: 5
            width: settings.width
            height: Screen.pixelDensity * 9
            text: qsTr("Update Time")
            checked: findField("update_time")
            onClicked: {
                toggleField("update_time");
            }
        }
        CheckBox {
            id: misc_blurb
            anchors.left: parent.left
            anchors.margins: 5
            width: settings.width
            height: Screen.pixelDensity * 9
            text: qsTr("Misc Blurb")
            checked: findField("misc_blurb")
            onClicked: {
                toggleField("misc_blurb");
            }
        }
        CheckBox {
            id: data_type
            anchors.left: parent.left
            anchors.margins: 5
            width: settings.width
            height: Screen.pixelDensity * 9
            text: qsTr("Data Type")
            checked: findField("data_type")
            onClicked: {
                toggleField("data_type");
            }
        }
        CheckBox {
            id: genome_build
            anchors.left: parent.left
            anchors.margins: 5
            width: settings.width
            height: Screen.pixelDensity * 9
            text: qsTr("Genome Build")
            checked: findField("genome_build")
            onClicked: {
                toggleField("genome_build");
            }
        }
    }
}
