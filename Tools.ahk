#Requires AutoHotkey v2.0

class Resolution {
    static 1920x1080 := "1920"
    static 1440x900 := "1456"
}

; For some reason in windowed mode the resolution is not the same as fullscreen/fullscreen windowed
firstBagPosition := Map(
  "1920", { x: 1250, y: 164},
  "1456",  { x: 938, y: 166},
  "1866", { x: 1206, y: 160}
)

FirstGPixelPosition := Map(
  "1920", { x: 757, y: 534, color: 0xed8515},
  "1456",  { x: 938, y: 166, color: 0x000000},
  "1866", { x: 1206, y: 160, color: 0x000000}
)

GWavePosition := Map(
  "1920", { x: 877, y: 526, color: 0x000000},
  "1456",  { x: 938, y: 166, color: 0x000000},
  "1866", { x: 1206, y: 160, color: 0x000000}
)

LastGPixelPosition := Map(
  "1920", { x: 877, y: 526, color: 0x000000},
  "1456",  { x: 938, y: 166, color: 0x000000},
  "1866", { x: 1206, y: 160, color: 0x000000}
)

EndMapopupPosition := Map(
  "1920", { x: 1402, y: 954, color: 0xFEEA00 },
  "1456",  { x: 938, y: 166, color: 0x000000 },
  "1866", { x: 1206, y: 160, color: 0x000000 }
)

ReplayPopupPosition := Map(
  "1920", { x: 1166, y: 957, color: 0x0D0AB },
  "1456",  { x: 938, y: 166, color: 0x000000 },
  "1866", { x: 1206, y: 160, color: 0x000000 }
)

SortDD2Windows() {
  global AllWindows
  ; Simple bubble sort
  for i, hwnd1 in AllWindows {
    for j, hwnd2 in AllWindows {
      if j > i {
        title1 := WinGetTitle(hwnd1)
        title2 := WinGetTitle(hwnd2)
        
        ; Create sort keys: plain title gets "0", others keep original
        key1 := (title1 = "Dungeon Defenders 2") ? "0" : title1
        key2 := (title2 = "Dungeon Defenders 2") ? "0" : title2
        
        ; Swap if first key is greater than second
        if (StrCompare(key1, key2) > 0) {
          temp := AllWindows[i]
          AllWindows[i] := AllWindows[j] 
          AllWindows[j] := temp
        }
      }
    }
  }
}

SelectFirstBag() {
  global AllWindows
  UpdateDunDefWindows()
  Sleep(200)
  for window in AllWindows {
    WinGetPos &x, &y, &w, &h, window
    widthWindow := String(w)
    try ClickFirstBag(firstBagPosition[widthWindow], window)
    catch {
      ToolTip("Unsupported resolution: " w "x" h, 3000)
      SetTimer(() => ToolTip(), -3000)
    }
  }
}

ClickFirstBag(firstBag, window) {
  WinActivate("ahk_id " window)
  CoordMode("Mouse", "Client")
  Sleep(500)
  MouseMove(firstBag.x, firstBag.y)
  MouseClick("Left", firstBag.x, firstBag.y)
}
