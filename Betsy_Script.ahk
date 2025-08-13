#Requires AutoHotkey v2.0
#include Lib\OCR.ahk
#include Buffs.ahk
#include GUI_Betsy_Script.ahk
#include UI_Interactions.ahk
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
^F9::Toggle("AutoMysticFarm")
F11::Toggle("ModReroller")
F12::Reload()
^j::AltJoinMainAccount()
^i::InviteAlt()
^u::SellBags()
^O::Toggle("BuffSurvivalShutdown")
; Select dd2 Windows ordered by alphabetical order
>Numpad1::ActivateWindow(1)
>Numpad2::ActivateWindow(2)
>Numpad3::ActivateWindow(3)
>Numpad4::ActivateWindow(4)

; To use window coordinates instead of screen coordinates
CoordMode "Pixel", "Client"
CoordMode "Mouse", "Client"

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

AutoClicker() {
  MouseClick("right", , ,)
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
  UpdateDunDefWindows()
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
    UpdateDunDefWindows()
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
  UpdateDunDefWindows()
  SelectFirstBag()
  Sleep(300)
  loop 6 {
    MultiAccountActionKey("e", AllWindows)
    MultiAccountActionKey("y", AllWindows)
    Sleep(4000)
    MultiAccountActionKey("{enter}", AllWindows)
  }
  MultiAccountActionKey("i", AllWindows)
}

ActivateWindow(windowIndex) {
  global AllWindows
  UpdateDunDefWindows()
  if (AllWindows.Has(windowIndex))
    WinActivate(AllWindows[windowIndex])
}

ToolTip("Betsy Script Loaded !")
SetTimer(() => ToolTip(), -toolTipTimer)