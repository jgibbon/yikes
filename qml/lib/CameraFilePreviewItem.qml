import QtQuick 2.0
import Sailfish.Silica 1.0

import QtMultimedia 5.0
MouseArea {
    id: root
    property bool isVideo
    property string previewVideo
    property string previewImage
    property string fileName
    property int size: Theme.itemSizeMedium
    onClicked: {
//        pageStack.push(Qt.resolvedUrl("../pages/CameraFilesPage.qml"))
    }
    width: size
    height: size
    onFileNameChanged: {
//        console.log('whoaaa!', previewFileName, isVideo);
    }

    Loader {
        sourceComponent: fileName!== '' ?
                               (previewImage === '' && isVideo
                                    ? videoComponent
                                    : imageComponent)
                               : (emptyComponent)
//        asynchronous: true
    }
    Component {
        id: emptyComponent
        Item {}
    }

    Component {
        id: imageComponent
        Item {
            width: root.size
            height: root.size
            Rectangle {
                opacity: lastFile.progress !== 1.0
                anchors.fill: parent
                color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
                ProgressCircle {
                    width: parent.width / 2
                    height: parent.height / 2
                    anchors.centerIn: parent
                    value: lastFile.progress
                }
            }

            Image {
                id: lastFile
                width: root.size
                height: root.size
                property string src: previewImage || fileName
                anchors.centerIn: parent
                source: 'http://192.168.42.1/DCIM/100MEDIA/'+src
                sourceSize.width: width
                sourceSize.height: height
            }

        }
    }
    Component {
        id: videoComponent
        Item {
            width: root.size
            height: root.size
            Video {
                source: 'http://192.168.42.1/DCIM/100MEDIA/'+previewVideo
                autoLoad: true
                autoPlay: true
                anchors.fill: parent
                onBufferProgressChanged: {
                    console.log('video buffer', bufferProgress)
                }
                onPlaybackStateChanged: {
                    console.log('video play', playbackState)
                    if(playbackState === MediaPlayer.PlayingState) {
                        pause();
                    }
                }
            }
            Image {
                source: 'image://theme/icon-m-video'
                width: parent.width / 3
                height: width
                anchors.centerIn: parent
            }

//            Rectangle {
////                opacity: lastFile.progress !== 1.0
//                anchors.fill: parent
//                color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
////                ProgressCircle {
////                    width: parent.width / 2
////                    height: parent.height / 2
////                    anchors.centerIn: parent
////                    value: lastFile.progress
////                }
//            }
        }
    }

}
