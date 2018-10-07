import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

import '../lib'

Page {
    id: page

    allowedOrientations: Orientation.All
    property ListModel fileListModel
    property int startIndex:0
    property bool showDetail: false

//    Rectangle {
//        color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
//        anchors.fill: parent
//    }
    function humanFileSize(size) {
        var i = size === 0 ? 0 : Math.floor( Math.log(size) / Math.log(1024) );
        return ( size / Math.pow(1024, i) ).toFixed(2) * 1 + ' ' + ['B', 'kB', 'MB', 'GB', 'TB'][i];
    }
    function stripDirs(filepath) {
        return filepath.replace(/^.*[\\\/]/, '');
    }

    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                visible: slideShowView.currentItem._rawImage !== ''
                text: qsTr('Download DNG + JPG')
                onClicked: {
                    api.downloadFiles([api.httpDownloadBase+slideShowView.currentItem._rawImage, api.httpDownloadBase+slideShowView.currentItem._fileName])
                }

                Label {
                    color: parent.color
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeTiny
                    text: page.humanFileSize(slideShowView.currentItem._rawBytes + slideShowView.currentItem._bytes)
                }
            }
            MenuItem {
                visible: slideShowView.currentItem._rawImage !== ''
                text: qsTr('Download %1', 'Download RAW XYZ.dng').arg(stripDirs(slideShowView.currentItem._rawImage))
                onClicked: {
                    api.downloadFiles([api.httpDownloadBase+slideShowView.currentItem._rawImage])
                }
                Label {
                    color: parent.color
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeTiny
                    text: page.humanFileSize(slideShowView.currentItem._rawBytes)
                }
            }
            MenuItem {
                text: qsTr('Download %1', 'Download XYZ.jpg').arg(stripDirs(slideShowView.currentItem._fileName))
                onClicked: {
                    api.downloadFiles([api.httpDownloadBase+slideShowView.currentItem._fileName])
                }
                Label {
                    color: parent.color
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: Theme.fontSizeTiny
                    text: page.humanFileSize(slideShowView.currentItem._bytes)
                }
            }
        }

        SlideshowView {
            id: slideShowView
            anchors.fill: parent
            clip: true
            itemWidth: width
            itemHeight: height
            pathItemCount: 3
            currentIndex: page.startIndex

            transitions: [
                Transition {
                    NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
                }]

            model: page.fileListModel
            delegate: Item {
                property bool _isVideo: isVideo
                property string _previewVideo: previewVideo
                property string _previewImage: previewImage
                property string _fileName: fileName
                property int _bytes: bytes
                property string _rawImage: rawImage
                property int _rawBytes: rawBytes

                width: page.width
                height: page.height

                CameraFilePreviewItem {
//                    size: listView.cellWidth
                    width: page.width
                    height: page.height
                    isVideo: parent._isVideo
                    previewVideo: parent._previewVideo
                    previewImage: parent._previewImage
                    fileName: parent._fileName
                    fillImage: false
                    showTypeIcon: isVideo && (videoElement && videoElement.playbackState !== MediaPlayer.PlayingState)
                    onClicked: {
                        if(isVideo && videoElement) {
                            if(videoElement.playbackState == MediaPlayer.PlayingState) {
                                videoElement.pause()
                            } else {
                                videoElement.play()
                            }

                        }
                    }

                    Component.onCompleted: {
                        //                        console.log(fileName)
                        //                    isVideo= data.isVideo
                        //                    previewVideo= data.previewVideo
                        //                    previewImage= data.previewImage
                        //                    fileName= data.fileName
                    }
                }
            }
            Component.onCompleted: {
                console.log('swipe view', startIndex, fileListModel.count, slideShowView.count)
            }
        }
    }
}
