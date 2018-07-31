import QtQuick 2.0
import QtMultimedia 5.0
import Sailfish.Silica 1.0

VideoOutput {
    id: viewFinder
    property bool useGrid: options.useGrid
    property bool useViewFinder: api.connected && options.useViewFinder &&
                                 !(options.disconnectViewFinderInBackground && (page.status !== PageStatus.Active || Qt.application.state !== Qt.ApplicationActive))
    visible: useViewFinder
    onUseViewFinderChanged: {
        console.log('usevf changed', useViewFinder, 'page inactive',  page.status !== PageStatus.Active, 'app inactive', Qt.application.state !== Qt.ApplicationActive )
        if(!useViewFinder) {
            api.cmd('stopViewFinder');
        } else {

            api.cmd('startViewFinder');
        }
    }

    /* set size manually to prevent binding loop: */
    property real aspectRatio: sourceRect.width / sourceRect.height
    onAspectRatioChanged: setWidth()
    property real parentHeight: parent.height
    onParentHeightChanged: setWidth()
    property real parentWidth: parent.width
    onParentWidthChanged: setWidth()


    Item {
        id: isRecordingItem
        opacity: api.isrecordingvideo?1:0

        anchors.fill: parent
        Rectangle {
            color: Theme.rgba(Theme.highlightDimmerColor, Theme.highlightBackgroundOpacity)
           anchors.fill: parent
        }
        Label {
            anchors.fill: parent
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr('Camera Viewport is not available while recording.')
        }

        Behavior on opacity {
                NumberAnimation {}
            }

    }

    function setWidth(){
        var preferredWidth = parentWidth,
           preferredHeight = preferredWidth / aspectRatio,
                returnedWidth;
        if(preferredHeight > parentHeight) {
            returnedWidth = parentHeight * aspectRatio
        } else {
            returnedWidth = preferredWidth
        }
        width = returnedWidth
//        widthAnimation.to = returnedWidth
//        widthAnimation.start()
    }
//    anchors.horizontalCenter: parent.horizontalCenter
    anchors.centerIn: parent
    width: parentWidth
    height: width / aspectRatio
    source: MediaPlayer {
        id: mediaPlayer
        property string url: api.streamUrl
        property bool vfstarted: api.vfstarted && options.useViewFinder
        onVfstartedChanged: {
            console.log('video:', vfstarted, url)
            if(vfstarted) {
                source = url
            } else {
                source = ''
                stop()
            }
        }
//        onBufferProgressChanged: {
//            if(bufferProgress === MediaPlayer.Buffered) {
//                play()
//            }
//        }

        source: ''
        autoLoad: true
        autoPlay: true
        onErrorStringChanged: {
            console.log('video error', errorString)
        }
    }
    Item {
        id: grid
        property int lineWidth: 3
        property color lineBgColor: Theme.highlightColor
        property color lineColor: Theme.primaryColor
        opacity: 0.5
        anchors.fill: parent
        visible: viewFinder.useGrid
                 && mediaPlayer.vfstarted
                 && mediaPlayer.playbackState === MediaPlayer.PlayingState
//                 && mediaPlayer.bufferProgress === MediaPlayer.Buffered
        Item {
            id: horizontalLines
            height: parent.height / 3
            width: parent.width
            anchors.centerIn: parent
            Rectangle {
                height: grid.lineWidth
                color: grid.lineBgColor
                width: parent.width
                anchors.top: parent.top
                anchors.left: parent.left
                y: -height/2
                Rectangle {
                    anchors.centerIn: parent
                    height: parent.height / 3
                    width: parent.width
                    color: grid.lineColor
                }
            }
            Rectangle {
                height: grid.lineWidth
                color: grid.lineBgColor
                width: parent.width
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                y: height/2

                Rectangle {
                    anchors.centerIn: parent
                    height: parent.height / 3
                    width: parent.width
                    color: grid.lineColor
                }
            }
        }
        Item {
            id: verticalLines
            height: parent.height
            width: parent.width / 3
            anchors.centerIn: parent
            Rectangle {
                width: grid.lineWidth
                color: grid.lineBgColor
                height: parent.height
                anchors.top: parent.top
                anchors.left: parent.left
                y: -height/2

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width / 3
                    height: parent.height
                    color: grid.lineColor
                }
            }
            Rectangle {
                width: grid.lineWidth
                color: grid.lineBgColor
                height: parent.height
                anchors.top: parent.top
                anchors.right: parent.right
                y: height/2
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width / 3
                    height: parent.height
                    color: grid.lineColor
                }
            }
        }

    }
}
