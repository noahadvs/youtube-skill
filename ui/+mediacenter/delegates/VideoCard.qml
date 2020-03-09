import QtQuick 2.9
import QtQuick.Layouts 1.4
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.3
import org.kde.kirigami 2.8 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import Mycroft 1.0 as Mycroft
import org.kde.mycroft.bigscreen 1.0 as BigScreen


BigScreen.AbstractDelegate {
    id: delegate
    
    readonly property Flickable view: {
        var candidate = parent;
        while (candidate) {
            if (candidate instanceof Flickable) {
                return candidate;
            }
            candidate = candidate.parent;
        }
        return null;
    }
    
    implicitWidth: view.cellWidth
    implicitHeight: view.cellHeight

    contentItem: Item {
        ColumnLayout {
            id: thumbnailLayout
            anchors {
                fill: parent
                topMargin: -delegate.topInset
                leftMargin: -delegate.leftInset
                rightMargin: -delegate.rightInset
            }
            spacing: Kirigami.Units.smallSpacing
            
            Rectangle {
                id: imgRoot
                color: "transparent"
                clip: true
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                // any width times 0.5625 results in a 16:9 aspect ratio
                Layout.preferredHeight: imgRoot.width * 0.5625 + Kirigami.Units.smallSpacing
                radius: 3
                
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        x: imgRoot.x; y: imgRoot.y
                        width: imgRoot.width
                        height: imgRoot.height
                        radius: imgRoot.radius
                    }
                }
                
                Image {
                    id: img
                    source: modelData.videoImage
                    width: parent.width
                    // Offset for padding and to prevent the bottom from being rounded
                    height: parent.height - Kirigami.Units.smallSpacing 
                    opacity: 1
                    fillMode: Image.PreserveAspectCrop
                    
                    Rectangle {
                        id: videoDurationTime
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: Kirigami.Units.smallSpacing
                        anchors.right: parent.right
                        anchors.rightMargin: Kirigami.Units.smallSpacing
                        width: durationText.width + Kirigami.Units.smallSpacing
                        height: durationText.height
                        radius: imgRoot.radius
                        color: Qt.rgba(0, 0, 0, 0.8)
                        
                        PlasmaComponents.Label {
                            id: durationText
                            anchors.centerIn: parent
                            text: modelData.videoDuration
                            color: Kirigami.Theme.textColor
                        }
                    }
                }
            }
        
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: videoLabel.height + videoChannelName.height + viewsAndDateLabelLayout.height
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.topMargin: -Kirigami.Units.smallSpacing
                Layout.leftMargin: Kirigami.Units.smallSpacing
                
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0
                    
                    Kirigami.Heading {
                        id: videoLabel
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        wrapMode: Text.Wrap
                        level: 5
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        color: PlasmaCore.ColorScope.textColor
                        Component.onCompleted: {
                            text = modelData.videoTitle
                        }
                    }
                                            
                    PlasmaComponents.Label {
                        id: videoChannelName
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        maximumLineCount: 1
                        elide: Text.ElideRight
                        color: PlasmaCore.ColorScope.textColor
                        text: modelData.videoChannel
                    }
                    
                    RowLayout {
                        id: viewsAndDateLabelLayout
                        Layout.fillWidth: true
                        
                        PlasmaComponents.Label {
                            id: videoViews
                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Layout.rightMargin: Kirigami.Units.largeSpacing
                            wrapMode: Text.WordWrap
                            maximumLineCount: 1
                            elide: Text.ElideRight
                            color: PlasmaCore.ColorScope.textColor
                            text: modelData.videoViews
                        }
                        
                        PlasmaComponents.Label {
                            id: videoUploadDate
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignRight
                            wrapMode: Text.WordWrap
                            maximumLineCount: 1
                            color: PlasmaCore.ColorScope.textColor
                            text: modelData.videoUploadDate
                        }
                    }
                }
            }
        }
        
        states: [
            State {
                name: "selected"
                when: delegate.isCurrent
                PropertyChanges {
                    target: thumbnailLayout
                    anchors.topMargin: -delegate.topPadding + Kirigami.Units.smallSpacing
                    anchors.leftMargin: -delegate.leftPadding + Kirigami.Units.smallSpacing
                    anchors.rightMargin: -delegate.rightPadding + Kirigami.Units.smallSpacing
                }
            },
            State {
                name: "normal"
                when: !delegate.isCurrent
                PropertyChanges {
                    target: thumbnailLayout
                    anchors.topMargin: -delegate.topPadding/2
                    anchors.leftMargin: -delegate.topPadding/2
                    anchors.rightMargin: -delegate.topPadding/2
                }
            }
        ]
        transitions: [
            Transition {
                ParallelAnimation {
                    NumberAnimation {
                        property: "topMargin"
                        duration: Kirigami.Units.longDuration
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        property: "leftMargin"
                        duration: Kirigami.Units.longDuration
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        property: "rightMargin"
                        duration: Kirigami.Units.longDuration
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        ]
    }
    
    onClicked: {
        busyIndicatorPop.open()
        Mycroft.MycroftController.sendRequest("aiix.youtube-skill.playvideo_id", {vidID: modelData.videoID, vidTitle: modelData.videoTitle, vidImage: modelData.videoImage, vidChannel: modelData.videoChannel, vidViews: modelData.videoViews, vidUploadDate: modelData.videoUploadDate, vidDuration: modelData.videoDuration})
    }
}

