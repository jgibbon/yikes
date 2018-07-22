import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import '../lib'

Page {
    id: page

    allowedOrientations: Orientation.All

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        width: parent.width
        height: parent.height

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Show Page 2")
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
        }
        contentHeight: page.height

        Item {
            id: connectedView
            opacity: 0//api.connected? 1 : 0 //TODO make states
            width: page.width
            height: page.height

            Item {
                id: viewFinderArea
                width: parent.width
                height: parent.height

                ViewFinder {
                    id: viewFinder
                }
            }

            Column {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                Item {
                    id: modeBarArea
                    width: parent.width
                    height: Theme.itemSizeLarge * 2
                    CameraModeBar {
                        id: cameraModeBar
                    }
                }


                Label {
                    width: parent.width
                    text: 'capture_mode ' + api.settings.capture_mode
                }
                Label {
                    width: parent.width
                    text: 'rec_mode ' + api.settings.rec_mode
                }

                Label {
                    width: parent.width
                    text: 'modeIsVideo ' + api.modeIsVideo
                }

                Row {
                    width: parent.width

                    CameraSettingButton {
                        optionName: 'capture_mode'
                    }

                    CameraSettingButton {
                        optionName: 'rec_mode'
                    }
                }

            }
        }

        Column {
            visible: false
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: api.loaded
            }
            //            Label {
            //                x: Theme.horizontalPageMargin
            //                text: api.streamUrl + ' ' + testVideo.vfstarted
            //                color: Theme.secondaryHighlightColor
            //                font.pixelSize: Theme.fontSizeExtraLarge
            //            }

            CameraSettingButton {
                optionName: 'video_resolution'
            }


        }
    }
}

