MainMenu: ; 5af2 (1:5af2)
; Check save file
	call Func_5bff
	xor a
	ld [wd08a],a
	inc a
	ld [wd088],a
	call Func_609e
	jr nc,.next0

	; Predef 52 loads the save from SRAM to RAM
	predef LoadSAV

.next0
	ld c,20
	call DelayFrames
	xor a
	ld [W_ISLINKBATTLE],a
	ld hl,wcc2b
	ld [hli],a
	ld [hli],a
	ld [hli],a
	ld [hl],a
	ld [W_ANIMATIONID],a
	ld hl,wd72e
	res 6,[hl]
	call ClearScreen
	call GoPAL_SET_CF1C
	call LoadTextBoxTilePatterns
	call LoadFontTilePatterns
	ld hl,wd730
	set 6,[hl]
	ld a,[wd088]
	cp a,1
	jr z,.next1
	hlCoord 0, 0
	ld b,6
	ld c,13
	call TextBoxBorder
	hlCoord 2, 2
	ld de,ContinueText
	call PlaceString
	jr .next2
.next1
	hlCoord 0, 0
	ld b,4
	ld c,13
	call TextBoxBorder
	hlCoord 2, 2
	ld de,NewGameText
	call PlaceString
.next2
	ld hl,wd730
	res 6,[hl]
	call UpdateSprites ; OAM?
	xor a
	ld [wCurrentMenuItem],a
	ld [wLastMenuItem],a
	ld [wMenuJoypadPollCount],a
	inc a
	ld [wTopMenuItemX],a
	inc a
	ld [wTopMenuItemY],a
	ld a,$B
	ld [wMenuWatchedKeys],a
	ld a,[wd088]
	ld [wMaxMenuItem],a
	call HandleMenuInput
	bit 1,a
	jp nz,LoadTitlescreenGraphics ; load title screen (gfx and arrangement)
	ld c,20
	call DelayFrames
	ld a,[wCurrentMenuItem]
	ld b,a
	ld a,[wd088]
	cp a,2
	jp z,.next3
	inc b ; adjust MenuArrow_Counter
.next3
	ld a,b
	and a
	jr z,.next4 ; if press_A on Continue
	cp a,1
	jp z,Func_5d52 ; if press_A on NewGame
	call DisplayOptionMenu ; if press_a on Options
	ld a,1
	ld [wd08a],a
	jp .next0
.next4
	call ContinueGame
	ld hl,wd126
	set 5,[hl]
.next6
	xor a
	ld [hJoyPressed],a
	ld [hJoyReleased],a
	ld [hJoyHeld],a
	call Joypad
	ld a,[hJoyHeld]
	bit 0,a
	jr nz,.next5
	bit 1,a
	jp nz,.next0
	jr .next6
.next5
	call GBPalWhiteOutWithDelay3
	call ClearScreen
	ld a,4
	ld [wd52a],a
	ld c,10
	call DelayFrames
	ld a,[wd5a2]
	and a
	jp z,SpecialEnterMap
	ld a,[W_CURMAP] ; map ID
	cp a,HALL_OF_FAME
	jp nz,SpecialEnterMap
	xor a
	ld [wDestinationMap],a
	ld hl,wd732
	set 2,[hl] ; fly warp or dungeon warp
	call SpecialWarpIn
	jp SpecialEnterMap

Func_5bff: ; 5bff (1:5bff)
	ld a,1
	ld [wd358],a
	ld a,3
	ld [W_OPTIONS],a ;set default options
	ret

LinkMenu: ; 5c0a (1:5c0a)
	xor a
	ld [wd358], a
	ld hl, wd72e
	set 6, [hl]
	ld hl, TextTerminator_6b20 ; $6b20
	call PrintText
	call SaveScreenTilesToBuffer1
	ld hl, WhereWouldYouLikeText
	call PrintText
	hlCoord 5, 5
	ld b, $6
	ld c, $d
	call TextBoxBorder
	call UpdateSprites
	hlCoord 7, 7
	ld de, TradeCenterText
	call PlaceString
	xor a
	ld [wcd37], a
	ld [wd72d], a
	ld hl, wTopMenuItemY ; wTopMenuItemY
	ld a, $7
	ld [hli], a
	ld a, $6
	ld [hli], a
	xor a
	ld [hli], a
	inc hl
	ld a, $2
	ld [hli], a
	inc a
	ld [hli], a
	xor a
	ld [hl], a
