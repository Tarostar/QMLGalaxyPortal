import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    id: settings
    width: main.width
    height: main.height
    color:"ivory"

    // Action bar
    ActionBar {
        id: settingsActionBar
        width: parent.width
        height: Screen.pixelDensity * 9
        settingsButton.visible: false
        backButton.visible: true
        // Paste button is visible if an editbox has focus.
        pasteButton.visible: galaxyUrl.hasActiveFocus || galaxyKeySettings.editFocus || galaxyKeyBaseAuth.editFocus || passcodeSettings.editFocus
        backState: main.state
        actionBarTitle: qsTr("Galaxy Portal Settings")
        onPaste: {
            if (galaxyUrl.hasActiveFocus) {
                galaxyUrl.paste();
            } else if (galaxyKeySettings.editFocus) {
                galaxyKeySettings.pasteKey();
            } else if (galaxyKeyBaseAuth.editFocus) {
                galaxyKeyBaseAuth.pasteKey();
            } else if (passcodeSettings.editFocus) {
                passcodeSettings.pasteKey();
            }
        }
    }
    // Text input for Galaxy URL for API access.
    Flickable {
        anchors.top: settingsActionBar.bottom
        width: main.width
        height: main.height - settingsActionBar.height
        contentWidth: contentItem.childrenRect.width
        contentHeight: contentItem.childrenRect.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Text {
            id: galaxyUrlTitle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            elide: Text.ElideMiddle
            text: qsTr("Galaxy URL")
            font.pointSize: 15
            font.bold: true
        }
        EditBox {
            id: galaxyUrl
            anchors.top: galaxyUrlTitle.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            inputMethodHints: Qt.ImhUrlCharactersOnly
            text: dataSource
            onEditDone: {
                // Edit field lost focus, or return/enter was pressed so update current app URL.
                dataSource = galaxyUrl.text;
            }
        }
        InstanceListSettings {
            id: instanceList
            visible: true
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: galaxyUrl.bottom
            color: settings.color
        }
        GalaxyKeyBaseAuth {
            id: galaxyKeyBaseAuth
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: instanceList.bottom
            color: settings.color
        }
        GalaxyKeySettings {
            id: galaxyKeySettings
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: galaxyKeyBaseAuth.bottom
            color: settings.color
        }
        PollFrequencySettings {
            id: pollFrequencySettings
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: galaxyKeySettings.bottom
            color: settings.color
        }
        AudioNotifications {
            id: audioNotifications
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: pollFrequencySettings.bottom
            color: settings.color
        }
        ScaleSettings {
            id: scaleSettings
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: audioNotifications.bottom
            color: settings.color
        }
        FieldSettings {
            id: fieldSettings
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: scaleSettings.bottom
            color: settings.color
        }
        AdvancedFieldsSettings {
            id: advancedFields
            visible: fieldSettings.advancedFields ? true : false
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: fieldSettings.bottom
            color: settings.color
        }
        PasscodeSettings {
            id: passcodeSettings
            anchors.top: fieldSettings.advancedFields ? advancedFields.bottom : fieldSettings.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: settings.color
        }
        Separator {
            id: versionSeparator
            anchors.top: passcodeSettings.bottom
            width: parent.width
            color: settings.color
        }
        Text {
            id: version
            anchors.top: versionSeparator.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            elide: Text.ElideMiddle
            text: qsTr("Version 0.8 (beta)")
            font.pointSize: 15
        }

        // Line at bottom to "round-off" the settings menu and put some footer space for better scrolling experience.
        Separator {
            anchors.top: version.bottom
            anchors.topMargin: Screen.pixelDensity * 2;
            anchors.bottomMargin: Screen.pixelDensity * 2
            width: parent.width
            color: settings.color
        }
    }
}
