AltInvit(altIndex) {
  ControlSend("{Right}", , "ahk_id " MainWindow[1])
  loop altIndex-1 {
    ControlSend("{Up}", , "ahk_id " MainWindow[1])
  }
  ControlSend("{Enter}", , "ahk_id " MainWindow[1])
  Sleep(100)
  ControlSend("{Left}", , "ahk_id " MainWindow[1])
  ControlSend("{Down}", , "ahk_id " MainWindow[1])
  ControlSend("{Enter}", , "ahk_id " MainWindow[1])
  Sleep(100)
  ControlSend("{Escape}", , "ahk_id " MainWindow[1])
}