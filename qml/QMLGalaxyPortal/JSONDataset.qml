import QtQuick 2.0

Item {
    id: datasetItem

    // URL to connect to.
    property string source: ""

    // JSON data returned by poll.
    property string json: ""

    // Text to display as result of JSON.
    property string text: ""

    property string textMe: "test"

    // Array of all the fields displayed.
    property var fields: []

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
        // update field list before polling
        updateFieldArray();

        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE)
                json = xhr.responseText;
        }
        xhr.send();
    }

    // Update JSON data when source or fields changes.
    onJsonChanged: updateJSONText(JSON.parse(json))

    function updateJSONText(jsonData) {
        datasetItem.text = "";
        // Compose string for each field in field array which exists in the json data (otherwise ignored).
        fields.forEach(function(field) {
            if (jsonData[field])
                datasetItem.text += " <b>" + field + "</b>: " + jsonData[field].toString();
        });

        // Set name property to job name - if exists
        if (jsonData["name"])
            datasetItem.name = jsonData["name"];
    }

    // Init default field array at startup.
    Component.onCompleted:{ updateFieldArray(); }

    function updateFieldArray() {
        if (screen.fieldList.length < 1) {
            // Default fields initialised.
            fields.push("misc_blurb");
            fields.push("data_type");
            fields.push("genome_build");
            fields.push("update_time");
            /*fields.push("metadata_data_lines");
            fields.push("history_content_type");
            fields.push("file_ext");
            fields.push("file_size");*/

            // Set field list to contain the default list
            screen.fieldList = fields.join();
        }
        else {
            // Init field array from fieldList.
            fields = screen.fieldList.split(',');
        }
    }

}
