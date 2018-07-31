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

    Rectangle {
        color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
        anchors.fill: parent
    }
        SlideshowView {
            id: slideShowView
            width: parent.width
            height: parent.height
            clip: true
            itemWidth: width
            itemHeight: height
            pathItemCount: 3
//            currentIndex: page.startIndex
            opacity: 0
            anchors {
                top: parent.bottom
                left: parent.left
//                    bottom: parent.bottom
//                    right: parent.right
            }
            transitions: [
                Transition {
                    NumberAnimation { properties: "opacity"; easing.type: Easing.InOutQuad }
                }]

            Rectangle {
                color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
                anchors.fill: parent
            }
            model: page.fileListModel
            delegate: Item {
                property bool _isVideo: isVideo
                property string _previewVideo: previewVideo
                property string _previewImage: previewImage
                property string _fileName: fileName

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
                    onClicked: {
                        page.showDetail = false
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
        }

}
