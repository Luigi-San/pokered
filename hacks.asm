; Rena's various hacks can be toggled/configured here.
; Note that changing these settings and then loading an existing save file might
; have various issues from not being able to walk at all to just immediately
; crashing the game.
; With these hacks disabled (all set to 0), the ROM should build identical
; to the original.


; hacks to increase player's walking speed.
; 0: normal (slow) walking speed.
; 1: fast walking (always run).
; 2: normal walking; hold B to run (anywhere)
; 3: normal walking; hold B to run (only outdoors/on maps that allow biking)
HACK_RUNNING_SHOES EQU 1


; hacks to deal with that stupid health alarm beep
; 0: leave it alone
; 1: disable it completely
; 2: beep a few times then stop
HACK_LOW_HEALTH_ALARM EQU 2

;how many times to beep, with mode 2 (1 to 127)
HACK_LOW_HEALTH_ALARM_COUNT EQU 3


; hack to enhance the battle screen:
; * Display power and accuracy of selected move.
; * Display PP of all moves.
; * Display "caught" indicator next to opponent
; Planned enhancements:
; * EXP bars
; * Display a move's category (physical/special/status)
HACK_ENHANCE_BATTLE_SCREEN EQU 1


; Enable the original debug mode (bit 1 of wd732)
; This activates the following functions in the existing code:
; * Skip new game intro (use default names)
; * Start new game outside player's house
; * Hold B to prevent wild encounters
; note that this hack might interfere with link battles, because those turn
; the debug mode off for some reason, but this hack forces it back on.
; probably this has to do with them re-using the "destination map" variable.
HACK_ENABLE_DEBUG_MODE EQU 1
