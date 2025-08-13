#Requires AutoHotkey v2.0

SendBuffInitiate() {
  global MainWindow, buffInProgress
  SetTimer(SendBuffLavamancer, 0)
  buffInProgress := true

  WinGetPos(&x, &y, &w, &h, AllWindows[1])
  ControlSend("3", , "ahk_id " AllWindows[1])
  Sleep(1000)
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