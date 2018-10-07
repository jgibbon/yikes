import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import '../lib'

Page {
    id: page

    allowedOrientations: Orientation.All
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: settingsColumn.height
        Column {
            id: settingsColumn
            width: parent.width
            spacing: Theme.paddingSmall
//            PageHeader {
//                id: pageHeader
//                title: qsTr('About')
//            }
            Item {
                id: logoContainer
                width: parent.width
                height: Theme.itemSizeExtraLarge + Theme.paddingLarge * 2
                Rectangle {
                    id: bgColor
                    color: Theme.rgba(Theme.secondaryHighlightColor, Theme.highlightBackgroundOpacity)
                    anchors.fill: parent
                }
                OpacityRampEffect {
                    sourceItem: bgColor
                }

                Item {
                    id: imagesItem
                    width: Theme.itemSizeExtraLarge
                    height: Theme.itemSizeExtraLarge
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        margins: Theme.horizontalPageMargin
                    }
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
                    text: qsTr("About yikes")
                    font.pixelSize: Theme.fontSizeLarge
                    color: Theme.highlightColor
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    anchors {
                        left: imagesItem.right
                        top: imagesItem.top
                        bottom: imagesItem.bottom
                        right: parent.right
                        margins: Theme.horizontalPageMargin
                    }
                }
            }

            SectionHeader {
                text: qsTr('What is yikes?')
            }
            Label {
                color: Theme.secondaryColor
                width: parent.width - Theme.horizontalPageMargin*2
                x: Theme.horizontalPageMargin
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Yikes is an open source python/qml app to control some basic functionality of Yi Action Cameras via wifi. But if you can read this, you may already know that.")
            }
            Label {
                color: Theme.secondaryColor
                width: parent.width - Theme.horizontalPageMargin*2
                x: Theme.horizontalPageMargin
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("It is not an official product from or in any way related to Yi Technology.")
            }

            SectionHeader {
                text: qsTr('Can I help?')
            }

            Label {
                color: Theme.secondaryColor
                width: parent.width - Theme.horizontalPageMargin*2
                x: Theme.horizontalPageMargin
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Of course! You can help reporting bugs, translating or even debugging to make more camera models at least partially work on GitHub. Or you might buy me a coffee, but there should be better things to spend your money on.")
            }
            Button {
                x: Theme.horizontalPageMargin
                width: parent.width - Theme.horizontalPageMargin*2
                onClicked: Qt.openUrlExternally("https://github.com/jgibbon/yikes")
                text: "GitHub"
            }
            Button {
                x: Theme.horizontalPageMargin
                width: parent.width - Theme.horizontalPageMargin*2
                onClicked: Qt.openUrlExternally("https://www.paypal.me/jgibbon")
                text: "PayPal"
            }
        }
    }
}
