#Requires AutoHotkey v2.0

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
  "1920", { x: 1402, y: 954, color: 0xFEEA00 }
)

ReplayPopupPosition := Map(
  "1920", { x: 1166, y: 957, color: 0x0D0AB }
)

SelectFirstBag() {
  global AllWindows
  UpdateDunDefWindows()
  MultiAccountActionKey("i", AllWindows)
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
    }
  }
}