.asm_5c52
	call HandleMenuInput
	and $3
	add a
	add a
	ld b, a
	ld a, [wCurrentMenuItem] ; wCurrentMenuItem
	add b
	add $d0
	ld [wcc42], a
	ld [wcc43], a
.asm_5c66
	call Func_2247
	ld a, [wcc3d]
	ld b, a
	and $f0
	cp $d0
	jr z, .asm_5c7d
	ld a, [wcc3e]
	ld b, a
	and $f0
	cp $d0
	jr nz, .asm_5c66
.asm_5c7d
	ld a, b
	and $c
	jr nz, .asm_5c8b
	ld a, [wcc42]
	and $c
	jr z, .asm_5c52
	jr .asm_5ca1
.asm_5c8b
	ld a, [wcc42]
	and $c
	jr z, .asm_5c98
	ld a, [$ffaa]
	cp $2
	jr z, .asm_5ca1
.asm_5c98
	ld a, b
	ld [wcc42], a
	and $3
	ld [wCurrentMenuItem], a ; wCurrentMenuItem
.asm_5ca1
	ld a, [$ffaa]
	cp $2
	jr nz, .asm_5cb1
	call DelayFrame
	call DelayFrame
	ld a, $81
	ld [$ff02], a
.asm_5cb1
	ld b, $7f
	ld c, $7f
	ld d, $ec
	ld a, [wcc42]
	and $8
	jr nz, .asm_5ccc
	ld a, [wCurrentMenuItem] ; wCurrentMenuItem
	cp $2
	jr z, .asm_5ccc
	ld c, d
	ld d, b
	dec a
	jr z, .asm_5ccc
	ld b, c
	ld c, d
.asm_5ccc
	ld a, b
	Coorda 6, 7
	ld a, c
	Coorda 6, 9
	ld a, d
	Coorda 6, 11
	ld c, $28
	call DelayFrames
	call LoadScreenTilesFromBuffer1
	ld a, [wcc42]
	and $8
	jr nz, .asm_5d2d
	ld a, [wCurrentMenuItem] ; wCurrentMenuItem
	cp $2
	jr z, .asm_5d2d
	xor a
	ld [wWalkBikeSurfState], a
	ld a, [wCurrentMenuItem] ; wCurrentMenuItem
	and a
	ld a, TRADE_CENTER
	jr nz, .asm_5cfc
	ld a, BATTLE_CENTER
