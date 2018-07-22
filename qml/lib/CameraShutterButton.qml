import QtQuick 2.2

import Sailfish.Silica 1.0

Item {
    id: root
    width: Theme.itemSizeExtraLarge
    height: width
    states:[
        State {
            name: "photo"
            when: !api.modeIsVideo
//            AnchorChanges{target: activeIndicator; anchors.left: root.left; anchors.right: undefined}
            PropertyChanges { target: photoImage; opacity: 1 }
            PropertyChanges { target: videoImage; opacity: 0 }
        },
        State {
            name: "video"
            when: api.modeIsVideo
            PropertyChanges { target: photoImage; opacity: 0 }
            PropertyChanges { target: videoImage; opacity: 1 }
        }
    ]
    Rectangle {
        anchors.fill: parent
        color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
        radius: width / 2
    }

    MouseArea {
        anchors.fill: parent
        onClicked: api.shutter()
    }
    Image {
        id: photoImage
        opacity: 0
        anchors.fill: parent
        source: '../images/icon-m-shutter.svg'
        sourceSize.width: width
        sourceSize.height: height
        Behavior on opacity {
                NumberAnimation {}
            }
    }
    Item {
        id: videoImage
        anchors.fill: parent
        opacity: 0

        Behavior on opacity {
                NumberAnimation {}
            }

        Item {
            id: recordingArea
            width: parent.width / 2
            height: width
            anchors.centerIn: parent
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: api.isrecordingvideo
                onRunningChanged: {
                    if(!running) {
                        recordingArea.opacity = 1
                    }
                }

                PropertyAnimation { to: 1; duration: 900 }
                PropertyAnimation { to: 0; duration: 100 }
                PropertyAnimation { to: 0; duration: 900 }
                PropertyAnimation { to: 1; duration: 100 }
            }


            Rectangle {
                color: Theme.primaryColor
                anchors.fill: parent
                radius: width / 2
            }

            Rectangle {
                width: parent.width * 0.7
                height: width
                color: '#ff0000'
                anchors.centerIn: parent
                radius: width / 2
            }
        }


//        Image {
//            opacity: api.isrecordingvideo ? 0:1
//            anchors.fill: parent
//            source: 'image://theme/icon-m-dot'
//            Behavior on opacity {
//                    NumberAnimation {}
//                }
//        }
//        Image {
//            opacity: api.isrecordingvideo ? 1:0
//            anchors.fill: parent
//            source: 'image://theme/icon-m-video'
//            Behavior on opacity {
//                    NumberAnimation {}
//                }
//        }

    }

//    Label {
//        text: api.isrecordingvideo
//    }
}
