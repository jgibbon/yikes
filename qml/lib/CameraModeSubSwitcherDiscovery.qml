/********************************************
Simplified variant with hard coded, different
settings for the YI Discovery Action Camera
*********************************************/
import QtQuick 2.2

import Sailfish.Silica 1.0
Item {
    id: root
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
            CameraModeSubSwitcherItem { // normal photo
                visible: true //hard coded override
                key: 'capture_mode'
                value: 'precise quality'
                source: 'image://theme/icon-m-camera'
            },
            CameraModeSubSwitcherItem { // timer
                visible: true //hard coded override
                key: 'capture_mode'
                value: 'precise self quality'
                source: '../images/icon-m-timer-val.svg'
            },
            CameraModeSubSwitcherItem { // burst
                visible: true //hard coded override
                key: 'capture_mode'
                value: 'burst quality'
                source: '../images/icon-m-burst.svg'
            },
            CameraModeSubSwitcherItem { // time lapse
                visible: true //hard coded override
                key: 'capture_mode'
                value: 'precise quality cont.'
                source: '../images/icon-m-timelapse.svg'
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

            CameraModeSubSwitcherItem { // normal video
                visible: true //hard coded override
                key: 'rec_mode'
                value: 'record'
                source: 'image://theme/icon-m-video'
            },

            CameraModeSubSwitcherItem { // slow motion
                visible: true //hard coded override
                key: 'rec_mode'
                value: 'record_slow_motion'
                source: '../images/icon-m-slowmotion.svg'
            },
            CameraModeSubSwitcherItem { // time lapse video
                visible: true //hard coded override
                key: 'rec_mode'
                value: 'record_timelapse'
                source: '../images/icon-m-timelapse.svg'
            },
            CameraModeSubSwitcherItem { // loop video
                visible: true //hard coded override
                key: 'rec_mode'
                value: 'record_loop'
                source: 'image://theme/icon-m-backup'
            },
            CameraModeSubSwitcherItem { // video + photo
                visible: true //hard coded override
                key: 'rec_mode'
                value: 'record_photo'
                source: 'image://theme/icon-m-camera'
                Label {
                    text: '+'
                    color: Theme.primaryColor
                    anchors.left: parent.left
                    anchors.top: parent.top
                    width: parent.width / 3
                    horizontalAlignment: Text.AlignRight
                }
            }
        ]

    }
}
