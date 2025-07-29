#Requires AutoHotkey v2.0

; Global variable to store the GUI object
g_MainGui := ""
g_GuiWidgets := Map()

ShowMainGui() {
    global isActiveGLoop, isActiveBuffLoop, isActiveAutoClicker, isActiveModReroller, g_MainGui, g_GuiWidgets

    ; Close existing GUI if it exists
    if (g_MainGui != "" && IsObject(g_MainGui)) {
        try {
            g_MainGui.Destroy()
        }
    }
    
    ; Create new GUI
    g_MainGui := Gui("+AlwaysOnTop", "Betsy Script Controls")

    widgetDefs := [
        ["Ctrl + J", "AltJoinMainAccount", "Alt Join Main", ""],
        ["F5", "GLoop", "Press G", "isActiveGLoop"],
        ["F6", "GiveMana", "Give Mana", ""],
        ["F7", "BuffLoop", "Auto Buff", "isActiveBuffLoop"],
        ["F9", "AutoClicker", "Auto Clicker", "isActiveAutoClicker"],
        ["F11", "ModReroller", "Mod Reroller", "isActiveModReroller"],
        ["F12", "ExitApp", "Exit Script", ""]
    ]

    y := 10
    for def in widgetDefs {
        key := def[2]  ; This is the function name (GLoop, BuffLoop, etc.)
        widgetText := def[1] . " - " . def[3]  ; F5 - Press G
        
        ; Create text widgets instead of buttons
        widget := g_MainGui.Add("Text", "x10 y" . y . " w200 h30 Center Border Background0xFF0000 c0xFFFFFF vwidget" . key, widgetText)
        g_GuiWidgets[key] := widget
        y += 40
    }

    UpdateGuiWidgetColors()
    g_MainGui.Show("AutoSize")
}

UpdateGuiWidgetColors() {
    global isActiveGLoop, isActiveBuffLoop, isActiveAutoClicker, isActiveModReroller, g_GuiWidgets
    
    widgetStates := Map(
        "GLoop", isActiveGLoop,
        "BuffLoop", isActiveBuffLoop,
        "AutoClicker", isActiveAutoClicker,
        "ModReroller", isActiveModReroller
    )
    
    for key, widget in g_GuiWidgets {
        try {
            if (key = "GiveMana") {
                widget.Opt("Background0xFF0000")
                widget.Opt("c0xFFFFFF")
            } else if (widgetStates.Has(key) && widgetStates[key]) {
                widget.Opt("Background0x00FF00")
                widget.Opt("c0x000000")
            } else {
                widget.Opt("Background0xFF0000")
                widget.Opt("c0xFFFFFF")
            }
        }
    }
}

; Function to update GUI when hotkeys are pressed
UpdateGuiFromHotkey(functionName) {
    global g_GuiWidgets
    if (g_GuiWidgets.Has(functionName)) {
        UpdateGuiWidgetColors()
    }
}

; Function to flash Give Mana widget green
FlashWidget(widgetName) {
    global g_GuiWidgets
    if (widgetName == "GiveMana") {
        widget := g_GuiWidgets["GiveMana"]
        try {
            widget.Opt("Background0x00FF00")
            widget.Opt("c0x000000")
            SetTimer(() => (widget.Opt("Background0xFF0000"), widget.Opt("c0xFFFFFF")), -3000)
        }
    }
    if (widgetName == "AltJoinMainAccount") {
        widget := g_GuiWidgets["AltJoinMainAccount"]
        try {
            widget.Opt("Background0x00FF00")
            widget.Opt("c0x000000")
            SetTimer(() => (widget.Opt("Background0xFF0000"), widget.Opt("c0xFFFFFF")), -3000)
        }
    }
}

^F1::ShowMainGui()