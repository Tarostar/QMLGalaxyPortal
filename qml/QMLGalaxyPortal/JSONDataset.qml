import QtQuick 2.0

Item {
    id: datasetItem

    // URL to connect to.
    property string source: ""

    // JSON data returned by poll.
    property string json: ""

    // Text to display as result of JSON.
    property string text: ""

    // Array of all the fields displayed.
    property var detailFields: []

    // Name of job item for content.
    property string name: ""

    // Poll frequencey - if zero then does not poll and only retrieves data when source changes.
    property int pollInterval: 0

    // Poll for data when source changes.
    onSourceChanged: {
        poll()

        // Kick timer if enabled.
        if (pollInterval > 0)
            timer.start();
    }

    // Timer triggers periodic poll to retrieve any changes server side.
    Timer {
        id: timer
        interval: pollInterval
        repeat: true
        onTriggered: { poll(); }
    }

    // Poll server using the global XMLHttpRequest (note: does not enforce the same origin policy).
    function poll() {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE)
                json = xhr.responseText;
        }
        xhr.send();
    }

    // Update JSON data when source changes.
    onJsonChanged: updateJSONText(JSON.parse(json))

    function updateJSONText(jsonData) {
        datasetItem.text = "";
        // Compose string for each field in field array which exists in the json data (otherwise ignored).
        detailFields.forEach(function(field) {
            if (jsonData[field])
                datasetItem.text += " <b>" + field + "</b>: " + jsonData[field].toString();
        });

        // Set name property to job name - if exists
        if (jsonData["name"])
            datasetItem.name = jsonData["name"];
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
