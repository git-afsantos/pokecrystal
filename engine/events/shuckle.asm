MANIA_OT_ID EQU 00518

GiveShuckle:
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
	ld hl, MyTrainerTypes
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, .done
	push bc
	jp hl

.done
	jp DummyReward

DummyReward:
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

MyTrainerTypes:
; entries correspond to TRAINERTYPE_* constants
	dw MyTrainerType2 ; level, species
	dw MyTrainerType2 ; level, species, moves
	dw MyTrainerType2 ; level, species, item
	dw MyTrainerType2 ; level, species, item, moves

MyTrainerType2:
; moves
	ld h, d
	ld l, e
.loop
	ld a, [hli]
	cp $ff
	ret z

	ld [wCurPartyLevel], a
	ld a, [hli]
	ld [wCurPartySpecies], a
	ld a, PARTYMON
	ld [wMonType], a
	;ld a, TRAINER_BATTLE
	;ld [wBattleMode], a

; TryAddMonToParty requires
; [x] wPartyCount
; [x] wMonType (PARTYMON)
; [x] wCurPartySpecies
; [?] wPartyMonOT
; [?] wPlayerName
; [ ] wBattleMode
; [x] wCurPartyLevel
	push hl
	predef TryAddMonToParty
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	pop hl

	ld b, NUM_MOVES
.copy_moves
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copy_moves

	push hl

	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, MON_PP
	add hl, de
	push hl
	ld hl, MON_MOVES
	add hl, de
	pop de

	ld b, NUM_MOVES
.copy_pp
	ld a, [hli]
	and a
	jr z, .copied_pp

	push hl
	push bc
	dec a
	ld hl, Moves + MOVE_PP
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	pop bc
	pop hl

	ld [de], a
	inc de
	dec b
	jr nz, .copy_pp
.copied_pp

	pop hl
	jr .loop


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
