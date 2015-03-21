import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import "utils.js" as Utils

Rectangle {
    id: galaxyAuthentication
    // Set rect to size of all children (+ margin).
    height: childrenRect.height + Screen.pixelDensity * 2

    property bool editFocus: baseAuthUsername.hasActiveFocus || baseAuthPassword.hasActiveFocus
    property string statusMessages: ""

    function onReady(request) {

        if (request === undefined) {
            statusMessages = "Timed out after five seconds.";
            galaxyLoginStatus.color = "red";
            return;
        }

        if (request.readyState === XMLHttpRequest.DONE) {
            if (request.status === 200) {
                var jsonObject = JSON.parse(request.responseText);
                dataKey = jsonObject["api_key"].toString();
                statusMessages = "Login Success"
                galaxyLoginStatus.color = "green";
            } else {
                statusMessages = "Error - check URL, username and password";
                galaxyLoginStatus.color = "red";
            }
        }
    }

    function pasteKey(){
        if (baseAuthUsername.hasActiveFocus) {
            baseAuthUsername.paste();
        } else {
            baseAuthPassword.paste();
        }
    }

    Separator {
        id: separator
        anchors.top: parent.top
        width: parent.width
        color: parent.color
    }
    Text {
        id: galaxyLogin
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: separator.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("Login")
        font.pointSize: largeFonts ? 20 : 15
        font.bold: true
    }
    Text {
        id: baseAuthUsernameTitle
        anchors.top: galaxyLogin.bottom
        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("Username")
        font.pointSize: largeFonts ? 16 : 12
    }
    EditBox {
        id: baseAuthUsername
        anchors.top: baseAuthUsernameTitle.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        text: username
        onEditDone: {
            // edit field lost focus, or return/enter was pressed so update current app URL.
            username = baseAuthUsername.text;
        }
    }
    Text {
        id: baseAuthPasswordTitle
        anchors.top: baseAuthUsername.bottom
        anchors.left: parent.left
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("Password")
        font.pointSize: largeFonts ? 16 : 12
    }
    EditBox {
        id: baseAuthPassword
        anchors.top: baseAuthPasswordTitle.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        echo: TextInput.Password
    }
    ImageButton {
        id: executeBaseAuth
        anchors.left: parent.left
        anchors.top: baseAuthPassword.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        height: textHeight + mmItemMargin * 4
        width: textWidth + mmItemMargin * 4
        imageSource: imageRoot + "green_button.png"
        pressedImageSource: imageRoot + "gray_button.png"
        title: qsTr("Login")
        onClicked: {
            // Retrieve API Key.
            dataKey = "";
            statusMessages = "retrieving API...";
            galaxyLoginStatus.color = "black";

            Utils.poll(galaxyUrl.text + "/api/authenticate/baseauth", onReady, galaxyAuthentication, "Basic " + Qt.btoa(baseAuthUsername.text + ":" + baseAuthPassword.text));
        }
    }
    Text {
        id: galaxyLoginStatus
        anchors.top: baseAuthPassword.bottom
        anchors.left: executeBaseAuth.right
        anchors.topMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity * 2
        anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: statusMessages
        font.pointSize: largeFonts ? 16 : 12
    }
}
