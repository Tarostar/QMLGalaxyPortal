import QtQuick 2.0
import QtQuick.Window 2.2

Rectangle {
    id: historyItem

    width: parent.width
    // pixelDensity: the number of physical pixels per millimeter.
    height: Screen.pixelDensity * 9;
    //source: "../../Images/" + res[resIndex] + "/item_" + devwidth[widthIndex] + ".png"
    color: "ivory" // "lightsteelblue"

    // Item separator (lighter at the top, darker at the bottom).
    Rectangle { color: "white"; width: parent.width; height: 1 }
    Rectangle { color: "#cdcdc1"; width: parent.width; height: 1; anchors.bottom: parent.bottom }

    // Item title.
    Text {
        id: itemtitle
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 20
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        elide: Text.ElideMiddle
        text: model.name
        font.pixelSize: 15
    }
    // Icon for item.
    Image {
        id: itemIcon
        anchors.right: itemtitle.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 5
        height: parent.height / 2
        width: parent.height / 2
        fillMode: Image.PreserveAspectFit
        // TODO: scale image to resolution
        source: "qrc:/resources/resources/icons/biotech-64.png"
        //source: imagesource
        //onSourceChanged: print(imagesource)
    }

    // Items in the history list are clickable.
    MouseArea {
        // Give user visual feedback of active item through colour shift when hovering over item.
        // Will also result in colour change when item selected through touch giving user feedback.
        hoverEnabled: true
        anchors.fill: parent
        onEntered: {historyItem.color = "lemonchiffon" }
        onPressed: {historyItem.color = "lemonchiffon" }
        onExited: {historyItem.color = "ivory" }
        onReleased: {historyItem.color = "ivory" }
        onPressAndHold: {historyItem.color = "ivory" }

        onClicked: {
            // set current history name
            screen.currentHistory = itemtitle.text;

            // Set json history jobs model source to get jobs for the clicked history.
            jsonHistoryJobsModel.source = dataSource + "/api/histories/" + model.id + "/contents?key=" + dataKey;

            // Trigger the state change to show the jobs list view.
            screen.state = "historyItems";
        }
    }
}
