import QtQuick 2.3

Rectangle {
    anchors.fill: parent
    Text {
        id: welcome
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 10
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        text: "Welcome"
        font.pointSize: 12
        font.bold: true
    }
    Text {
        id: url
        anchors.top: welcome.bottom
        anchors.margins: 10
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        wrapMode: Text.WordWrap
        text: "Current Galaxy URL: " + dataSource
        font.pointSize: 11
    }
    Text {
        id: httpStatus
        anchors.top: url.bottom
        anchors.margins: 10
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        wrapMode: Text.WordWrap
        text: dataSource.length > 0 && dataKey.length > 0 ? "Connection Status: " + jsonHistoriesModel.error : "Please set Galaxy URL and API Key"
        font.pointSize: 11
        color: jsonHistoriesModel.error.length > 0 ? "red" : "black"
        font.bold: true
    }
    Text {
        id: instructions
        anchors.top: httpStatus.bottom
        anchors.margins: 10
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        wrapMode: Text.WordWrap
        text: "Select the cog wheel on the right in the top action bar to configure."
        font.pointSize: 11
    }
    Text {
        id: userguide
        anchors.top: instructions.bottom
        anchors.topMargin: 30
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        text: "Download user guide:"
        font.pointSize: 11
    }
    Text {
        id: userguideURL
        anchors.top: userguide.bottom
        anchors.margins: 10
        horizontalAlignment: Text.AlignHCenter
        width: parent.width
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        text: "<a href=\"https://github.com/Tarostar/QMLGalaxyPortal/blob/master/GalaxyPortalUserGuide.pdf?raw=true\">https://github.com/Tarostar/QMLGalaxyPortal/blob/master/GalaxyPortalUserGuide.pdf?raw=true</a>"
        font.pointSize: 9
    }
}
