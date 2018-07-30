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
            CameraModeSubSwitcherItem {
                key: 'capture_mode'
                value: 'precise quality'
                source: 'image://theme/icon-m-camera'
            },
            CameraModeSubSwitcherItem {
                key: 'capture_mode'
                value: 'precise self quality'
                source: '../images/icon-m-timer-val.svg'
            },
            CameraModeSubSwitcherItem {
                key: 'capture_mode'
                value: 'burst quality'
                source: '../images/icon-m-burst.svg'
            },
            CameraModeSubSwitcherItem {
                key: 'capture_mode'
                value: 'precise quality cont.'
                source: '../images/icon-m-timelapse.svg'
            }
        ]
        Connections {
            target: api
            onConnectedChanged: {
                if(api.connected) {
                    api.getSettingOptions('capture_mode')
                }
            }
        }
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

            CameraModeSubSwitcherItem {
                key: 'rec_mode'
                value: 'record'
                source: 'image://theme/icon-m-video'
            },

            CameraModeSubSwitcherItem {
                key: 'rec_mode'
                value: 'record_slow_motion'
                source: '../images/icon-m-slowmotion.svg'
            },
            CameraModeSubSwitcherItem {
                key: 'rec_mode'
                value: 'record_timelapse'
                source: '../images/icon-m-timelapse.svg'
            },
            CameraModeSubSwitcherItem {
                key: 'rec_mode'
                value: 'record_loop'
                source: 'image://theme/icon-m-backup'
            },
            CameraModeSubSwitcherItem {
                key: 'rec_mode'
                value: 'record_photo'
                source: 'image://theme/icon-m-camera'
                Label {
                    text: '+'
                    color: Theme.primaryColor
                    anchors.left: parent.left
                    anchors.top: parent.top
                    width: parent.width / 6
                    horizontalAlignment: Text.AlignRight
                }
            }


//            Item {
//                width: root.itemSize
//                height: root.itemSize
//                visible: !!api.settingsOptions['rec_mode'] && api.settingsOptions['rec_mode'].options.indexOf('record_photo') > -1
//                property var clickedFunc: function() {
//                    api.cmd('setRecordMode', 'record_photo')
//                }

//                CameraModeHighlightImage {
//                    source: 'image://theme/icon-m-camera'
//                    highlighted: api.modeIsVideo && api.settings['rec_mode'] === 'record_photo'
//                    onHighlightedChanged: videoRoot.flow.checkHighlighted(this)
//                    Label {
//                        text: '+'
//                        color: Theme.primaryColor
//                        anchors.left: parent.left
//                        anchors.top: parent.top
//                        width: parent.width / 3
//                        horizontalAlignment: Text.AlignRight
//                    }
//                }
//            }
        ]

        Connections {
            target: api
            onConnectedChanged: {
                if(api.connected) {
                    api.getSettingOptions('rec_mode')
                }
            }
        }
    }
}
