pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root
    required property bool active
    property string text: "0m"

    FileView {
        id: uptimeFile
        path: root.active ? "/proc/uptime" : ""

        onLoaded: {
            const uptime = parseFloat(uptimeFile.text());
            if (!root.active || !Number.isFinite(uptime))
                return;

            const days = Math.floor(uptime / 86400);
            const hours = Math.floor(uptime / 3600) % 24;
            const minutes = Math.floor(uptime / 60) % 60;
            const parts = [];
            if (days > 0)
                parts.push(`${days}d`);
            if (hours > 0)
                parts.push(`${hours}h`);
            if (minutes > 0 || parts.length === 0)
                parts.push(`${minutes}m`);
            root.text = parts.join(", ");
        }
    }

    Timer {
        interval: 60000
        running: root.active
        repeat: true
        onTriggered: uptimeFile.reload()
    }
}
