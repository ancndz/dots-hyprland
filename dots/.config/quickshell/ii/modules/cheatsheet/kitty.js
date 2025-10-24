var keybinds = {
    children: [
        {
            children: [
                {
                    name: "Scrolling",
                    keybinds: [
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "↑",
                            comment: "Line up",
                            macos: ["⌥", "⌘", "⇞", "⌘", "↑"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "↓",
                            comment: "Line down",
                            macos: ["⌥", "⌘", "⇟", "⌘", "↓"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "Page ↑",
                            comment: "Page up",
                            macos: ["⌘", "⇞"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "Page ↓",
                            comment: "Page down",
                            macos: ["⌘", "⇟"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "Home",
                            comment: "Top",
                            macos: ["⌘", "↖"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "End",
                            comment: "Bottom",
                            macos: ["⌘", "↘"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "Z",
                            comment: "Previous shell prompt"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "X",
                            comment: "Next shell prompt"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "H",
                            comment: "Browse scrollback in less"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "G",
                            comment: "Browse last cmd output"
                        }
                    ]
                }
            ]
        },
        {
            children: [
            {
                    name: "Tabs",
                    keybinds: [
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "T",
                            comment: "New tab",
                            macos: ["⌘", "T"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "Q",
                            comment: "Close tab",
                            macos: ["⌘", "W"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "Right",
                            comment: "Next tab",
                            macos: ["⇧", "⌃", "⇥", "⇧", "⌘", "]"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "Left",
                            comment: "Previous tab",
                            macos: ["⇧", "⌃", "⇥", "⇧", "⌘", "["]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "L",
                            comment: "Next layout"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: ".",
                            comment: "Move tab forward"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: ",",
                            comment: "Move tab backward"
                        },
                        {
                            mods: ["Ctrl", "Shift", "Alt"],
                            key: "T",
                            comment: "Set tab title",
                            macos: ["⇧", "⌘", "I"]
                        }
                    ]
                }
            ]
        },
        {
            children: [
                {
                    name: "Windows",
                    keybinds: [
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "Enter",
                            comment: "New window",
                            macos: ["⌘", "↩"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "N",
                            comment: "New OS window",
                            macos: ["⌘", "N"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "W",
                            comment: "Close window",
                            macos: ["⇧", "⌘", "D"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "R",
                            comment: "Resize window",
                            macos: ["⌘", "R"]
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "]",
                            comment: "Next window"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "[",
                            comment: "Previous window"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "F",
                            comment: "Move window forward"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "B",
                            comment: "Move window backward"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "`",
                            comment: "Move window to top"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "F7",
                            comment: "Visually focus window"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "F8",
                            comment: "Visually swap window"
                        },
                        {
                            mods: ["Ctrl", "Shift"],
                            key: "1",
                            comment: "Focus specific window (1-9, 0)",
                            macos: ["⌘", "1"],
                            range: [1, 9, 0]
                        }
                    ]
                }
            ]
        }
    ]
};