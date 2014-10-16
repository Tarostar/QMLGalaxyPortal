import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

Dialog {
    id: passcodeChallenge
    visible: true

    width: 400//Screen.width
    height: 400//Screen.height

    title: "Passcode"
    standardButtons: StandardButton.Ok | StandardButton.Abort

    onAccepted: {

        if (screen.passcode === passcode.text)
        {
            passcodeChallenge.close();
        }
    }

    onRejected: {
        screen.dataKey = "";
        screen.passcode = "";
        passcodeChallenge.close();
    }
    Text {
        id: information
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        elide: Text.ElideMiddle
        text: "Aborting will bypass passcode, but your API Key will be reset."
        font.pointSize: 12
        wrapMode: Text.WordWrap
    }
    EditBox {
        id: passcode
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: information.bottom
        anchors.margins: 5
        height: Screen.pixelDensity * 9
        echo: TextInput.PasswordEchoOnEdit
    }
    Button {
        id: bypass
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: passcode.bottom
        height: image.sourceSize.height
        width: image.sourceSize.width
        anchors.rightMargin: 10
       // imageSource: "qrc:/resources/resources/images/red_button_300_96.png"
       // pressedImageSource: "qrc:/resources/resources/images/red_button_300_96.png"
       // title: "Bypass"
        onClicked: {

        }
    }
}
