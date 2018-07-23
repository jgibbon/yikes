import QtQuick 2.2

import Sailfish.Silica 1.0
Item {
    id: root
    width: parent.width
    property int itemSize: Theme.itemSizeSmall
    CameraModeSwitcher {
        id: photoRoot
        opacity: api.modeIsVideo ? 0:1
        x: api.modeIsVideo ? -parent.width : 0
        isHorizontal: false
        itemSize: root.itemSize
        Behavior on opacity {
            NumberAnimation {}
        }
        Behavior on x {
            NumberAnimation {}
        }
        flow.children: [
            Item {
                width: root.itemSize
                height: root.itemSize

                property var clickedFunc: function() {
                    api.cmd('setCaptureMode', 'precise quality')
                }

                CameraModeHighlightImage {
                    source: 'image://theme/icon-m-camera'
                    highlighted: !api.modeIsVideo && api.settings['capture_mode'] === 'precise quality'
                    onHighlightedChanged: photoRoot.flow.checkHighlighted(this)
                }
            },
            Item {
                width: root.itemSize
                height: root.itemSize

                property var clickedFunc: function() {
                    api.cmd('setCaptureMode', 'precise self quality')
                }

                CameraModeHighlightImage {
                    source: '../images/icon-m-timer-val.svg'
                    highlighted: !api.modeIsVideo && api.settings['capture_mode'] === 'precise self quality'
                    onHighlightedChanged: photoRoot.flow.checkHighlighted(this)
                }
            },

            Item {

                width: root.itemSize
                height: root.itemSize

                property var clickedFunc: function() {
                    api.cmd('setCaptureMode', 'burst quality')
                }

                CameraModeHighlightImage {
                    source: '../images/icon-m-burst.svg'
                    highlighted: !api.modeIsVideo && api.settings['capture_mode'] === 'burst quality'
                    onHighlightedChanged: photoRoot.flow.checkHighlighted(this)
                }
            },
            Item {

                width: root.itemSize
                height: root.itemSize

                property var clickedFunc: function() {
                    api.cmd('setCaptureMode', 'precise quality cont.')
                }

                CameraModeHighlightImage {
                    source: '../images/icon-m-timelapse.svg'
                    highlighted: !api.modeIsVideo && api.settings['capture_mode'] === 'precise quality cont.'
                    onHighlightedChanged: photoRoot.flow.checkHighlighted(this)
                }
            }
        ]
    }



    CameraModeSwitcher {
        id: videoRoot
        opacity: api.modeIsVideo ? 1:0
        x: !api.modeIsVideo ? -parent.width : 0

        Behavior on opacity {
            NumberAnimation {}
        }
        Behavior on x {
            NumberAnimation {}
        }
        isHorizontal: false
        itemSize: root.itemSize
        flow.children: [

            Item {
                width: root.itemSize
                height: root.itemSize

                property var clickedFunc: function() {
                    api.cmd('setRecordMode', 'record')
                }

                CameraModeHighlightImage {
                    source: 'image://theme/icon-m-video'
                    highlighted: api.modeIsVideo && api.settings['rec_mode'] === 'record'
                    onHighlightedChanged: videoRoot.flow.checkHighlighted(this)
                }
            },

            Item {

                width: root.itemSize
                height: root.itemSize

                property var clickedFunc: function() {
                    api.cmd('setRecordMode', 'record_slow_motion')
                }

                CameraModeHighlightImage {
                    source: '../images/icon-m-slowmotion.svg'
                    highlighted: api.modeIsVideo && api.settings['rec_mode'] === 'record_slow_motion'
                    onHighlightedChanged: videoRoot.flow.checkHighlighted(this)
                }
            },

            Item {
                width: root.itemSize
                height: root.itemSize

                property var clickedFunc: function() {
                    api.cmd('setRecordMode', 'record_timelapse')
                }

                CameraModeHighlightImage {
                    source: '../images/icon-m-timelapse.svg'
                    highlighted: api.modeIsVideo && api.settings['rec_mode'] === 'record_timelapse'
                    onHighlightedChanged: videoRoot.flow.checkHighlighted(this)
                }
            },
            Item {

                width: root.itemSize
                height: root.itemSize

                property var clickedFunc: function() {
                    api.cmd('setRecordMode', 'record_loop')
                }

                CameraModeHighlightImage {
                    source: 'image://theme/icon-m-backup'
                    highlighted: api.modeIsVideo && api.settings['rec_mode'] === 'record_loop'
                    onHighlightedChanged: videoRoot.flow.checkHighlighted(this)
                }
            },
            Item {
                width: root.itemSize
                height: root.itemSize

                property var clickedFunc: function() {
                    api.cmd('setRecordMode', 'record_photo')
                }

                CameraModeHighlightImage {
                    source: 'image://theme/icon-m-camera'
                    highlighted: api.modeIsVideo && api.settings['rec_mode'] === 'record_photo'
                    onHighlightedChanged: videoRoot.flow.checkHighlighted(this)
                    Label {
                        text: '+'
                        color: Theme.primaryColor
                        anchors.left: parent.left
                        anchors.top: parent.top
                        width: parent.width / 3
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
        ]
    }
}
