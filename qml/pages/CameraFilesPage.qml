import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import '../lib'

Page {
    id: page

    allowedOrientations: Orientation.All
    property bool showDetail: false

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {

            MenuItem {
                visible: fileListModel.count > 0
                text: qsTr('Download all files')
                onClicked: {
                    var len = fileListModel.count;
                    var tmp;
                    var urls = [];
                    for(var i=0;i<len;i++) {
                        tmp = fileListModel.get(i);
                        console.log(i,JSON.stringify(tmp))
                        if(tmp.rawImage !== '') {
                            urls.push(api.httpDownloadBase+tmp.rawImage);
                        }
                        urls.push(api.httpDownloadBase+tmp.fileName)
                    }
                    api.downloadFiles(urls);
                }
            }
        }

        PageHeader {
            id: pageHeader
            title: qsTr('Media on Camera')
        }
        ListModel {
            id: fileListModel
            property var fileList: api.fileList
            function fillModel(){
                clear();
                var keys = Object.keys(fileList);
                for(var i = 0; i < fileList.length; i++) {
                    append(fileList[i])
                }

            }
            onFileListChanged: {
                fillModel()
            }
            Component.onCompleted: {
                fillModel()
            }
        }

        SilicaGridView {
            id: listView
            model: fileListModel
            clip: true
            cellHeight: Theme.itemSizeHuge
            cellWidth: Theme.itemSizeHuge
            anchors {
                top: pageHeader.bottom
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            delegate: Item {
                width: listView.cellWidth
                height: listView.cellHeight
                property bool _isVideo: isVideo
                property string _previewVideo: previewVideo
                property string _previewImage: previewImage
                property string _fileName: fileName

                CameraFilePreviewItem {
                    size: listView.cellWidth
                    isVideo: parent._isVideo
                    previewVideo: parent._previewVideo
                    previewImage: parent._previewImage
                    fileName: parent._fileName
                    showTypeIcon: isVideo

                    Component.onCompleted: {
                        console.log(fileName)
                        //                    isVideo= data.isVideo
                        //                    previewVideo= data.previewVideo
                        //                    previewImage= data.previewImage
                        //                    fileName= data.fileName
                    }
                    onClicked: {
                        console.log('clicked', index)

                        onClicked: pageStack.push(
                                       Qt.resolvedUrl("../pages/CameraFilesDetailPage.qml"),
                                       {fileListModel:fileListModel, startIndex:index})

                    }
                }
            }
        }

    }
}
