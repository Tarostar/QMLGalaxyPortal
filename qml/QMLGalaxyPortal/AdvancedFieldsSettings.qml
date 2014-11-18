import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Rectangle {
    // Set rect to size of all children (+ margin).
    height: childrenRect.height + Screen.pixelDensity * 5

    property string availableFields : "none,update_time,accessible,api_type,data_type,deleted,file_ext,file_size,genome_build,hda_ldda,hid,history_content_type,history_id,id,metadata_chromCol,metadata_columns,metadata_data_lines,metadata_dbkey,metadata_endCol,metadata_nameCol,metadata_startCol,metadata_strandCol,misc_blurb,model_class,name,purged,uuid,visible"

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

    ComboBox {
        id: firstField
        anchors.top: parent.top
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
}
