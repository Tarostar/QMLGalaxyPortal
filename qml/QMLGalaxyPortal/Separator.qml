import QtQuick 2.3

Rectangle {
    // Acccess to override default colours.
    property alias topColor: topLine.color
    property alias middleColor: middleLine.color
    property alias bottomColor: bottomLine.color

    property int lineWidth : 1
    property int margin : 0

    height: childrenRect.height + margin

    Rectangle { id: topLine; color: "white"; width: parent.width; height: lineWidth; anchors.verticalCenter: parent.verticalCenter }
    Rectangle { id: middleLine; color: "#cdcdc1"; width: parent.width; height: lineWidth; anchors.top: topLine.bottom}
    Rectangle { id: bottomLine; color: "white"; width: parent.width; height: lineWidth; anchors.top: middleLine.bottom }
}
