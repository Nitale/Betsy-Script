#Requires AutoHotkey v2.0

SortWindowsByPID() {
  global AllWindows
  Loop AllWindows.Length - 1 {
  i := A_Index
  Loop AllWindows.Length - i {
      j := A_Index
      if (WinGetPID(AllWindows[j]) > WinGetPID(AllWindows[j + 1])) {
          ; Swap elements
          temp := AllWindows[j]
          AllWindows[j] := AllWindows[j + 1]
          AllWindows[j + 1] := temp
      }
      }
  }
}