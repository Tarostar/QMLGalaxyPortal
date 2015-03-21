import QtQuick 2.3
import QtQuick.Window 2.2

Rectangle {
    // Set rect to size of all children (+ margin) - or zero if buttons not shown.
    height: main.instanceList.length > 0 || (main.dataKey.length > 0 && main.dataSource.length > 0) ? childrenRect.height + Screen.pixelDensity * 2 : 0

    ImageButton {
        id: save
        visible: main.dataKey.length > 0 && main.dataSource.length > 0
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 5
        height: textHeight + mmItemMargin * 4
        width: textWidth + mmItemMargin * 4
        imageSource: imageRoot + "green_button.png"
        pressedImageSource: imageRoot + "gray_button.png"
        title: qsTr("Save")
        onClicked: {
            focus = true;
            if (main.dataSource.length > 0 && main.dataKey.length > 0) {
                main.instanceList.length > 0 ? main.instanceList += "," + main.dataSource : main.instanceList = main.dataSource;
                main.instanceListKeys.length > 0 ? main.instanceListKeys += "," + main.dataKey : main.instanceListKeys = main.dataKey;
            }
        }
    }
    ImageButton {
        id: load
        visible: main.instanceList.length > 0
        anchors.left: save.right
        anchors.top: parent.top
        anchors.margins: 5
        height: textHeight + mmItemMargin * 4
        width: textWidth + mmItemMargin * 4
        imageSource: imageRoot + "green_button.png"
        pressedImageSource: imageRoot + "gray_button.png"
        title: qsTr("Load")
        onClicked: {
            focus = true;
            mainLoader.source = "InstanceList.qml";
            mainLoader.item.populateInstanceModel();
        }
    }
}
