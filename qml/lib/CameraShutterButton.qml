import QtQuick 2.2

import Sailfish.Silica 1.0

Item {
    id: root
    width: Theme.itemSizeExtraLarge
    height: width
    states:[
        State {
            name: "photo"
            when: !api.modeIsVideo
//            AnchorChanges{target: activeIndicator; anchors.left: root.left; anchors.right: undefined}
            PropertyChanges { target: photoImage; opacity: 1 }
            PropertyChanges { target: videoImage; opacity: 0 }
        },
        State {
            name: "video"
            when: api.modeIsVideo
            PropertyChanges { target: photoImage; opacity: 0 }
            PropertyChanges { target: videoImage; opacity: 1 }
        }
    ]
    Rectangle {
        anchors.fill: parent
        color: Theme.rgba(hasBrightThemeBackground ? Qt.lighter(Theme.highlightColor, 2.5) : Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
        radius: width / 2
    }

    MouseArea {
        anchors.fill: parent
        onClicked: api.shutter()
    }
    Image {
        id: photoImage
        opacity: 0
        anchors.fill: parent
        source: '../images/icon-m-shutter.svg'
        sourceSize.width: width
        sourceSize.height: height
        Behavior on opacity {
                NumberAnimation {}
            }
        layer.effect: ShaderEffect {
            property color color: Theme.primaryColor
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
    }
    Item {
        id: videoImage
        anchors.fill: parent
        opacity: 0

        Behavior on opacity {
                NumberAnimation {}
            }

        Item {
            id: recordingArea
            width: parent.width / 2
            height: width
            anchors.centerIn: parent
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: api.isrecordingvideo
                onRunningChanged: {
                    if(!running) {
                        recordingArea.opacity = 1
                    }
                }

                PropertyAnimation { to: 1; duration: 900 }
                PropertyAnimation { to: 0; duration: 100 }
                PropertyAnimation { to: 0; duration: 900 }
                PropertyAnimation { to: 1; duration: 100 }
            }


            Rectangle {
                color: Theme.primaryColor
                anchors.fill: parent
                radius: width / 2
            }

            Rectangle {
                width: parent.width * 0.7
                height: width
                color: '#ff0000'
                anchors.centerIn: parent
                radius: width / 2
            }
        }


//        Image {
//            opacity: api.isrecordingvideo ? 0:1
//            anchors.fill: parent
//            source: 'image://theme/icon-m-dot'
//            Behavior on opacity {
//                    NumberAnimation {}
//                }
//        }
//        Image {
//            opacity: api.isrecordingvideo ? 1:0
//            anchors.fill: parent
//            source: 'image://theme/icon-m-video'
//            Behavior on opacity {
//                    NumberAnimation {}
//                }
//        }

    }

//    Label {
//        text: api.isrecordingvideo
//    }
}
