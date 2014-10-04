import QtQuick 2.3
import QtQuick.Window 2.2

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
    EditBox {
        id: galaxyUrl
        anchors.top: settingsActionBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        text: dataSource
        onEditDone: {
            // edit field lost focus, or return/enter was pressed so update current app URL
            dataSource = galaxyUrl.text
        }
    }
    // Text input for Galaxy key for API access (masked).
    EditBox {
        id: galaxyKey
        anchors.top: galaxyUrl.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 8
        text: dataKey
        echo: TextInput.PasswordEchoOnEdit
        onEditDone: {
            // edit field lost focus, or return/enter was pressed so update current app URL
            dataKey = galaxyKey.text
        }
    }
}
