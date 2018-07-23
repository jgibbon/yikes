import QtQuick 2.2
import Sailfish.Silica 1.0

import QtMultimedia 5.0

Item {
    id: connectedView
    anchors.fill: parent
    states: [
        State {
            name: "landscape"
            when: page.isLandscape
            AnchorChanges {
                target: shutterArea
                anchors.bottom: undefined
                anchors.horizontalCenter: undefined
                anchors.right: connectedView.right
                anchors.verticalCenter: connectedView.verticalCenter
            }
        },
        State {
            name: "portrait"
            when: page.isPortrait
            AnchorChanges {
                target: shutterArea
                anchors.bottom: connectedView.bottom
                anchors.horizontalCenter: connectedView.horizontalCenter
                anchors.right: undefined
                anchors.verticalCenter: undefined
            }
        }
    ]
//    PropertyAnimation on opacity {
//        duration: 1000
//    }
    MouseArea {
        id: modeSelectDrag
        property int startX: 0
        property int startY: 0
        anchors.fill: parent
        onPressed: {
            startX= mouse.x
            startY= mouse.y
            console.log('onpressed', x, y)
        }
        onReleased: {
            console.log('onreleased', Math.abs(startX - mouse.x), Math.abs(startY - mouse.y))
            var moveX = Math.abs(startX - mouse.x);
            var moveY = Math.abs(startY - mouse.y);
            if(moveY < Theme.itemSizeExtraLarge && moveX > Theme.itemSizeMedium && moveX > moveY) {
                if(startX > mouse.x) {
//                    cameraModeSwitcher.setVideo()
                    cameraModeMainSwitcher.swipedLeft()
                } else {
//                    cameraModeSwitcher.setPhoto()
                    cameraModeMainSwitcher.swipedRight()
                }
            }
        }
    }

    Item {
        id: viewFinderArea
//        opacity: 0.3
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
//            topMargin: Theme.paddingMedium
        }

        ViewFinder {
            id: viewFinder
        }
    }
    CameraBatteryIndicator {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: Theme.paddingMedium
    }

    Item {
        id: cameraModeSelectArea
        width: parent.width
        height: Theme.itemSizeMedium
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            margins: Theme.paddingMedium
        }
        CameraModeMainSwitcher {
            id: cameraModeMainSwitcher
        }
    }

    Item {
        id: cameraSubModeSelectArea
        width: Theme.itemSizeSmall
        height: parent.height
        anchors {
            top: parent.top
            left: parent.left
            margins: Theme.paddingMedium
        }

        CameraModeSubSwitcher {
            id: cameraModeSubSwitcher
            anchors.centerIn: parent
        }
    }
    Item {
        id: shutterArea
        width: Theme.itemSizeExtraLarge
        height: Theme.itemSizeExtraLarge
        CameraShutterButton{

        }
    }

}
