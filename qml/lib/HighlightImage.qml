import QtQuick 2.2
import Sailfish.Silica 1.0

import QtGraphicalEffects 1.0

MouseArea {
    id: root
    property alias image: image
    property alias source: image.source
    property bool highlighted: false
    property color color: Theme.highlightColor
    property bool useShadow: false
    property color shadowColor: color
//    property var onClicked: function(){}

    Item { //shader + shadow on one Component does not work well
        id: container
        anchors.fill: parent

        Image {
            id:image
            anchors.fill: parent
            anchors.centerIn: parent
            layer.effect: ShaderEffect {
                property color color: root.color
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
            layer.enabled: root.highlighted
            layer.samplerName: "source"
        }
    }


    DropShadow {
            visible: root.useShadow
            anchors.fill: container
            horizontalOffset: 0
            verticalOffset: 0
            radius: 2.0
            samples: 2
            color: root.shadowColor
            source: container
        }
    Component.onCompleted: {
//        mouseArea.clicked.connect(onClicked)
    }
}