.asm_5cfc
	ld [wd72d], a
	ld hl, PleaseWaitText
	call PrintText
	ld c, $32
	call DelayFrames
	ld hl, wd732  ;disable debug mode (maybe because
	res 1, [hl]   ;we're reusing wDestinationMap?)
	ld a, [W_ANIMATIONID] ; W_ANIMATIONID
	ld [wDestinationMap], a
	call SpecialWarpIn
	ld c, $14
	call DelayFrames
	xor a
	ld [wMenuJoypadPollCount], a ; wMenuJoypadPollCount
	ld [wcc42], a
	inc a
	ld [W_ISLINKBATTLE], a ; W_ISLINKBATTLE
	ld [wcc47], a
	jr SpecialEnterMap
.asm_5d2d
	xor a
	ld [wMenuJoypadPollCount], a ; wMenuJoypadPollCount
	call Delay3
	call Func_72d7
	ld hl, LinkCanceledText
	call PrintText
	ld hl, wd72e
	res 6, [hl]
	ret

WhereWouldYouLikeText: ; 5d43 (1:5d43)
	TX_FAR _WhereWouldYouLikeText
	db "@"

PleaseWaitText: ; 5d48 (1:5d48)
	TX_FAR _PleaseWaitText
	db "@"

LinkCanceledText: ; 5d4d (1:5d4d)
	TX_FAR _LinkCanceledText
	db "@"

Func_5d52: ; 5d52 (1:5d52)
	ld hl, wd732
	res 1, [hl] ;disable debug mode
	call OakSpeech
	ld c, $14
	call DelayFrames

; enter map after using a special warp or loading the game from the main menu
SpecialEnterMap: ; 5d5f (1:5d5f)
	xor a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ld [hJoy5], a
	ld [wd72d], a
	ld hl, wd732
	set 0, [hl] ; count play time
	call ResetPlayerSpriteData
	ld c, 20
	call DelayFrames
	ld a, [wcc47]
	and a
	ret nz
	jp EnterMap

ContinueText: ; 5d7e (1:5d7e)
	db "CONTINUE", $4e

NewGameText: ; 5d87 (1:5d87)
	db "NEW GAME", $4e
	db "OPTION@"

TradeCenterText: ; 5d97 (1:5d97)
	db "TRADE CENTER", $4e
	db "COLOSSEUM",    $4e
	db "CANCEL@"

ContinueGame: ; 5db5 (1:5db5)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a ; $ffba
	hlCoord 4, 7
	ld b, $8
	ld c, $e
	call TextBoxBorder
	hlCoord 5, 9
	ld de, SaveScreenInfoText
	call PlaceString
	hlCoord 12, 9
	ld de, wPlayerName ; wd158
	call PlaceString
	hlCoord 17, 11
	call Func_5e2f
	hlCoord 16, 13
	call Func_5e42
	hlCoord 13, 15
	call Func_5e55
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a ; $ffba
	ld c, $1e
	jp DelayFrames

PrintSaveScreenText: ; 5def (1:5def)
	xor a
	ld [H_AUTOBGTRANSFERENABLED], a
	ld hl, wTileMap + $4
	ld b, $8
	ld c, $e
	call TextBoxBorder
	call LoadTextBoxTilePatterns
	call UpdateSprites
	ld hl, wTileMap + $2d
	ld de, SaveScreenInfoText
	call PlaceString
	ld hl, wTileMap + $34
	ld de, wPlayerName
	call PlaceString
	ld hl, wTileMap + $61
	call Func_5e2f
	ld hl, wTileMap + $88
	call Func_5e42
	ld hl, wTileMap + $ad
	call Func_5e55
	ld a, $1
	ld [H_AUTOBGTRANSFERENABLED], a
	ld c, $1e
	jp DelayFrames

Func_5e2f: ; 5e2f (1:5e2f)
	push hl
	ld hl, W_OBTAINEDBADGES
	ld b, $1
	call CountSetBits
	pop hl
	ld de, wd11e
	ld bc, $102
	jp PrintNumber

Func_5e42: ; 5e42 (1:5e42)
	push hl
	ld hl, wPokedexOwned ; wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	pop hl
	ld de, wd11e
	ld bc, $103
	jp PrintNumber

Func_5e55: ; 5e55 (1:5e55)
	ld de, W_PLAYTIMEHOURS + 1
	ld bc, $103
	call PrintNumber
	ld [hl], $6d
	inc hl
	ld de, W_PLAYTIMEMINUTES + 1
	ld bc, $8102
	jp PrintNumber

SaveScreenInfoText: ; 5e6a (1:5e6a)
	db   "PLAYER"
	next "BADGES    "
	next "#DEX    "
	next "TIME@"

DisplayOptionMenu: ; 5e8a (1:5e8a)
	hlCoord 0, 0
	ld b,3
	ld c,18
	call TextBoxBorder
	hlCoord 0, 5
	ld b,3
	ld c,18
	call TextBoxBorder
	hlCoord 0, 10
	ld b,3
	ld c,18
	call TextBoxBorder
	hlCoord 1, 1
	ld de,TextSpeedOptionText
	call PlaceString
	hlCoord 1, 6
	ld de,BattleAnimationOptionText
	call PlaceString
	hlCoord 1, 11
	ld de,BattleStyleOptionText
	call PlaceString
	hlCoord 2, 16
	ld de,OptionMenuCancelText
	call PlaceString
	xor a
	ld [wCurrentMenuItem],a
	ld [wLastMenuItem],a
	inc a
	ld [wd358],a
	ld [wTrainerScreenY],a
	ld a,3 ; text speed cursor Y coordinate
	ld [wTopMenuItemY],a
	call SetCursorPositionsFromOptions
	ld a,[wWhichTrade] ; text speed cursor X coordinate
	ld [wTopMenuItemX],a
	ld a,$01
	ld [H_AUTOBGTRANSFERENABLED],a ; enable auto background transfer
	call Delay3
.loop
	call PlaceMenuCursor
	call SetOptionsFromCursorPositions
.getJoypadStateLoop
	call JoypadLowSensitivity
	ld a,[hJoy5]
	ld b,a
	and a,%11111011 ; any key besides select pressed?
	jr z,.getJoypadStateLoop
	bit 1,b ; B button pressed?
	jr nz,.exitMenu
	bit 3,b ; Start button pressed?
	jr nz,.exitMenu
	bit 0,b ; A button pressed?
	jr z,.checkDirectionKeys
	ld a,[wTopMenuItemY]
	cp a,16 ; is the cursor on Cancel?
	jr nz,.loop
.exitMenu
	ld a,(SFX_02_40 - SFX_Headers_02) / 3
	call PlaySound ; play sound
	ret
.eraseOldMenuCursor
	ld [wTopMenuItemX],a
	call EraseMenuCursor
	jp .loop
.checkDirectionKeys
	ld a,[wTopMenuItemY]
	bit 7,b ; Down pressed?
	jr nz,.downPressed
	bit 6,b ; Up pressed?
	jr nz,.upPressed
	cp a,8 ; cursor in Battle Animation section?
	jr z,.cursorInBattleAnimation
	cp a,13 ; cursor in Battle Style section?
	jr z,.cursorInBattleStyle
	cp a,16 ; cursor on Cancel?
	jr z,.loop
.cursorInTextSpeed
	bit 5,b ; Left pressed?
	jp nz,.pressedLeftInTextSpeed
	jp .pressedRightInTextSpeed
.downPressed
	cp a,16
	ld b,-13
	ld hl,wWhichTrade
	jr z,.updateMenuVariables
	ld b,5
	cp a,3
	inc hl
	jr z,.updateMenuVariables
	cp a,8
	inc hl
	jr z,.updateMenuVariables
	ld b,3
	inc hl
	jr .updateMenuVariables
.upPressed
	cp a,8
	ld b,-5
	ld hl,wWhichTrade
	jr z,.updateMenuVariables
	cp a,13
	inc hl
	jr z,.updateMenuVariables
	cp a,16
	ld b,-3
	inc hl
	jr z,.updateMenuVariables
	ld b,13
	inc hl
.updateMenuVariables
	add b
	ld [wTopMenuItemY],a
	ld a,[hl]
	ld [wTopMenuItemX],a
	call PlaceUnfilledArrowMenuCursor
	jp .loop
.cursorInBattleAnimation
	ld a,[wTrainerEngageDistance] ; battle animation cursor X coordinate
	xor a,$0b ; toggle between 1 and 10
	ld [wTrainerEngageDistance],a
	jp .eraseOldMenuCursor
.cursorInBattleStyle
	ld a,[wTrainerFacingDirection] ; battle style cursor X coordinate
	xor a,$0b ; toggle between 1 and 10
	ld [wTrainerFacingDirection],a
	jp .eraseOldMenuCursor
.pressedLeftInTextSpeed
	ld a,[wWhichTrade] ; text speed cursor X coordinate
	cp a,1
	jr z,.updateTextSpeedXCoord
	cp a,7
	jr nz,.fromSlowToMedium
	sub a,6
	jr .updateTextSpeedXCoord
.fromSlowToMedium
	sub a,7
	jr .updateTextSpeedXCoord
.pressedRightInTextSpeed
	ld a,[wWhichTrade] ; text speed cursor X coordinate
	cp a,14
	jr z,.updateTextSpeedXCoord
	cp a,7
	jr nz,.fromFastToMedium
	add a,7
	jr .updateTextSpeedXCoord
.fromFastToMedium
	add a,6
.updateTextSpeedXCoord
	ld [wWhichTrade],a ; text speed cursor X coordinate
	jp .eraseOldMenuCursor

TextSpeedOptionText: ; 5fc0 (1:5fc0)
	db   "TEXT SPEED"
	next " FAST  MEDIUM SLOW@"

BattleAnimationOptionText: ; 5fde (1:5fde)
	db   "BATTLE ANIMATION"
	next " ON       OFF@"

BattleStyleOptionText: ; 5ffd (1:5ffd)
	db   "BATTLE STYLE"
	next " SHIFT    SET@"

OptionMenuCancelText: ; 6018 (1:6018)
	db "CANCEL@"

; sets the options variable according to the current placement of the menu cursors in the options menu
SetOptionsFromCursorPositions: ; 601f (1:601f)
	ld hl,TextSpeedOptionData
	ld a,[wWhichTrade] ; text speed cursor X coordinate
	ld c,a
.loop
	ld a,[hli]
	cp c
	jr z,.textSpeedMatchFound
	inc hl
	jr .loop
.textSpeedMatchFound
	ld a,[hl]
	ld d,a
	ld a,[wTrainerEngageDistance] ; battle animation cursor X coordinate
	dec a
	jr z,.battleAnimationOn
.battleAnimationOff
	set 7,d
	jr .checkBattleStyle
.battleAnimationOn
	res 7,d
.checkBattleStyle
	ld a,[wTrainerFacingDirection] ; battle style cursor X coordinate
	dec a
	jr z,.battleStyleShift
.battleStyleSet
	set 6,d
	jr .storeOptions
.battleStyleShift
	res 6,d
.storeOptions
	ld a,d
	ld [W_OPTIONS],a
	ret

; reads the options variable and places menu cursors in the correct positions within the options menu
SetCursorPositionsFromOptions: ; 604c (1:604c)
	ld hl,TextSpeedOptionData + 1
	ld a,[W_OPTIONS]
	ld c,a
	and a,$3f
	push bc
	ld de,2
	call IsInArray
	pop bc
	dec hl
	ld a,[hl]
	ld [wWhichTrade],a ; text speed cursor X coordinate
	hlCoord 0, 3
	call .placeUnfilledRightArrow
	sla c
	ld a,1 ; On
	jr nc,.storeBattleAnimationCursorX
	ld a,10 ; Off
.storeBattleAnimationCursorX
	ld [wTrainerEngageDistance],a ; battle animation cursor X coordinate
	hlCoord 0, 8
	call .placeUnfilledRightArrow
	sla c
	ld a,1
	jr nc,.storeBattleStyleCursorX
	ld a,10
.storeBattleStyleCursorX
	ld [wTrainerFacingDirection],a ; battle style cursor X coordinate
	hlCoord 0, 13
	call .placeUnfilledRightArrow
; cursor in front of Cancel
	hlCoord 0, 16
	ld a,1
.placeUnfilledRightArrow
	ld e,a
	ld d,0
	add hl,de
	ld [hl],$ec ; unfilled right arrow menu cursor
	ret

; table that indicates how the 3 text speed options affect frame delays
; Format:
; 00: X coordinate of menu cursor
; 01: delay after printing a letter (in frames)
TextSpeedOptionData: ; 6096 (1:6096)
	db 14,5 ; Slow
	db  7,3 ; Medium
	db  1,1 ; Fast
	db 7 ; default X coordinate (Medium)
	db $ff ; terminator

Func_609e: ; 609e (1:609e)
	ld a, $a
	ld [$0], a
	ld a, $1
	ld [$6000], a
	ld [$4000], a
	ld b, $b
	ld hl, $a598
.asm_60b0
	ld a, [hli]
	cp $50
	jr z, .asm_60c1
	dec b
	jr nz, .asm_60b0
	xor a
	ld [$0], a
	ld [$6000], a
	and a
	ret
.asm_60c1
	xor a
	ld [$0], a
	ld [$6000], a
	scf
	ret


IF HACK_NEW_DEBUG_MENU == 1
HackNewDebugMenu:
	;ld a,(SFX_02_40 - SFX_Headers_02) / 3
	;call PlaySound ; play sound
	
	ld a,1
	ld hl,wHackDebugMenuItems
	ld [hli],a
	ld [hli],a
	ld [hli],a
	
	ld a,[W_CURMAP]
	ld [wHackDebugMenuWhichMap],a
	
	
	;init menu, or re-init after using an option
.menuInit:
	call WaitForSoundToFinish
	xor a
	ld [wCurrentMenuItem],a
	ld [wLastMenuItem],a
	
	inc a
	ld [wTopMenuItemX],a
	ld [wTopMenuItemY],a
	ld [wMenuWrappingEnabled],a
	
	ld a,$FF
	ld [wMenuWatchedKeys],a ;handle all buttons
	
	ld a, 5 ;# options - 1
	ld [wMaxMenuItem],a
	
	call ClearScreen
	
	;menu main loop while open
.menuMainLoop:
	call .redraw
	call UpdateSprites
	call HandleMenuInput
	push af
	call WaitForSoundToFinish
	pop af
	
	bit 0,a ;A button pressed?
	jr nz, .activate
	
	bit 1,a ;B pressed?
	jp nz, CloseStartMenu
	
	bit 4,a ;Right pressed?
	jr nz, .increment
	
	bit 5,a ;Left pressed?
	jr nz, .decrement
	
	jr .menuMainLoop
	
	;activate the selected option
.activate:
	ld a,[wCurrentMenuItem]
	sla a
	ld c,a
	ld b,0
	ld hl,.menuOptionPtrs
	add hl,bc
	ld a,[hli]
	ld h,[hl]
	ld l,a
	jp [hl]
	

	;increment selected option
.increment:
	ld e,1
	jr .incdec

	;decrement selected option
.decrement:
	ld e,$FF

.incdec:
	ld a,[wCurrentMenuItem]
	ld c,a
	ld b,0
	ld hl,wHackDebugMenuItems
	add hl,bc
	ld a,[hl]
	add e
	ld [hl],a
	jr .menuMainLoop

	;redraw the menu
.redraw:
	;draw border
	hlCoord 0, 0
	ld bc, $1012 ; 20 x 18
	call TextBoxBorder
	
	;draw menu text
	hlCoord 2, 1
	ld de, .menuText
	call PlaceString
	
	;draw IDs for items that have them.
	ld c, 3
	hlCoord 13, 1
	ld de, wHackDebugMenuItems
.redrawNumLoop:
	push bc
	push de
	ld bc, $8103 ;one byte, 3 digits, with leading zeros
	call PrintNumber
	
	ld bc,(SCREEN_WIDTH * 2) - 3
	add hl,bc
	pop de
	inc de
	pop bc
	dec c
	jr nz, .redrawNumLoop
	
.drawItemName:
	;draw item name
	ld a,[wHackDebugMenuWhichItem]
	and a
	jr z, .invalidItem ;don't attempt to print the names of invalid items
	cp MAX_ELIXER+1
	jr c,.validItem
	cp HM_01
	jr nc,.validItem
	
.invalidItem:
	ld a,$2C ;"?????"
	
.validItem:
	ld [wd11e],a
	call GetItemName
	hlCoord 3, 4
	ld de, wcd6d
	call PlaceString
	
.drawMonName:
	;draw mon name
	ld a,[wHackDebugMenuWhichMon]
	and a
	jr z, .invalidMon ;don't attempt to print the names of invalid mons
	cp VICTREEBEL+1
	jr c,.validMon
	
.invalidMon:
	ld de,.questionText
	jr .printMon
	
.validMon:
	ld [wd11e],a
	call GetMonName
	ld de, wcd6d
	
.printMon:
	hlCoord 3, 6
	call PlaceString
	ret
	
	
	;"Go to map" function
.funcGotoMap:
	ld a,$FF
	ld hl,W_TOWNVISITEDFLAG
	ld [hli],a ;unlock all fly destinations
	ld [hli],a
	call ChooseFlyDestination
	jp CloseStartMenu
	
	;selecting a map by ID is clunky and buggy
	ld hl,wd732
	set 2,[hl] ;we used fly (whatever difference it is)
	set 3,[hl] ;trigger a warp
	res 4,[hl] ;destination isn't wDungeonWarpDestinationMap
	res 6,[hl] ;destination isn't wLastBlackoutMap
	
	inc hl
	set 7,[hl] ;used Fly (correct entrance animation)
	
	ld hl,wd736
	set 0,[hl] ;step down from door
	set 2,[hl] ;standing on warp
	
	;I don't know how much of this is necessary or what it all does.
	;This is still buggy; warping to indoor maps corrupts them.
	ld hl,wd72e
	res 4,[hl] ;unsure what this is for.
	
	ld a,$26
	ld [wd730],a
	
	;kill the map script so it doesn't try to run from unloaded map
	ld de,EmptyFunc2
	ld hl,W_MAPSCRIPTPTR
	ld a,e
	ld [hli],a
	ld [hl],d
	
	ld hl,wd790
	res 7,[hl] ; unset Safari Zone bit
	xor a
	ld [W_NUMSAFARIBALLS],a
	ld [W_SAFARIZONEENTRANCECURSCRIPT],a
	inc a
	ld [wEscapedFromBattle],a
	ld [wcd6a],a ; item used
	
	ld a,[W_CURMAP]
	ld [wLastMap],a
	
	ld a,[wHackDebugMenuWhichMap]
	ld [wDestinationMap],a
	ld [W_CURMAP],a
	ld a,1
	ld [wDestinationWarpID],a
	jp CloseStartMenu
	
	
	;"Give Item" function
.funcGiveItem:
	ld a,99
	ld [wcf97],a ;max quantity
	ld a,ITEMLISTMENU
	ld [wListMenuID],a
	call DisplayChooseQuantityMenu
	
	;give the item
	cp $FF
	jp z, .menuMainLoop ;cancelled
	ld a,[wcf96] ;selected quantity
	ld c,a
	ld a,[wHackDebugMenuWhichItem]
	ld b,a
	call GiveItem
	jr nc, .giveItemFail
	
	;play "deposit item" sound.
	ld a,(SFX_02_55 - SFX_Headers_02) / 3
	call PlaySound
	jp .menuInit
	
.giveItemFail:
	ld a,(SFX_02_46 - SFX_Headers_02) / 3
	call PlaySound
	jp .menuInit
	
	
	;"Give Mon" function
.funcGiveMon:
	ld a,100
	ld [wcf97],a ;max quantity (level)
	ld a,ITEMLISTMENU
	ld [wListMenuID],a
	call DisplayChooseQuantityMenu
	
	;give the mon
	cp $FF
	jp z, .menuMainLoop ;cancelled
	
	ld a,[hJoyHeld]
	bit 2,a ;select held?
	jr nz,.fightMon
	
	ld a,[wcf96] ;selected quantity
	ld c,a
	ld a,[wHackDebugMenuWhichMon]
	ld b,a
	call GivePokemon ;does sound effect, text, nickname etc
	jp .menuInit


.fightMon:
	ld a,[wcf96] ;selected quantity
	ld [W_CURENEMYLVL], a
	ld a,[wHackDebugMenuWhichMon]
	ld [W_CUROPPONENT], a
	jp CloseStartMenu
	

.funcHealParty:
	predef HealParty
	ld a,(SFX_02_3e - SFX_Headers_02) / 3 ; status ailment curing sound
	call PlaySound
	jp .menuInit
	
.funcGiveMoney:
	ld a,$99
	ld hl,wPlayerMoney
	ld [hli],a
	ld [hli],a
	ld [hli],a
	ld hl,wPlayerCoins
	ld [hli],a
	ld [hli],a
	
	ld a,(SFX_02_5a - SFX_Headers_02) / 3
	call PlaySound
	jp .menuInit
	

	;"Open PC" function
.funcOpenPC:
	call FuncTX_PokemonCenterPC
	jp CloseStartMenu
	;I don't know why the menu doesn't work after opening the PC.
	;it seems to have to do with wFlags_0xcd60.
	;if I save that and restore it after calling the PC,
	;the game will actually crash, which makes no goddamn sense.
	;even with this, the start menu doesn't actually close.
	
	
	;Function pointers for each item
.menuOptionPtrs:
	dw .funcGotoMap
	dw .funcGiveItem
	dw .funcGiveMon
	dw .funcHealParty
	dw .funcGiveMoney
	dw .funcOpenPC

	
	;Item text
.menuText:
	db   "Go to map:"
	next "Give Item:"
	next "Give Mon:"
	next "Heal Party"
	next "Give Money"
	next "Open PC@"
	
.questionText:
	db "?????@"
	
	
;other interesting functions/thoughts:
;give/edit badges (W_OBTAINEDBADGES)
;a sound test submenu would be great
	
ENDC