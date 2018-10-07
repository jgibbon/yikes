import QtQuick 2.2

import Sailfish.Silica 1.0
CameraModeSwitcher {
    id: root
    flow.children: [
        Item {
            width: root.itemSize
            height: root.itemSize

            property var clickedFunc: function() {
                api.cmd('setCaptureMode', api.settings['capture_mode'])
            }

            CameraModeHighlightImage {
                source: 'image://theme/icon-m-camera'
                highlighted: !api.modeIsVideo
                onHighlightedChanged: root.flow.checkHighlighted(this)
            }
        },
        Item {
            width: root.itemSize
            height: root.itemSize

            property var clickedFunc: function() {
                api.cmd('setRecordMode', api.settings['rec_mode'])
            }

            CameraModeHighlightImage {
                source: 'image://theme/icon-m-video'
                highlighted: api.modeIsVideo
                onHighlightedChanged: root.flow.checkHighlighted(this)
            }

        }
    ]

}
