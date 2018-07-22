import QtQuick 2.2

import Sailfish.Silica 1.0

Item {
    id: root
    property int itemSize: Theme.itemSizeMedium
    property int itemSizeSmallerWidth: Theme.itemSizeSmall

    property bool isHorizontal: true

    property int largerSide: {
        var width = 0;
        for (var i = 0; i < flow.visibleChildren.length; i++) {
            width += flow.visibleChildren[i].width + flow.spacing;
        }
        return width - flow.spacing;
    }
        //(itemSize + flow.spacing) * flow.visibleChildren.length -flow.spacing
    width: root.isHorizontal ? largerSide : root.itemSize
    height: !root.isHorizontal ? largerSide : root.itemSize
    anchors.centerIn: parent
    function setPhoto(){
        if(api.modeIsVideo)
            api.cmd('setCaptureMode', 'precise quality')
    }
    function setVideo(){
        if(!api.modeIsVideo)
            api.cmd('setRecordMode', 'record')
    }
    function swipedLeft(){
        console.log('swipedLeft')
        flow.setNextItem(false)
    }
    function swipedRight(){

        console.log('swipedRight')
        flow.setNextItem(true)
    }

    Rectangle {
        id: activeIndicator
        color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
        width: root.itemSize
        height: width
        radius: width/2
        //        anchors.left: root.left

        Behavior on width {
            NumberAnimation {}
        }
        Behavior on x {
            NumberAnimation {}
        }
        Behavior on y {
            NumberAnimation {}
        }
    }

    Flow {
        id: flow
        anchors.fill: parent
        spacing: Theme.paddingMedium
        property Item activeItem
        function setNextItem(previous){
            var activeIndex = -2;
            for (var i = 0; i < visibleChildren.length; i++) {
                if (visibleChildren[i] === activeItem) {
                    activeIndex = i
                }
            }
            var clickItem = visibleChildren[previous ? activeIndex - 1 : activeIndex + 1];
            if(clickItem){
                clickItem.clickedFunc()
            }
        }
        function checkHighlighted(el){
            if(el.highlighted) {
                console.log('highlighted', el.source)
                activeItem = el.parent
                var highlightedCoords = flow.mapFromItem(activeItem, 0,0)
                var diff = (root.itemSize - activeItem.width) / 2
                activeIndicator.x = highlightedCoords.x;
                activeIndicator.y = highlightedCoords.y + diff;
                activeIndicator.width = activeItem.width;
            } else {
                console.log('not highlighted', el.source);
            }
        }

        Item {
            width: root.itemSizeSmallerWidth
            height: root.itemSize

            property var clickedFunc: function() {
                api.cmd('setCaptureMode', 'precise self quality')
            }

            HighlightImage {
                anchors.fill: parent
                image.width: parent.width / 2
                image.height: parent.width / 2
                image.anchors.fill: undefined
                source: '../images/icon-m-timer-val.svg'
                highlighted: !api.modeIsVideo && api.settings['capture_mode'] === 'precise self quality'
                onClicked: function(){parent.clickedFunc()}
                onHighlightedChanged: flow.checkHighlighted(this)
                Component.onCompleted: flow.checkHighlighted(this)
            }
        }


        Item {

            width: root.itemSizeSmallerWidth
            height: root.itemSize

            property var clickedFunc: function() {
                api.cmd('setCaptureMode', 'burst quality')
            }

            HighlightImage {
                anchors.fill: parent
                image.width: parent.width / 2
                image.height: parent.width / 2
                image.anchors.fill: undefined
                source: '../images/icon-m-burst.svg'
                highlighted: !api.modeIsVideo && api.settings['capture_mode'] === 'burst quality'
                onClicked: function(){parent.clickedFunc()}
                onHighlightedChanged: flow.checkHighlighted(this)
                Component.onCompleted: flow.checkHighlighted(this)
            }
        }

        Item {

            width: root.itemSize
            height: root.itemSize

            property var clickedFunc: function() {
                api.cmd('setCaptureMode', 'precise quality')
            }

            HighlightImage {
                anchors.fill: parent
                image.width: parent.width / 2
                image.height: parent.width / 2
                image.anchors.fill: undefined
                source: 'image://theme/icon-m-camera'
                highlighted: !api.modeIsVideo && api.settings['capture_mode'] === 'precise quality'
                onClicked: function(){parent.clickedFunc()}
                onHighlightedChanged: flow.checkHighlighted(this)
                Component.onCompleted: flow.checkHighlighted(this)
            }
        }



        Item {
            width: root.itemSize
            height: root.itemSize

            property var clickedFunc: function() {
                api.cmd('setRecordMode', 'record')
            }
            HighlightImage {
                anchors.fill: parent
                image.width: parent.width / 2
                image.height: parent.width / 2
                image.anchors.fill: undefined
                source: 'image://theme/icon-m-video'
                highlighted: api.modeIsVideo && api.settings['rec_mode'] === 'record'
                onClicked: function(){parent.clickedFunc()}
                onHighlightedChanged: flow.checkHighlighted(this)
                Component.onCompleted: flow.checkHighlighted(this)
            }

        }


        Item {

            width: root.itemSizeSmallerWidth
            height: root.itemSize

            property var clickedFunc: function() {
                api.cmd('setRecordMode', 'record_slow_motion')
            }

            HighlightImage {
                anchors.fill: parent
                image.width: parent.width / 2
                image.height: parent.width / 2
                image.anchors.fill: undefined
                source: '../images/icon-m-slowmotion.svg'
                highlighted: api.modeIsVideo && api.settings['rec_mode'] === 'record_slow_motion'
                onClicked: function(){parent.clickedFunc()}
                onHighlightedChanged: flow.checkHighlighted(this)
                Component.onCompleted: flow.checkHighlighted(this)
            }
        }

        Item {

            width: root.itemSizeSmallerWidth
            height: root.itemSize

            property var clickedFunc: function() {
                api.cmd('setRecordMode', 'record_timelapse')
            }

            HighlightImage {
                anchors.fill: parent
                image.width: parent.width / 2
                image.height: parent.width / 2
                image.anchors.fill: undefined
                source: '../images/icon-m-timelapse.svg'
                highlighted: api.modeIsVideo && api.settings['rec_mode'] === 'record_timelapse'
                onClicked: function(){parent.clickedFunc()}
                onHighlightedChanged: flow.checkHighlighted(this)
                Component.onCompleted: flow.checkHighlighted(this)
            }
        }

    }

}
