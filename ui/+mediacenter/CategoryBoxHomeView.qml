/*
 *  Copyright 2018 by Aditya Mehra <aix.m@outlook.com>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import QtQuick.Layouts 1.4
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.3
import org.kde.kirigami 2.8 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.components 2.0 as PlasmaComponents
import Mycroft 1.0 as Mycroft
import org.kde.mycroft.bigscreen 1.0 as BigScreen
import "+mediacenter/views" as Views
import "+mediacenter/delegates" as Delegates

Item {
    property alias recentModel: recentListView.model
    property alias newsModel: newsListView.model
    property alias musicModel: musicListView.model
    property alias techModel: techListView.model
    property alias trendModel: trendListView.model
    property alias polModel: polListView.model
    property alias gamingModel: gamingListView.model
    Layout.fillWidth: true
    Layout.fillHeight: true
    
    onFocusChanged: {
        if(focus){
            recentListView.forceActiveFocus()
        }
    }
    
    onNewsModelChanged: {
       newsListView.view.forceLayout()
    }
    onMusicModelChanged: {
       musicListView.view.forceLayout()
    }
    onTechModelChanged: {
       techListView.view.forceLayout()
    }
    onPolModelChanged: {
       polListView.view.forceLayout()
    }
    onGamingModelChanged: {
       gamingListView.view.forceLayout()
    }
    onRecentModelChanged: {
        recentListView.view.forceLayout()
    }
    onTrendModelChanged: {
        trendListView.view.forceLayout()
    }
    
    ColumnLayout {
        id: contentLayout
        width: parent.width
        property Item currentSection
        y: currentSection ? -currentSection.y : 0
        Behavior on y {
            NumberAnimation {
                duration: Kirigami.Units.longDuration * 2
                easing.type: Easing.InOutQuad
            }
        }
        height: parent.height
        
        anchors.leftMargin: Kirigami.Units.largeSpacing*3
        anchors.topMargin: Kirigami.Units.largeSpacing*4
        spacing: Kirigami.Units.largeSpacing*4
        
        Views.VideoTileView {
            id: recentListView
            focus: true
            title: "Recently Watched"

            navigationUp: homeCatButton
            navigationDown: trendListView
        }

        Views.VideoTileView {
            id: trendListView
            focus: false
            title: "Trending"

            navigationUp: recentListView
            navigationDown: newsListView
        }

        Views.VideoTileView {
            id: newsListView
            focus: false
            title: "News"

            navigationUp: trendListView
            navigationDown: musicListView
        }
        
        Views.VideoTileView {
            id: musicListView
            focus: false
            title: "Music"

            navigationUp: newsListView
            navigationDown: techListView
        }
        
        Views.VideoTileView {
            id: techListView
            focus: false
            title: "Technology"

            navigationUp: musicListView
            navigationDown: polListView
        }
        
        Views.VideoTileView {
            id: polListView
            focus: false
            title: "Politics"

            navigationUp: techListView
            navigationDown: gamingListView
        }
        
        Views.VideoTileView {
            id: gamingListView
            focus: false
            title: "Gaming"

            navigationUp: polListView
            navigationDown: trendListView
        }
    }
}
