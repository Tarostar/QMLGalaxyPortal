import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    // Set rect to size of all children (+ margin).
    height: childrenRect.height + Screen.pixelDensity * 2

    property bool editFocus: baseAuthUsername.hasActiveFocus || baseAuthPassword.hasActiveFocus

    Text {
        id: baseAuthUsernameTitle
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("Username")
        font.pointSize: 12
    }
    EditBox {
        id: baseAuthUsername
        anchors.top: baseAuthUsernameTitle.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
    }
    Text {
        id: baseAuthPasswordTitle
        anchors.top: baseAuthUsername.bottom
        anchors.left: parent.left
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        elide: Text.ElideMiddle
        text: qsTr("Password")
        font.pointSize: 12
    }
    EditBox {
        id: baseAuthPassword
        anchors.top: baseAuthPasswordTitle.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        echo: TextInput.PasswordEchoOnEdit
    }
    ImageButton {
        id: executeBaseAuth
        anchors.left: parent.left
        anchors.top: baseAuthPassword.bottom
        anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
        anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        height: image.sourceSize.height
        width: image.sourceSize.width
        imageSource: "qrc:/resources/resources/images/green_button_100_32.png"
        pressedImageSource: "qrc:/resources/resources/images/green_button_100_32_pressed.png"
        title: qsTr("Login")
        onClicked: {
            // Retrieve API Key.
            dataKey = "retrieving API...";
            var authorizationHeader = "Basic "+Qt.btoa(baseAuthUsername.text+":"+baseAuthPassword.text);
            var xhr = new XMLHttpRequest();
            xhr.open("GET", galaxyUrl.text + "/api/authenticate/baseauth");
            xhr.setRequestHeader("Authorization", authorizationHeader);
            xhr.setRequestHeader('Accept-Language', 'en');
            xhr.onreadystatechange = function() {
              if (xhr.readyState === XMLHttpRequest.DONE) {
                  httpTimeout.running = false;
                  if (xhr.status === 200) {
                      var jsonObject = JSON.parse(xhr.responseText);
                      dataKey = jsonObject["api_key"].toString();

                  } else {
                      dataKey = "Error - check URL, username and password";
                  }
              }
            }
            httpTimeout.running = true;
            xhr.send();
        }

        // Timeout handling since Qt XMLHttpRequest does not support "timeout".
        Timer {
            id: httpTimeout
            interval: 5000 // 5 seconds interval, should eventually be user configurable.
            repeat: false
            running: false
            onTriggered: {
                dataKey = "Timed out after " + httpTimeout.interval / 1000 + " seconds.";
            }
        }
    }
}
