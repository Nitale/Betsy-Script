#Requires AutoHotkey v2.0
#include Lib\OCR.ahk
#include GUI_Betsy_Script.ahk
#include Invite_Alt.ahk
#include Tools.ahk

OCR.GetAvailableLanguages()
OCR.LoadLanguage(lang:="FirstFromAvailableLanguages")

; Global variables
isActiveGLoop := false
isActiveBuffLoop := false
isActiveAutoClicker := false
isActiveModReroller := false
isActiveBuffSurvivalShutdown := false
isActiveAutoMysticFarm := true
toolTipTimer := 5000
AllWindows := WinGetList("ahk_exe DunDefGame.exe")
MainWindow := WinGetList("Dungeon Defenders 2", ,"[#] Dungeon Defenders 2 [#]")
AltAccountWindow := WinGetList("ahk_exe DunDefGame.exe", , "Dungeon Defenders 2",)
SortDD2Windows()
; Used to prevent concurrency issues with buff loops (pressing G, Boost initiate and Lavamancer)
buffInProgress := false

; F5 hotkey to toggle the script on/off
F5::Toggle("GLoop")
F6::GiveMana()
F7::Toggle("BuffLoop")
F9::Toggle("AutoClicker")
; F9::RightClickMystic()
^F9::Toggle("AutoMysticFarm")
F11::Toggle("ModReroller")
F12::Reload()
^j::AltJoinMainAccount()
^i::InviteAlt()
^u::SellBags()
^O::Toggle("BuffSurvivalShutdown")
; Select dd2 Windows ordered by PID
>Numpad1::ActivateWindow(1)
>Numpad2::ActivateWindow(2)
>Numpad3::ActivateWindow(3)
>Numpad4::ActivateWindow(4)

CoordMode "Pixel", "Client"
CoordMode "Mouse", "Client"

TogglesDown() {
  global isActiveGLoop, isActiveBuffLoop, isActiveAutoClicker, isActiveModReroller, isActiveBuffSurvivalShutdown
  isActiveGLoop := false
  isActiveBuffLoop := false
  isActiveAutoClicker := false
  isActiveModReroller := false
  isActiveBuffSurvivalShutdown := false

  SetTimer(SendBuffInitiate, 0)
  SetTimer(SendBuffLavamancer, 0)
  SetTimer(SendGLoop, 0)
  SetTimer(EndMapPopupInteraction, 0)
  SetTimer(AutoClicker, 0)
  SetTimer(ModReroller, 0)
}

Toggle(name) {
  global isActiveGLoop, isActiveBuffLoop, isActiveAutoClicker, isActiveModReroller, isActiveBuffSurvivalShutdown
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
      func := 0
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
    case "BuffSurvivalShutdown":
      isActive := isActiveBuffSurvivalShutdown
      displayName := "Buff Survival Shutdown"
      func := 0
      interval := 1000
    case "BuffSurvivalShutdown":
      isActive := isActiveBuffSurvivalShutdown
      displayName := "Buff Survival Shutdown"
      func := 0
      interval := 1000
  }
  
  if (isActive) {
    if (name = "ModReroller") {
      ToolTip("Mod Reroller Stopped")
      SetTimer(func, 0)
    }
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
      case "BuffSurvivalShutdown": isActiveBuffSurvivalShutdown := true
      case "AutoMysticFarm": isActiveAutoMysticFarm := true
    }
    ToolTip(displayName . " ON - Press " . GetKeyName(A_ThisHotkey) . " to disable")
    SetTimer(() => ToolTip(), -toolTipTimer)
    if (func != 0)
      func()
    switch name {
      case "":
      case "ModReroller":
        SetTimer(func, -interval)
      case "BuffLoop":
        SetTimer(SendGLoop, 5000)
        SetTimer(SendBuffInitiate, 17000)
        SetTimer(SendBuffLavamancer, 250)
      case "BuffSurvivalShutdown":
        SetTimer(SendGLoop, 5000)
        SetTimer(SendBuffInitiate, 17000)
        SetTimer(SendBuffLavamancer, 250)
        SetTimer(EndMapPopupInteraction, 15000)
      default:
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
  SortDD2Windows()
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
  global AllWindows
  try FlashWidget("GiveMana")
  ToolTip("Giving Mana", 3000)
  SetTimer(() => ToolTip(), -toolTipTimer)
  MultiAccountActionKey("ml", AllWindows)
}

SendGLoop() {
  global MainWindow, AllWindows, buffInProgress
  if (buffInProgress) {
    return
  }
  ; UpdateDunDefWindows()
  MultiAccountActionKey("g", AllWindows)
  Sleep(100)
  MultiAccountActionKey("y", AllWindows)
  Sleep(100)
}

SendBuffInitiate() {
  global MainWindow, buffInProgress
  SetTimer(SendBuffLavamancer, 0)
  buffInProgress := true

  WinGetPos(&x, &y, &w, &h, AllWindows[1])
  ControlSend("3", , "ahk_id " AllWindows[1])
  Sleep(200)
  ControlClick("x0 y0", "ahk_id " AllWindows[1], , "Left", , ,)
  buffInProgress := false
  SetTimer(SendBuffLavamancer, 250)
}

