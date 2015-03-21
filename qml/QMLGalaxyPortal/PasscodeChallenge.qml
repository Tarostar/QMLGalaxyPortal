import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {
    id: passcodeChallenge

    signal done()

    property bool showBypassOption: false

    Text {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 10
        elide: Text.ElideMiddle
        text: qsTr("Passcode")
        font.pointSize: largeFonts ? 16 : 12
        font.bold: true
    }
    EditBox {
        id: passcode
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: title.bottom
        anchors.margins: 5
        height: Screen.pixelDensity * 9
        echo: TextInput.PasswordEchoOnEdit
    }
    ImageButton {
        id: login
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: passcode.bottom
        anchors.margins: 5
        height: textHeight + mmItemMargin * 4
        width: textWidth + mmItemMargin * 4
        imageSource: imageRoot + "green_button.png"
        pressedImageSource: imageRoot + "gray_button.png"
        title: qsTr("Login")
        onClicked: {
            if (main.passcode === passcode.text) {
                passcodeChallenge.done();
            } else {
                showBypassOption = true;
            }
        }
    }
    Text {
        id: information
        visible: showBypassOption
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: login.bottom
        anchors.margins: 10
        width: parent.width
        elide: Text.ElideMiddle
        text: qsTr("You can bypass the passcode, but you will have to enter your API key and passcode again.")
        font.pointSize: largeFonts ? 16 : 12
        wrapMode: Text.WordWrap
    }
    ImageButton {
        id: bypass
        visible: showBypassOption
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: information.bottom
        anchors.margins: 5
        height: textHeight + mmItemMargin * 4
        width: textWidth + mmItemMargin * 4
        imageSource: imageRoot + "red_button.png"
        pressedImageSource: imageRoot + "gray_button.png"
        title: qsTr("Bypass")
        onClicked: {
            main.dataKey = "";
            main.passcode = "";
            main.username = "";
            main.instanceList = "";
            main.instanceListKeys = "";
            passcodeChallenge.done();
        }
    }
}
