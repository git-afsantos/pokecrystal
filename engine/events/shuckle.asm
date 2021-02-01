MANIA_OT_ID EQU 00518

GiveShuckle:
    ld a, FALKNER
    ld [wScriptVar], a
    callfar ReadPlayerParty
    ret

TempGiveShuckle:
    ld hl, wPartyCount  ; hl = wPartyCount (address)
	xor a               ; a = 0
	ld [hli], a         ; *hl = 0; hl++ (hl = wPartySpecies)
	dec a               ; a = -1
	ld [hl], a          ; *hl = -1 (end of list)

	ld hl, wPartyMons
	ld bc, wPartyMonsEnd - wPartyMons
	xor a
	call ByteFill ; fills bc bytes (all party structs) with a (0)

	;ld a, [wScriptVar] ; Trainer Class constant
	ld a, FALKNER

	dec a ; zero-based index
	ld c, a
	ld b, 0
	ld hl, MyTrainerGroups ; go to table of addresses
	add hl, bc
	add hl, bc  ; add twice to skip words, not bytes
	ld a, [hli] ; save the low byte of the address
	ld h, [hl]  ; high part of the address remains
	ld l, a     ; set the low part of the address to the concrete trainer

.skip_name
	ld a, [hli]
	cp "@"
	jr nz, .skip_name

	ld a, [hli] ; Trainer Type (moves, items, moves+items)
	ld c, a
	ld b, 0
	ld d, h
	ld e, l
	;ld hl, MyTrainerTypes
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, .done
	push bc
	jp hl

.done
	jp DummyRewardd

DummyRewardd:
	ret

MyTrainerGroups:
; entries correspond to trainer classes (see constants/trainer_constants.asm)
	dw MyFalknerGroup


MyFalknerGroup:
	; FALKNER (1)
	db "FALKNER@", TRAINERTYPE_MOVES
	db  7, PIDGEY,     TACKLE, MUD_SLAP, NO_MOVE, NO_MOVE
	db  9, PIDGEOTTO,  TACKLE, MUD_SLAP, GUST, NO_MOVE
	db -1 ; end


OldGiveShuckle:
; Adding to the party.
	xor a ; PARTYMON
	ld [wMonType], a

; Get team data
	ld hl, GymLeaderTeams
	ld a, [wScriptVar]
	;dec a ; zero-based index
	;ld bc, 6
	;push af
	;push bc
	;call AddNTimes
	;pop bc
	;pop af
	ld a, [hl]
	ld [wCurSpecies], a ; species
	inc hl
	ld a, [hl]
	ld [wCurItem], a ; item
	inc hl
	ld a, HIGH(hl)
	ld [hMGChecksum], a ; address to moveset
	ld a, LOW(hl)
	ld [hMGChecksum + 1], a

; Level 50 pokemon.
	ld a, [wCurSpecies]
	ld [wCurPartySpecies], a
	ld a, 50
	ld [wCurPartyLevel], a

	predef TryAddMonToParty
	jr nc, .NotGiven

; Caught data.
	ld b, CAUGHT_BY_UNKNOWN
	farcall SetGiftPartyMonCaughtData

; Holding an item.
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [wPartyCount]
	dec a
	push af
	push bc
	ld hl, wPartyMon1Item
	call AddNTimes
	ld a, [wCurItem]
	ld [hl], a
	pop bc
	pop af

; OT ID.
	;ld hl, wPartyMon1ID
	;call AddNTimes
	;ld a, HIGH(MANIA_OT_ID)
	;ld [hli], a
	;ld [hl], LOW(MANIA_OT_ID)

; Nickname.
	;ld a, [wPartyCount]
	;dec a
	;ld hl, wPartyMonNicknames
	;call SkipNames
	;ld de, SpecialShuckleNick
	;call CopyName2

; OT.
	;ld a, [wPartyCount]
	;dec a
	;ld hl, wPartyMonOT
	;call SkipNames
	;ld de, SpecialShuckleOT
	;call CopyName2

; Engine flag for this event.
	;ld hl, wDailyFlags1
	;set DAILYFLAGS1_GOT_SHUCKIE_TODAY_F, [hl]
	ld a, 1
	ld [wScriptVar], a
	ret

.NotGiven:
	xor a
	ld [wScriptVar], a
	ret

SpecialShuckleOT:
	db "MANIA@"

SpecialShuckleNick:
	db "SHUCKIE@"

ReturnShuckle:
	farcall SelectMonFromParty
	jr c, .refused

	ld a, [wCurPartySpecies]
	cp SHUCKLE
	jr nz, .DontReturn

	ld a, [wCurPartyMon]
	ld hl, wPartyMon1ID
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes

; OT ID
	ld a, [hli]
	cp HIGH(MANIA_OT_ID)
	jr nz, .DontReturn
	ld a, [hl]
	cp LOW(MANIA_OT_ID)
	jr nz, .DontReturn

; OT
	ld a, [wCurPartyMon]
	ld hl, wPartyMonOT
	call SkipNames
	ld de, SpecialShuckleOT
.CheckOT:
	ld a, [de]
	cp [hl]
	jr nz, .DontReturn
	cp "@"
	jr z, .done
	inc de
	inc hl
	jr .CheckOT

.done
	farcall CheckCurPartyMonFainted
	jr c, .fainted
	ld a, [wCurPartyMon]
	ld hl, wPartyMon1Happiness
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld a, [hl]
	cp 150
	ld a, SHUCKIE_HAPPY
	jr nc, .HappyToStayWithYou
	xor a ; REMOVE_PARTY
	ld [wPokemonWithdrawDepositParameter], a
	callfar RemoveMonFromPartyOrBox
	ld a, SHUCKIE_RETURNED
.HappyToStayWithYou:
	ld [wScriptVar], a
	ret

.refused
	ld a, SHUCKIE_REFUSED
	ld [wScriptVar], a
	ret

.DontReturn:
	xor a ; SHUCKIE_WRONG_MON
	ld [wScriptVar], a
	ret

.fainted
	ld a, SHUCKIE_FAINTED
	ld [wScriptVar], a
	ret
