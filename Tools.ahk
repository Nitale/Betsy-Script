#Requires AutoHotkey v2.0

MultiAccountActionKey(action, windowsList) {
  for windowID in windowsList {
    try {
      ControlSend(action, , "ahk_id " windowID)
    } catch {
    }
  }
}

UpdateDunDefWindows() {
  global MainWindow, AltAccountWindow, AllWindows
  MainWindow := WinGetList("Dungeon Defenders 2", ,"[#] Dungeon Defenders 2 [#]")
  AltAccountWindow := WinGetList("[#] Dungeon Defenders 2 [#]")
  AllWindows := WinGetList("ahk_exe DunDefGame.exe")
  SortDD2Windows()
}

SortDD2Windows() {
  global AllWindows
  
  n := AllWindows.Length
  Loop n-1 {
    i := A_Index
    Loop n-i {
      j := A_Index
      title1 := WinGetTitle(AllWindows[j])
      title2 := WinGetTitle(AllWindows[j+1])
      
      key1 := RegExReplace(title1, "[ \[#\]]", "")
      key2 := RegExReplace(title2, "[ \[#\]]", "")
      
      if (StrCompare(key1, key2) > 0) {
        temp := AllWindows[j]
        AllWindows[j] := AllWindows[j+1]
        AllWindows[j+1] := temp
      }
    }
  }
}

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