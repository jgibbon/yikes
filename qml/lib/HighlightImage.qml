import QtQuick 2.2
import Sailfish.Silica 1.0

MouseArea {
    id: root
    property alias image: image
    property alias source: image.source
    property bool highlighted: false
    property color color: Theme.highlightColor
//    property var onClicked: function(){}

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
        layer.enabled: parent.highlighted
        layer.samplerName: "source"
    }

    Component.onCompleted: {
//        mouseArea.clicked.connect(onClicked)
    }
}
