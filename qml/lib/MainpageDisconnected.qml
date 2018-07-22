import QtQuick 2.2

import Sailfish.Silica 1.0

Item {
    id: root
    property bool connected: api.connected
    property bool wasAlreadyConnected
    property int connectionRetries: api.connectionRetries
//    PropertyAnimation on opacity {
//        duration: 1000
//    }

    onConnectionRetriesChanged: {
        iconRotator.start()
    }

    onConnectedChanged: {
        if(connected) {
            wasAlreadyConnected = true
        }
    }

    anchors.fill: parent
    PageHeader {
        id: pageHeader
        title: 'yikes'
    }
    Item {
        anchors.top: pageHeader.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        Column {
            spacing: Theme.paddingLarge
            width: parent.width - Theme.horizontalPageMargin*2
//            anchors.centerIn: parent
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                width: parent.width
                height: Theme.itemSizeExtraLarge
                Item {
                    id: rotationArea

                    width: Theme.itemSizeExtraLarge
                    height: Theme.itemSizeExtraLarge
                    anchors.centerIn: parent

                    Image {
                        id: iconBg
                        width: Theme.itemSizeExtraLarge
                        height: Theme.itemSizeExtraLarge
                        sourceSize.width: width
                        sourceSize.height: height

                        source: '../images/app-icon-bg.svg'

                        property color color: Theme.highlightColor
                        layer.effect: ShaderEffect {
                            property color color: Theme.highlightColor

                            fragmentShader: "
                                        varying mediump vec2 qt_TexCoord0;
                                        uniform highp float qt_Opacity;
                                        uniform lowp sampler2D source;
                                        uniform highp vec4 color;
                                        void main() {
                                            highp vec4 pixelColor = texture2D(source, qt_TexCoord0);
                                            gl_FragColor = vec4(mix(pixelColor.rgb/max(pixelColor.a, 0.00390625), color.rgb/max(color.a, 0.00390625), color.a) * pixelColor.a, pixelColor.a) * qt_Opacity;
                                        }
                                    "
                        }
                        layer.enabled: true
                        layer.samplerName: "source"
                        RotationAnimator {
                            id: iconRotator
                            target: rotationArea
                            from: target.rotation;
                            to: target.rotation + 90;
                            duration: 2000
                            running: false
                            easing.type: Easing.InOutQuad
//                            onRunningChanged: {
//                                if(!running) {
//                                    running = true
//                                }
//                            }
                        }
                    }
                }
                Image {
                    id: iconFg
                    width: Theme.itemSizeExtraLarge
                    height: Theme.itemSizeExtraLarge
                    sourceSize.width: width
                    sourceSize.height: height
                    anchors.centerIn: parent

                    source: "../images/app-icon-fg.svg"

                }
            }
            Label {
                text: root.wasAlreadyConnected
                      ? qsTr('Connection to Camera lost')
                      : qsTr('Not connected to Camera')
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                width: parent.width
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeLarge
            }
            Label {
                text: qsTr('I am trying to connect right now.')
//                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                width: parent.width
                color: Theme.highlightColor
            }
            Label {
                property bool retryingLong: api.connectionRetries > 4
                height: retryingLong ? implicitHeight : 0
                opacity: retryingLong ? 1 : 0

                Behavior on height { PropertyAnimation {} }
                Behavior on opacity { PropertyAnimation {} }
                text: qsTr('If you keep seeing this, please make sure:')
                      +'<ul><li>'+qsTr('That the camera\'s wifi is enabled', '"make sure"…') + '</li>'
                      +'<li>'+qsTr('That this device\'s wifi is enabled', '"make sure"…') + '</li>'
                      +'<li>'+qsTr('That both devices are connected. ', '"make sure"…') + '</li></ul>'
                      + qsTr('The camera\'s hot spot name should start with "YDXJ_".')

//                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                width: parent.width
                color: Theme.highlightColor

            }
        }
    }

    //            Label {
    //                x: Theme.horizontalPageMargin
    //                text: api.streamUrl + ' ' + testVideo.vfstarted
    //                color: Theme.secondaryHighlightColor
    //                font.pixelSize: Theme.fontSizeExtraLarge
    //            }

    //    CameraSettingButton {
    //        optionName: 'video_resolution'
    //    }


}
