import QtQuick 2.9
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.3
import org.kde.kirigami 2.8 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.components 2.0 as PlasmaComponents
import Mycroft 1.0 as Mycroft
import org.kde.mycroft.bigscreen 1.0 as BigScreen
import "../delegates" as Delegates

BigScreen.TileView {
    id: root
    readonly property int thumbnailWidth: Math.floor(480 * Kirigami.Units.devicePixelRatio / 3)
    cellWidth: thumbnailWidth + Kirigami.Units.largeSpacing*4
    // any width times 0.5625 results in a 16:9 aspect ratio
    cellHeight: (thumbnailWidth * 0.5625) + (Kirigami.Units.gridUnit * 5)
    delegate: Delegates.VideoCard{}
    onActiveFocusChanged: {
        if(activeFocus) {
            contentLayout.currentSection = root
        }
    }
}
