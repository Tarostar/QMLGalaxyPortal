import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {
    id: instanceListView
    width: main.width
    height: main.height

    ListModel { id: instanceModel }

    function populateInstanceModel() {
        instanceModel.clear();

        // Convert strings to arrays for easier manipulation.
        var instanceArray = main.instanceList.split(",");
        var keyArray = main.instanceListKeys.split(",");

        // Add all instances to the model to display as list.
        for (var index = 0; index < instanceArray.length; index++) {
            instanceModel.append({"index": index, "url": instanceArray[index], "key": keyArray[index]});
        }
    }

    function deleteInstance(index) {
        // Convert strings to arrays for easier manipulation.
        var instanceArray = main.instanceList.split(",");
        var keyArray = main.instanceListKeys.split(",");

        if (index < 0 || index > instanceArray.length) {
            return;
        }

        // Remove item from list.
        instanceArray.splice(index, 1);
        keyArray.splice(index, 1);

        // Convert back to strings (for storage).
        main.instanceList = instanceArray.join();
        main.instanceListKeys = keyArray.join();

        // Re-populate model.
        populateInstanceModel();
    }

    ActionBar {
        id: instanceListActionBar
        width: parent.width
        height: Screen.pixelDensity * 9
        backButton.visible: true
        backState: main.state
        backSource: "Settings.qml";
        actionBarTitle: "Instances (" + instanceModel.count + ")"
    }

    ListView {
        id: instanceList
        anchors.top: instanceListActionBar.bottom
        width: parent.width
        height: parent.height - instanceListActionBar.height
        model: instanceModel
        delegate: InstanceDelegate{}
        clip: true
        boundsBehavior: Flickable.StopAtBounds
    }
}