SendBuffLavamancer() {
  global AllWindows, buffInProgress
  if (buffInProgress) {
    return
  }
  ControlSend("3", , "ahk_id " AllWindows[2])
  ControlClick("x0 y0", "ahk_id " AllWindows[2], , "Left", , ,)
}

RightClickMystic() {
  Loop {
    ControlClick("x0 y0", "ahk_id " AllWindows[1], , "Right", , ,)
    Sleep(100)
  }
  ; ControlClick("x0 y0", "ahk_id " AllWindows[1], , "Right", , ,)
}

AutoClicker() {
  MouseClick("right", , ,)
  ; ControlClick("x0 y0", "ahk_id " AllWindows[1], , "Right", 40, ,)
  ; Click "Right"
}

ModReroller() {
  global isActiveModReroller
  WinGetPos &x, &y, &w, &h, AllWindows[1]

  regionW := w // 3
  regionH := h // 4
  centerX := x + w // 2
  centerY := y + h // 2
  searchX1 := centerX - regionW // 2
  searchY1 := centerY - regionH // 2
  searchX2 := searchX1 + regionW - 1
  searchY2 := searchY1 + regionH - 1

  Loop 287 {
    if !isActiveModReroller {
      ToolTip("Mod Reroller Stopped")
      SetTimer(ModReroller, 0)
      return
    }
    ControlSend("{Enter}", , AllWindows[1])
    Sleep(500)
    if !isActiveModReroller {
      ToolTip("Mod Reroller Stopped")
      SetTimer(() => ToolTip(), -toolTipTimer)
      return
    }
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
  ; UpdateDunDefWindows()
  try FlashWidget("AltJoinMainAccount")
  ; Default Sandboxie path if not defined in config.ini
  sandboxiePath := IniRead("config.ini", "Steam", "SandboxiePath") != "" ? IniRead("config.ini", "Steam", "SandboxiePath") : A_ProgramFiles "\Sandboxie-Plus\Start.exe"
  sandboxieboxes := "/box:Steam_"
  mainSteam := IniRead("config.ini", "Steam", "SteamInvitelink")

  Loop 3 {
    if (WinExist("ahk_class Sandbox:Steam_" A_Index ":LaunchUnrealUWindowsClient")) {
      Run sandboxiePath " " sandboxieboxes A_Index " " mainSteam
    }
  }
}

InviteAlt() {
    WinGetPos(&winX, &winY, &winW, &winH, "Dungeon Defenders 2", ,"[#] Dungeon Defenders 2 [#]")
    SetKeyDelay(50)
    ; UpdateDunDefWindows()
    try FlashWidget("InviteAltParty")
    ControlSend("{Escape}", , "ahk_id " MainWindow[1])
    Sleep(500)
    MouseMove(winX + winW // 2, winY)
    Loop 3 {
        AltInvit(A_Index)
    }
    ControlSend("{Escape}", , "ahk_id " MainWindow[1])
    Sleep(2000)
    MultiAccountActionKey("y", AllWindows)
}

SellBags() {
  ; UpdateDunDefWindows()
  ; SelectFirstBag()
  MultiAccountActionKey("i", AllWindows)
  Sleep(300)
  loop 6 {
    MultiAccountActionKey("e", AllWindows)
    MultiAccountActionKey("y", AllWindows)
    Sleep(4000)
    MultiAccountActionKey("{enter}", AllWindows)
  }
  MultiAccountActionKey("i", AllWindows)
}

EndMapPopupInteraction() {
  ; UpdateDunDefWindows()
  CoordMode "Pixel", "Client"
  CoordMode "Mouse", "Client"
  WinGetPos(&x, &y, &w, &h, AllWindows[1])
  if EndMapopupPosition.Has(String(w)) {
    WinActivate(AllWindows[1])
    MouseMove(EndMapopupPosition[String(w)].x, EndMapopupPosition[String(w)].y)
    Sleep(200)
    if (PixelGetColor(EndMapopupPosition[String(w)].x, EndMapopupPosition[String(w)].y) == EndMapopupPosition[String(w)].color) {
      MouseClick("Left", , , 1, 0)
      Sleep(45000)
      Shutdown(13)
    }
  }
}

ReplayPopupInteraction() {
  ; UpdateDunDefWindows()
  CoordMode "Pixel", "Client"
  CoordMode "Mouse", "Client"
  WinGetPos(&x, &y, &w, &h, MainWindow[1])
  if EndMapopupPosition.Has(String(w)) {
    WinActivate(MainWindow[1])
    MouseMove(EndMapopupPosition[String(w)].x, EndMapopupPosition[String(w)].y)
    Sleep(200)
    if (PixelGetColor(EndMapopupPosition[String(w)].x, EndMapopupPosition[String(w)].y) == EndMapopupPosition[String(w)].color) {
      MouseClick("Left", , , 1, 0)
      Sleep(45000)
      Shutdown(13)
    }
  }
}

ActivateWindow(windowIndex) {
  global AllWindows
  UpdateDunDefWindows()
  if (AllWindows.Has(windowIndex))
    WinActivate(AllWindows[windowIndex])
}

#include GUI_Betsy_Script.ahk
ToolTip("Betsy Script Loaded !")
SetTimer(() => ToolTip(), -toolTipTimer)