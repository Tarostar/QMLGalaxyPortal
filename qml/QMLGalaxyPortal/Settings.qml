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
        width: settings.width
        height: Screen.pixelDensity * 9
        backButton.visible: true
        // Paste button is visible if an editbox has focus.
        pasteButton.visible: galaxyUrl.hasActiveFocus || galaxyKeySettings.editFocus || galaxyKeyBaseAuth.editFocus || passcodeSettings.editFocus
        backState: screen.state
        actionBarTitle: qsTr("Galaxy Portal Settings")
        onPaste: {
            if (galaxyUrl.hasActiveFocus) {
                galaxyUrl.paste();
            }
            else if (galaxyKey.hasActiveFocus) {
                galaxyKey.paste();
            }
            else if (passcodeField.hasActiveFocus) {
                passcodeField.paste();
            }
        }
    }
    // Text input for Galaxy URL for API access.
    Flickable {
        anchors.top: settingsActionBar.bottom
        width: screen.width
        height: screen.height - settingsActionBar.height
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
                // edit field lost focus, or return/enter was pressed so update current app URL
                dataSource = galaxyUrl.text;
            }
        }
        GalaxyKeySettings {
            id: galaxyKeySettings
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: galaxyUrl.bottom
            color: settings.color
        }
        GalaxyKeyBaseAuth {
            id: galaxyKeyBaseAuth
            visible: galaxyKeySettings.baseAuth ? true : false
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: galaxyKeySettings.bottom
            color: settings.color
        }
        PollFrequencySettings {
            id: pollFrequencySettings
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: galaxyKeySettings.baseAuth ? galaxyKeyBaseAuth.bottom : galaxyKeySettings.bottom
            color: settings.color
        }
        // Config settings for fields.
        FieldSettings {
            id: fieldSettings
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: pollFrequencySettings.bottom
            color: settings.color
        }
        PasscodeSettings {
            id: passcodeSettings
            anchors.top: fieldSettings.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            color: settings.color
        }
    }
}
