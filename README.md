# DD2 Script

AutoHotkey automation script for Dungeon Defenders 2 multi-account management and gameplay assistance.

## Installation

1. Download and install [AutoHotkey v2.0](https://www.autohotkey.com/v2/)
2. Run `Betsy_Script.ahk`

## Rebind a key

Feel Free to rebind keys to whatever you like (at the beginning of `Betsy_Script.ahk` file), some useful keys :
- `^` is for Ctrl
- `+` is for Shift
- `numpad` is for numpad keys

You can bind to multiple keys, example : `^F1` is for CTRL+F1

## Update

If you are unfamiliar with Git, You can run the `update.ps1` with powershell to update your files (internet connection required).

<strong><span style="color:red"> /!\ </span></strong>It will override your local files if you modified it

## Keys controls

Press `Ctrl+F1` to open the control GUI with visual status indicators (you can rebind at the beginning of `GUI_Betsy_Script.ahk`)

![image](images/doc/betsy_controls_gui.png)

### Configuration file

Rename file <strong>config.ini.example</strong> by <strong>config.ini</strong>

### Hotkeys and Functions

## Numpad1 | Numpad2

Press `numpad1` or `numpad2` to switch DD2 window. First dungeon defenders windows you started will be `numpad1` and the second will be `numpad2`

## Ctrl + J - Alt Join Main account

# config.ini
- In Sandboxie, rename your alt box "<Strong>Steam_1</strong>" (Will be displayed "<strong>Steam 1</strong>" in Sandboxie interface)
- (Optionnal) Fill <strong>SandboxiePath</strong>, if not specified, will take the default Sandboxie Installation Path.
- Fill <strong>SteamInvitelink</strong>.

To find your <strong>Steam invite link</strong> :
1. Run Steam and Dungeon Defenders 2 (you must be in a joinable lobby)
2. Go to your profile
3. Copy paste this link : \
![image](images/doc/steam_link_invit.png)

# Usage
1. Main account must be in a joignable lobby
2. Alt account game must be started (can be in menu)
3. Press `Ctrl + J` to make your alt join your lobby

## Ctrl + I - Main account invite alt
1. Main account must be in a joignable lobby
2. Only main account and alt in lobby
3. Press `Ctrl + I` to invite your alt to party

## Ctrl + U - Sell Bags
1. Your accounts must not be in inventory
2. first bag tab for you inventorys accounts
3. Assuming you have maximum bags, it will sell all in every bags exept first and last bag. If you don't have maximum bags, it sells all bags

Tips : Lock wanted mods, items, use first bag as materials, last bag as shards and put eggs in one of the middle bag.

# Other Keys

**`F5` - Press G Loop**
- Press `g` on every dd2 windows every 5 seconds

**`F6` - Give Mana**
- Bind give all defense mana key to `m` for your alt account
- Bind respawn key to `l` for your alt account

**`F7` - Auto Buff**
- Press `g` on every windows
- Uses spell 3 every 5 seconds on main account window

**`F9` - Auto Clicker**
- Rapid right-click at currrent mouse position (useful to open shards, boxes, survival chests...)

**`F11` - Mod Reroller**

<strong><span style="color:red"> /!\ </span></strong>Press F12 if you wan't to stop the Mod Reroller (will reload the script), F11 currently doesn't work

You should hover your mouse over this area before pressing `F11` : \
![image](images/doc/token_reroll.png)
- Automatically reroll mod until 10
- Stops when "maximum", "achieved", or "OK" detected in center screen region
- Runs up to a maximum of 287 times before it stops 

**`F12` - Reload Script**
- Reload the script

## Window Detection

Script automatically detects:
- Main window: "Dungeon Defenders 2"
- Alt account: Windows titled "[#] Dungeon Defenders 2 [#]"
- All game windows: Any process named "DunDefGame.exe"