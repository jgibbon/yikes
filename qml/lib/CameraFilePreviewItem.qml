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
    property bool showPreview: true
    property bool fillImage: true
    property bool showTypeIcon: true
    property bool videoPlayable: false
    property Video videoElement
    width: size
    height: size

    onClicked: {

    }

    Loader {
        sourceComponent: fileName!== '' && showPreview ?
                               (previewImage === '' && isVideo
                                    ? videoComponent
                                    : imageComponent)
                               : (emptyComponent)
    }
    Component {
        id: emptyComponent
        Item {
            width: root.width
            height: root.height
            Rectangle {
                clip: true
                radius: root.showPreview ? 0 : width / 2
                visible: root.fileName !== ''
                anchors.fill: parent
                color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
            }
        }
    }

    Component {
        id: imageComponent
        Item {
            width: root.width
            height: root.height
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
                width: root.width
                height: root.height
                property string src: previewImage || fileName
                anchors.centerIn: parent
                source: api.httpDownloadBase+src
                sourceSize.width: width
                sourceSize.height: height
                fillMode: root.fillImage ? Image.PreserveAspectCrop : Image.PreserveAspectFit
            }

        }
    }
    Component {
        id: videoComponent
        Item {
            width: root.width
            height: root.height
            Video {
                property bool hasAlreadyPlayed: false //we only get the first image on playback
                source: api.httpDownloadBase+previewVideo
                autoLoad: true
                autoPlay: true
                anchors.fill: parent
                onPlaybackStateChanged: {
                    if(!root.videoPlayable && !hasAlreadyPlayed && playbackState === MediaPlayer.PlayingState) {
                        hasAlreadyPlayed = true
                        pause();
                    }
                }
                Component.onCompleted: {
                    root.videoElement = this;
                }
            }
        }
    }
    Image {
        visible: parent.showTypeIcon && parent.fileName !== ''
        source: parent.isVideo ? 'image://theme/icon-m-play' : 'image://theme/icon-m-image'
        width: parent.width / 3
        height: width
        anchors.centerIn: parent
    }
}
