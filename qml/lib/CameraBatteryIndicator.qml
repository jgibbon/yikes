import QtQuick 2.2
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

Item {
    width: img.width * 2.5
    height: img.height
//    visible: api.battery > -1
    Item {
        id: shadowContainer
        anchors.fill: parent

        Image {
            id: img
            source: api.adapterStatus === 1 ? '../images/icon-m-battery-charging.svg' :'image://theme/icon-m-battery'
            width: Theme.itemSizeSmall / 2
            height: width
            anchors.left: parent.left
            anchors.leftMargin: width / 2
        }
        Rectangle {
            width: img.width * 0.6
            height: width * 0.1
            anchors.right: img.left
            anchors.rightMargin: img.width * -0.2
            anchors.verticalCenter: parent.verticalCenter
            opacity: api.adapterStatus === 1 ? 1 : 0
        }

        Label {
            id: batteryLabel
            anchors.left: img.right
            anchors.verticalCenter: parent.verticalCenter
            text: api.battery + '%'
            font.pixelSize: Theme.fontSizeExtraSmall
        }
    }

    DropShadow {
            anchors.fill: shadowContainer
            horizontalOffset: 0
            verticalOffset: 0
            radius: 2.0
            samples: 2
            color: Theme.highlightBackgroundColor
            source: shadowContainer
        }
}
