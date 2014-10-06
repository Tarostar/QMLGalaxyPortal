import QtQuick 2.0

Item {
    // Model that holds items to be displayed.
    /*property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count*/

    // Text to display as result of JSON.
    property string displayText: ""

    // Array of all the fields displayed.
    property var detailFields: []

    property string source: ""
    property string json: ""

    property string name: ""

    onSourceChanged: {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE)
                json = xhr.responseText;
        }
        xhr.send();
    }

    // Update JSON data when source changes.
    onJsonChanged: {updateJSONStrings(JSON.parse(json))}

    function updateJSONStrings(jsonData) {
        displayText = "";
        // Compose string for each field in field array which exists in the json data (otherwise ignored).
        detailFields.forEach(function(field) {
            if (jsonData[field])
                displayText += " <b>" + field + "</b>: " + jsonData[field].toString();
        });

        // Set name property to job name - if exists
        if (jsonData["name"])
            name = jsonData["name"];
    }

    // Init default field array at startup.
    Component.onCompleted:{ initFieldArray(); }

    function initFieldArray() {
        detailFields.push("misc_blurb");
        detailFields.push("data_type");
        detailFields.push("genome_build");
        detailFields.push("update_time");
        /*detailFields.push("metadata_data_lines");
        detailFields.push("history_content_type");
        detailFields.push("file_ext");
        detailFields.push("file_size");*/
    }

}
