import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    id: settings
    width: screen.width
    height: screen.height
    color:"ivory"

    property string availableFields : "none,update_time,accessible,api_type,data_type,deleted,file_ext,file_size,genome_build,hda_ldda,hid,history_content_type,history_id,id,metadata_chromCol,metadata_columns,metadata_data_lines,metadata_dbkey,metadata_endCol,metadata_nameCol,metadata_startCol,metadata_strandCol,misc_blurb,model_class,name,purged,uuid,visible"

    function findField(fieldName) {
        if (screen.fieldList.indexOf(fieldName) >= 0) {
            return true;
        }

        return false;
    }

    function getCurrentSelection(posIndex) {
        var fieldArray = screen.fieldList.split(",");
        return availableFields.split(",").indexOf(fieldArray[posIndex]);
    }

    function setFields() {
        if (firstField.textAt(firstField.currentIndex) && secondField.textAt(secondField.currentIndex) &&
                thirdField.textAt(thirdField.currentIndex) && fourthField.textAt(fourthField.currentIndex) &&
                fifthField.textAt(fifthField.currentIndex)) {

            screen.fieldList = firstField.textAt(firstField.currentIndex) + "," +
                                secondField.textAt(secondField.currentIndex) + "," +
                                thirdField.textAt(thirdField.currentIndex) + "," +
                                fourthField.textAt(fourthField.currentIndex) + "," +
                                fifthField.textAt(fifthField.currentIndex);
        }
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

    function handleOverlap(item) {
        var fields = [update_time, misc_blurb]

        for (var i = 0; i < fields.length; ++i)
        {
          var field = fields[i];

          if (item !== field)
          {
              if (item.x + item.width > field.x &&
                      item.x < field.x + field.width)
              {
                  if (item.x > field.x) {
                      item.x = field.x + field.width;
                  } else {
                      item.x = field.x - item.width;
                  }

                  // Hadnled one, now do it recursively to handle all fields.
                  handleOverlap(item);
                  return;
              }
          }
        }
    }


    // Action bar
    ActionBar {
        id: settingsActionBar
        width: settings.width
        height: Screen.pixelDensity * 9
        backButton.visible: true
        // Paste button is visible if an editbox has focus.
        pasteButton.visible: galaxyUrl.hasActiveFocus || galaxyKey.hasActiveFocus || passcodeField.hasActiveFocus
        backState: screen.state
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
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
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
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            inputMethodHints: Qt.ImhUrlCharactersOnly
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
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            elide: Text.ElideMiddle
            text: "API Key"
            font.pointSize: 15
            font.bold: true
        }
        Text {
            id: galaxyKeyTitleDescription
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: galaxyKeyTitle.bottom
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            elide: Text.ElideMiddle
            text: "(Generate 'API Keys' in the Galaxy User menu)"
            font.pointSize: 12
        }
        EditBox {
            id: galaxyKey
            anchors.top: galaxyKeyTitleDescription.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            text: dataKey
            onEditDone: {
                dataKey = galaxyKey.text;
            }
        }
        CheckBox {
            id: enableBaseAuth
            anchors.top: galaxyKey.bottom
            anchors.left: parent.left
            anchors.leftMargin: Screen.pixelDensity
            anchors.rightMargin: Screen.pixelDensity
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            width: settings.width - Screen.pixelDensity
            height: Screen.pixelDensity * 9
            text: qsTr("Retrieve API Key with login")
            checked: false
        }
        Text {
            id: baseAuthUsernameTitle
            visible: enableBaseAuth.checked ? true : false
            anchors.top: enableBaseAuth.bottom
            anchors.left: parent.left
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            elide: Text.ElideMiddle
            text: "Username"
            font.pointSize: 12
        }
        EditBox {
            id: baseAuthUsername
            visible: enableBaseAuth.checked ? true : false
            anchors.top: baseAuthUsernameTitle.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
        }
        Text {
            id: baseAuthPasswordTitle
            visible: enableBaseAuth.checked ? true : false
            anchors.top: baseAuthUsername.bottom
            anchors.left: parent.left
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            elide: Text.ElideMiddle
            text: "Password"
            font.pointSize: 12
        }
        EditBox {
            id: baseAuthPassword
            visible: enableBaseAuth.checked ? true : false
            anchors.top: baseAuthPasswordTitle.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            echo: TextInput.PasswordEchoOnEdit
        }
        ImageButton {
            id: executeBaseAuth
            visible: enableBaseAuth.checked ? true : false
            anchors.left: parent.left
            anchors.top: baseAuthPassword.bottom
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            height: image.sourceSize.height
            width: image.sourceSize.width
            imageSource: "qrc:/resources/resources/images/green_button_100_32.png"
            pressedImageSource: "qrc:/resources/resources/images/green_button_100_32_pressed.png"
            title: "Login"
            onClicked: {
                // Retrieve API Key.
                dataKey = "retrieving API...";
                var authorizationHeader = "Basic "+Qt.btoa(baseAuthUsername.text+":"+baseAuthPassword.text);
                var xhr = new XMLHttpRequest();
                xhr.open("GET", screen.dataSource + "/api/authenticate/baseauth");
                xhr.setRequestHeader("Authorization", authorizationHeader);
                xhr.setRequestHeader('Accept-Language', 'en');
                xhr.onreadystatechange = function() {
                  if (xhr.readyState === XMLHttpRequest.DONE) {
                      // TODO: timeout
                      if (xhr.status === 200) {
                          var jsonObject = JSON.parse(xhr.responseText);
                          dataKey = jsonObject["api_key"].toString();

                      }
                      else
                      {
                          dataKey = "Error - check URL, username and password";
                      }
                  }
                }
                xhr.send();
            }
        }
        Text {
            id: pollFrequencyTitle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: enableBaseAuth.checked ? executeBaseAuth.bottom : enableBaseAuth.bottom
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            elide: Text.ElideMiddle
            text: "Poll server every " + pollFrequencyField.value + " minutes (0 no polling)."
            font.pointSize: 12
        }
        Slider {
            id: pollFrequencyField
            anchors.top: pollFrequencyTitle.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            value: periodicPolls / 60000
            stepSize: 1
            minimumValue: 0
            maximumValue: 60
            onValueChanged: {
                // Set poll interval in ms (from minutes) - remember zero is no polling.
                screen.periodicPolls = pollFrequencyField.value * 60000;
            }
        }

        // Config settings for fields.
        Text {
            id: fieldConfigTitle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: pollFrequencyField.bottom
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            elide: Text.ElideMiddle
            text: "Job Fields"
            font.pointSize: 15
            font.bold: true
        }
        CheckBox {
            id: advanced_fields
            anchors.top: fieldConfigTitle.bottom
            anchors.left: parent.left
            anchors.leftMargin: Screen.pixelDensity
            anchors.rightMargin: Screen.pixelDensity
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            width: settings.width - Screen.pixelDensity
            height: Screen.pixelDensity * 9
            text: qsTr("Enable Advanced Fields")
            checked: screen.advancedFields
            onClicked: {
                screen.advancedFields = !screen.advancedFields;
            }
        }
        ComboBox {
            id: firstField
            anchors.top: advanced_fields.bottom
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            anchors.left: parent.left
            anchors.right: parent.right
            height: Screen.pixelDensity * 9
            currentIndex: getCurrentSelection(0)
            model: availableFields.split(",")
            onCurrentIndexChanged: {
                setFields();
            }
        }
        ComboBox {
            id: secondField
            anchors.top: firstField.bottom
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            anchors.left: parent.left
            anchors.right: parent.right
            height: Screen.pixelDensity * 9
            currentIndex: getCurrentSelection(1)
            model: availableFields.split(",")
            onCurrentIndexChanged: {
                setFields();
            }
        }
        ComboBox {
            id: thirdField
            anchors.top: secondField.bottom
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            anchors.left: parent.left
            anchors.right: parent.right
            height: Screen.pixelDensity * 9
            currentIndex: getCurrentSelection(2)
            model: availableFields.split(",")
            onCurrentIndexChanged: {
                setFields();
            }
        }
        ComboBox {
            id: fourthField
            anchors.top: thirdField.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            height: Screen.pixelDensity * 9
            currentIndex: getCurrentSelection(3)
            model: availableFields.split(",")
            onCurrentIndexChanged: {
                setFields();
            }
        }
        ComboBox {
            id: fifthField
            anchors.top: fourthField.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            height: Screen.pixelDensity * 9
            currentIndex: getCurrentSelection(4)
            model: availableFields.split(",")
            onCurrentIndexChanged: {
                setFields();
            }
        }

        // Passcode.
        CheckBox {
            id: passcodeEnabledField
            anchors.top: fifthField.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
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
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
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
            anchors.topMargin: Screen.pixelDensity * 2; anchors.bottomMargin: Screen.pixelDensity * 2
            anchors.leftMargin: Screen.pixelDensity; anchors.rightMargin: Screen.pixelDensity
            text: passcode
            echo: TextInput.PasswordEchoOnEdit
            onEditDone: {
                passcode = passcodeField.text;
            }
        }
    }
}
