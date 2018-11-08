import QtQuick 2.2

import Sailfish.Silica 1.0

Item {
    id: root
    property alias flow: flow
    property int itemSize: Theme.itemSizeMedium
    property bool useBackground: true
    property bool isHorizontal: true

    property int largerSide: {
        var w = 0;
        for (var i = 0; i < flow.visibleChildren.length; i++) {
            w += flow.visibleChildren[i].width + flow.spacing;
        }
        return w - flow.spacing;
    }
    width: root.isHorizontal ? largerSide : root.itemSize
    height: !root.isHorizontal ? largerSide : root.itemSize

    anchors.horizontalCenter: isHorizontal ? parent.horizontalCenter : undefined
    anchors.verticalCenter: !isHorizontal ? parent.verticalCenter : undefined

    function swipedLeft(){
        console.log('swipedLeft')
        flow.setNextItem(false)
    }
    function swipedRight(){

        console.log('swipedRight')
        flow.setNextItem(true)
    }
    Rectangle {
        id: backgroundRect
        x: root.isHorizontal ? 0 : 0-Theme.itemSizeMedium
        y: !root.isHorizontal ? 0 : 0-Theme.itemSizeMedium
        visible: root.useBackground
        anchors.fill: parent

        color: hasBrightThemeBackground ? Qt.lighter(Theme.highlightColor, 2.5) : Theme.rgba(Theme.secondaryHighlightColor, Theme.highlightBackgroundOpacity)
        radius: width

    }
    OpacityRampEffect {
        sourceItem: backgroundRect
        direction: root.isHorizontal ? OpacityRamp.TopToBottom : OpacityRamp.LeftToRight
        offset: 0
        slope: 1
    }

    Rectangle {
        id: activeIndicator
        color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity)
        width: root.itemSize
        height: width
        radius: width/2

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

    Timer {
        id: checkAllTimer
        interval: 200
        onTriggered: {
            flow.checkHighlighted()
        }
    }
    onWidthChanged: {
        checkAllTimer.start()
    }

    Component.onCompleted: {
        checkAllTimer.start()
    }
    Flow {
        id: flow
        anchors.fill: parent
        spacing: Theme.paddingMedium

        flow: root.isHorizontal ? Flow.LeftToRight : Flow.TopToBottom
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
            if(!el) {
                for (var i = 0; i < flow.visibleChildren.length; i++) {
                    checkHighlighted(flow.visibleChildren[i].visibleChildren[0])
                }
                return;
            } else if(el.highlighted) {
                activeItem = el.parent
                var highlightedCoords = flow.mapFromItem(activeItem, 0,0)
                var diff = (root.itemSize - activeItem.width) / 2
                activeIndicator.x = highlightedCoords.x;
                activeIndicator.y = highlightedCoords.y + diff;
                activeIndicator.width = activeItem.width;
            }
        }


    }

}
