import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle {
    id: settings
    width: screen.width
    height: screen.height
    color:"ivory"

    property string availableFields: "none,update_time,accessible,api_type,data_type,deleted,file_ext,file_size,genome_build,hda_ldda,hid,history_content_type,history_id,id,metadata_chromCol,metadata_columns,metadata_data_lines,metadata_dbkey,metadata_endCol,metadata_nameCol,metadata_startCol,metadata_strandCol,misc_blurb,model_class,name,purged,uuid,visible"

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
        width: screen.width
        height: Screen.pixelDensity * 9
        settingsButton.visible: false
        backButton.visible: true
        backState: screen.state
    }
    // Text input for Galaxy URL for API access.
    Flickable {
        anchors.top: settingsActionBar.bottom
        width: parent.width
        height: parent.height - settingsActionBar.height
        contentWidth: contentItem.childrenRect.width
        contentHeight: contentItem.childrenRect.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        Text {
            id: galaxyUrlTitle
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
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
            text: "(Generate 'API Keys' in the Galaxy User menu)"
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
            echo: TextInput.PasswordEchoOnEdit
            onEditDone: {
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
        CheckBox {
            id: advanced_fields
            anchors.top: fieldConfigTitle.bottom
            anchors.left: parent.left
            anchors.margins: 10
            height: Screen.pixelDensity * 9
            text: qsTr("Enable Advanced Fields")
            checked: screen.advancedFields
            onClicked: {
                screen.advancedFields = !screen.advancedFields;

                /*if (screen.advancedFields) {
                    // Hide advanced field config.
                    container.visible = true;
                } else {
                    // Show advanced field config.
                    container.visible = false;
                }*/

            }
        }
        ComboBox {
            id: firstField
            anchors.top: advanced_fields.bottom
            anchors.topMargin: 5
            width: settings.width
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
            anchors.topMargin: 5
            width: settings.width
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
            anchors.topMargin: 5
            width: settings.width
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
            anchors.topMargin: 5
            width: settings.width
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
            anchors.topMargin: 5
            width: settings.width
            height: Screen.pixelDensity * 9
            currentIndex: getCurrentSelection(4)
            model: availableFields.split(",")
            onCurrentIndexChanged: {
                setFields();
            }
        }
    }

    /*Rectangle {
        id: container
        visible: screen.advancedFields
        anchors.top: advanced_fields.bottom
        anchors.topMargin: 5
        width: settings.width
        height: Screen.pixelDensity * 9

        // TODO: these rectangles should be a file so they can be re-used
        DraggableCheckbox {
            id: update_time
            fieldName: qsTr("Update Time")
            fieldID: "update_time"
            onDropItem: handleOverlap(update_time)
        }
        DraggableCheckbox {
            id: misc_blurb
            fieldName: qsTr("Misc Blurb")
            fieldID: "misc_blurb"
            onDropItem: handleOverlap(misc_blurb);
        }
    }*/
}
