#Requires AutoHotkey v2.0
#include Lib\OCR.ahk
#include GUI_Betsy_Script.ahk

OCR.GetAvailableLanguages()
OCR.LoadLanguage(lang:="FirstFromAvailableLanguages")

; Global variables
isActiveGLoop := false
isActiveBuffLoop := false
isActiveAutoClicker := false
isActiveModReroller := false
toolTipTimer := 5000
AllWindows := WinGetList("ahk_exe DunDefGame.exe")
MainWindow := WinGetList("Dungeon Defenders 2", ,"[#] Dungeon Defenders 2 [#]")
AltAccountWindow := WinGetList("[#] Dungeon Defenders 2 [#]")

; F5 hotkey to toggle the script on/off
F5::Toggle("GLoop")
F6::GiveMana()
F7::Toggle("BuffLoop")
F9::Toggle("AutoClicker")
F11::Toggle("ModReroller")
^j::AltJoinMainAccount()

TogglesDown() {
    global isActiveGLoop, isActiveBuffLoop, isActiveAutoClicker, isActiveModReroller
    isActiveGLoop := false
    isActiveBuffLoop := false
    isActiveAutoClicker := false
    isActiveModReroller := false

    SetTimer(SendGLoop, 0)
    SetTimer(SendBuffLoop, 0)
    SetTimer(AutoClicker, 0)
    SetTimer(ModReroller, 0)
}

Toggle(name) {
    global isActiveGLoop, isActiveBuffLoop, isActiveAutoClicker, isActiveModReroller
    ; Get current state and settings based on name
    switch name {
        case "GLoop":
            isActive := isActiveGLoop
            displayName := "Press G"
            func := SendGLoop
            interval := toolTipTimer
        case "BuffLoop":
            isActive := isActiveBuffLoop
            displayName := "Auto Buff"
            func := SendBuffLoop
            interval := toolTipTimer
        case "AutoClicker":
            isActive := isActiveAutoClicker
            displayName := "Auto Clicker"
            func := AutoClicker
            interval := 5
        case "ModReroller":
            isActive := isActiveModReroller
            displayName := "Mod Reroller"
            func := ModReroller
            interval := 1000
    }
    
    if (isActive) {
        TogglesDown()
        ToolTip(displayName . " OFF - Press " . GetKeyName(A_ThisHotkey) . " to enable")
        SetTimer(() => ToolTip(), -toolTipTimer)
    } else {
        TogglesDown()
        ; Set the specific variable to true
        switch name {
            case "GLoop": isActiveGLoop := true
            case "BuffLoop": isActiveBuffLoop := true
            case "AutoClicker": isActiveAutoClicker := true
            case "ModReroller": isActiveModReroller := true
        }
        ToolTip(displayName . " ON - Press " . GetKeyName(A_ThisHotkey) . " to disable")
        SetTimer(() => ToolTip(), -toolTipTimer)
        func()
        if (name = "ModReroller") {
            SetTimer(func, -interval)
        }
        else {
            SetTimer(func, interval)
        }
    }
    try UpdateGuiFromHotkey(name)
}

UpdateDunDefWindows() {
    global MainWindow, AltAccountWindow, AllWindows
    MainWindow := WinGetList("Dungeon Defenders 2", ,"[#] Dungeon Defenders 2 [#]")
    AltAccountWindow := WinGetList("[#] Dungeon Defenders 2 [#]")
    AllWindows := WinGetList("ahk_exe DunDefGame.exe")
}

MultiAccountActionKey(action, windowsList) {
  for windowID in windowsList {
    try {
      ControlSend(action, , "ahk_id " windowID)
    } catch {
    }
  }
}

GiveMana() {
    global AltAccountWindow
    try FlashWidget("GiveMana")
    ToolTip("Giving Mana", 3000)
    SetTimer(() => ToolTip(), -toolTipTimer)
    UpdateDunDefWindows()
    MultiAccountActionKey("ml", AltAccountWindow)
}

SendGLoop() {
    global MainWindow, AltAccountWindow, AllWindows
    UpdateDunDefWindows()
    MultiAccountActionKey("g", AllWindows)
}

SendBuffLoop() {
    global MainWindow, AltAccountWindow, AllWindows
    UpdateDunDefWindows()
    MultiAccountActionKey("g", AllWindows)
    MultiAccountActionKey("3", MainWindow)
    Sleep(400)
    ControlClick(, "ahk_id " MainWindow[1], , "Left", , ,)
}

AutoClicker() {
    MouseClick("Right")
}

ModReroller() {
    WinGetPos &x, &y, &w, &h, MainWindow[1]

    regionW := w // 3
    regionH := h // 4
    centerX := x + w // 2
    centerY := y + h // 2
    searchX1 := centerX - regionW // 2
    searchY1 := centerY - regionH // 2
    searchX2 := searchX1 + regionW - 1
    searchY2 := searchY1 + regionH - 1

    Loop 287 {
        ControlSend("{Enter}", , MainWindow[1])
        Sleep(500)
        result := OCR.FromRect(searchX1, searchY1, regionW, regionH, {grayscale: true, scale: 5.0})
        ; If mod is 10
        if RegExMatch(result.Text, "\b(maximum|achieved|OK)\b", &m) {
            MsgBox "Mod rerolled at 10 !" . result.Text
            TogglesDown()
            return
        }
        ControlSend("{Enter}", , MainWindow[1])
    }
}

AltJoinMainAccount() {
  UpdateDunDefWindows()
  try FlashWidget("AltJoinMainAccount")
  ; Default Sandboxie path if not defined in config.ini
  sandboxiePath := IniRead("config.ini", "Steam", "SandboxiePath") != "" ? IniRead("config.ini", "Steam", "SandboxiePath") : A_ProgramFiles "\Sandboxie-Plus\Start.exe"
  sandboxieboxes := "/box:Steam_"
  mainSteam := IniRead("config.ini", "Steam", "SteamInvitelink")

  for index, windowID in AltAccountWindow {
    if (WinExist("ahk_class Sandbox:Steam_" index ":LaunchUnrealUWindowsClient")) {
      Run sandboxiePath " " sandboxieboxes index " " mainSteam
    }
  }
}

F12::ExitApp()

#include GUI_Betsy_Script.ahk
ToolTip("Betsy Script Loaded !")
SetTimer(() => ToolTip(), -toolTipTimer)