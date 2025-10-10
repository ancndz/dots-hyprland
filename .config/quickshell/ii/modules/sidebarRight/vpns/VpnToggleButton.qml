import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

GroupButton {
    id: button
    property string buttonText: ""
    
    property var connection: null
    
    baseWidth: content.implicitWidth + 10 * 2
    baseHeight: 30

    buttonRadius: baseHeight / 2
    buttonRadiusPressed: Appearance.rounding.small
    colBackground: connection && connection.isActive ? Appearance.m3colors.m3error : Appearance.m3colors.m3primary
    colBackgroundHover: connection && connection.isActive ? 
        Qt.darker(Appearance.m3colors.m3error, 1.1) : 
        Qt.darker(Appearance.m3colors.m3primary, 1.1)
    colBackgroundActive: connection && connection.isActive ? 
        Qt.darker(Appearance.m3colors.m3error, 1.2) : 
        Qt.darker(Appearance.m3colors.m3primary, 1.2)
    property color colText: toggled ? Appearance.colors.colOnLayer1 : Appearance.m3colors.m3onPrimary

    contentItem: Item {
        id: content
        anchors.fill: parent
        implicitWidth: contentRowLayout.implicitWidth + 20
        implicitHeight: contentRowLayout.implicitHeight
        
        RowLayout {
            id: contentRowLayout
            anchors.centerIn: parent
            spacing: 5
            
            MaterialSymbol {
                text: connection && connection.isActive ? "link_off" : "link"
                iconSize: Appearance.font.pixelSize.large
                color: button.colText
            }
            
            StyledText {
                text: buttonText
                font.pixelSize: Appearance.font.pixelSize.small
                color: button.colText
            }
        }
    }

    onClicked: {
        if (connection) {
            connection.toggle();
        }
    }
}