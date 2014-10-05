import QtQuick 2.3
import QtQuick.Window 2.2
import "utils.js" as Utils
import "jsonpath.js" as JSONPath

Rectangle {
    id: details
    width: screen.width
    height: screen.height
    color: "ivory"

    property string source: dataSource + "/api/histories/" + screen.currentHistoryID + "/contents/datasets/" + screen.currentJobID + "?key=" + dataKey;
    property string json: ""

    property string jsonDetails: ""

    onSourceChanged: {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE)
                json = xhr.responseText;
        }
        xhr.send();
    }

    onJsonChanged: {updateJSONStrings(JSON.parse(json))}

    function updateJSONStrings(jsonData) {
        detailsActionBar.actionBarTitle.text = jsonData.name;

        misc_blurb.text = jsonData.misc_blurb;
        file_ext.text = jsonData.file_ext;
        file_size.text = jsonData.file_size;
        peek.text = jsonData.peek;
        update_time.text = jsonData.update_time;
        data_type.text = jsonData.data_type;
        genome_build.text = jsonData.genome_build;
        metadata_data_lines.text = jsonData.metadata_data_lines;
        history_content_type.text = jsonData.history_content_type;
        // name.text = jsonData.name;
        details.color = Utils.itemColour(jsonData.state, false);
    }

    // Action bar
    ActionBar {
        id: detailsActionBar
        width: screen.width
        height: Screen.pixelDensity * 9
        settingsButton.visible: false
        backButton.visible: true
        backState: screen.state
    }
    /*Text {
        id: nameTitle
        anchors.left: parent.left
        anchors.top: detailsActionBar.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "Name:"
        font.pixelSize: 15
        font.bold: true
    }
    Text {
        id: name
        anchors.left: nameTitle.right
        anchors.top: detailsActionBar.bottom
        anchors.topMargin: 5
        anchors.leftMargin: 5
        elide: Text.ElideMiddle
        text: ""
        font.pixelSize: 15
    }*/
    Text {
        id: update_timeTitle
        anchors.left: parent.left
        anchors.top: detailsActionBar.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "Update Time:"
        font.pixelSize: 12
        font.bold: true
    }
    Text {
        id: update_time
        anchors.left: update_timeTitle.right
        anchors.top: detailsActionBar.bottom
        anchors.topMargin: 5
        anchors.leftMargin: 5
        elide: Text.ElideMiddle
        text: ""
        font.pixelSize: 12
    }
    Text {
        id: misc_blurbTitle
        anchors.left: parent.left
        anchors.top: update_time.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "Misc:"
        font.pixelSize: 12
        font.bold: true
    }
    Text {
        id: misc_blurb
        anchors.left: misc_blurbTitle.right
        anchors.top: update_time.bottom
        anchors.topMargin: 5
        anchors.leftMargin: 5
        elide: Text.ElideMiddle
        text: ""
        font.pixelSize: 12
    }
    Text {
        id: data_typeTitle
        anchors.left: parent.left
        anchors.top: misc_blurb.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "Data Type:"
        font.pixelSize: 12
        font.bold: true
    }
    Text {
        id: data_type
        anchors.left: data_typeTitle.right
        anchors.top: misc_blurb.bottom
        anchors.topMargin: 5
        anchors.leftMargin: 5
        elide: Text.ElideMiddle
        text: ""
        font.pixelSize: 12
    }
    Text {
        id: genome_buildTitle
        anchors.left: parent.left
        anchors.top: data_type.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "Genome Build:"
        font.pixelSize: 12
        font.bold: true
    }
    Text {
        id: genome_build
        anchors.left: genome_buildTitle.right
        anchors.top: data_type.bottom
        anchors.topMargin: 5
        anchors.leftMargin: 5
        elide: Text.ElideMiddle
        text: ""
        font.pixelSize: 12
    }
    Text {
        id: file_extTitle
        anchors.left: parent.left
        anchors.top: genome_build.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "File Extention:"
        font.pixelSize: 12
        font.bold: true
    }
    Text {
        id: file_ext
        anchors.left: file_extTitle.right
        anchors.top: genome_build.bottom
        anchors.topMargin: 5
        anchors.leftMargin: 5
        elide: Text.ElideMiddle
        text: ""
        font.pixelSize: 12
    }
    Text {
        id: file_sizeTitle
        anchors.left: file_ext.right
        anchors.top: genome_build.bottom
        anchors.topMargin: 5
        anchors.leftMargin: 10
        elide: Text.ElideMiddle
        text: "File Size:"
        font.pixelSize: 12
        font.bold: true
    }
    Text {
        id: file_size
        anchors.left: file_sizeTitle.right
        anchors.top: genome_build.bottom
        anchors.topMargin: 5
        anchors.leftMargin: 5
        elide: Text.ElideMiddle
        text: ""
        font.pixelSize: 12
    }
    Text {
        id: metadata_data_linesTitle
        anchors.left: parent.left
        anchors.top: file_size.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "Metadata Lines:"
        font.pixelSize: 12
        font.bold: true
    }
    Text {
        id: metadata_data_lines
        anchors.left: metadata_data_linesTitle.right
        anchors.top: file_size.bottom
        anchors.topMargin: 5
        anchors.leftMargin: 5
        elide: Text.ElideMiddle
        text: ""
        font.pixelSize: 12
    }
    Text {
        id: history_content_typeTitle
        anchors.left: parent.left
        anchors.top: metadata_data_lines.bottom
        anchors.topMargin: 5
        elide: Text.ElideMiddle
        text: "History Content Type:"
        font.pixelSize: 12
        font.bold: true
    }
    Text {
        id: history_content_type
        anchors.left: history_content_typeTitle.right
        anchors.top: metadata_data_lines.bottom
        anchors.topMargin: 5
        anchors.leftMargin: 5
        elide: Text.ElideMiddle
        text: ""
        font.pixelSize: 12
    }
    Text {
        id: peekTitle
        anchors.left: parent.left
        anchors.top: history_content_type.bottom
        anchors.topMargin: 10
        anchors.bottomMargin: 5
        elide: Text.ElideMiddle
        text: "Peek:"
        font.pixelSize: 15
        font.bold: true
    }
    Text {
        id: peek
        anchors.left: parent.left
        anchors.top: peekTitle.bottom
        anchors.topMargin: 5
        anchors.leftMargin: 5
        elide: Text.ElideMiddle
        text: ""
        font.pixelSize: 12
        textFormat: Text.RichText
    }

}
