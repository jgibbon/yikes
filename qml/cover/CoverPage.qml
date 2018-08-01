/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Item {
        id: imageArea
        width: parent.width
        height: parent.height / 2

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
            opacity: api.connected ? 1 : 0.2
            source: "../images/app-icon-fg.svg"

        }
//        Image {
//            id: iconOffline
//            anchors.centerIn: parent
//            visible: !api.connected
//            source: "image://theme/icon-m-wlan-no-signal"
//        }

    }
    Label {
        visible: !api.connected
        width: parent.width
        anchors.top: imageArea.bottom
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        text: qsTr('Not Connected')
    }
    Column {
        width: parent.width
        anchors.top: imageArea.bottom
        Label {
            visible: api.connected
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: qsTr('Connected')
        }

        Label {
            visible: api.connected
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: Theme.fontSizeSmall
            text: api.modeIsVideo ? qsTr('Video Mode') : qsTr('Photo Mode')
        }
        Label {
            visible: api.connected && api.isrecordingvideo
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: Theme.fontSizeSmall
            text: qsTr('(recording)')
        }
    }

    CoverActionList {
        id: coverActionVideo
        enabled: api.connected && api.modeIsVideo
        CoverAction {
            iconSource: api.isrecordingvideo ? "image://theme/icon-cover-pause" : "image://theme/icon-m-dot"
            onTriggered: api.shutter()
        }

    }
    CoverActionList {
        id: coverActionPhoto
        enabled: api.connected && !api.modeIsVideo
        CoverAction {
            iconSource: Qt.resolvedUrl("../images/icon-m-shutter.svg")
            onTriggered: api.shutter()
        }

    }
}

