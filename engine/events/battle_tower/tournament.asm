; Double elimination tournament logic
;   8 JOHTO_GYM_LEADER classes [1-8]
;   8 KANTO_GYM_LEADER classes [9-16]
;   8 ELITE_TRAINER classes [17-24]

INCLUDE "data/events/tournament_data.asm"

; special for a script
TPTLoadNextMatch:
    ;ld a, TPT_TOURNAMENT_START_FLAG
    ;ld [wTPTVar], a
    ;push bc
    ld c, 2         ; 2 bytes per match
    ld b, 0
    ld a, [wTPTNextMatch]
    ld l, a
    ld a, [wTPTNextMatch + 1]
    ld h, a
    ld a, [hl]      ; offset to skip from...
    ld hl, wTPTBrackets
    call AddNTimes  ; hl now points to the next match

    ld a, [wTPTPlayerData]
    and TRAINER_CLASS_BIT_MASK
    ld c, a

    ld a, [hli]
    ld [wTPTTrainer1], a    ; this byte is [1][2][5]
                            ; 1 bit leftover/flag
                            ; 2 bits trainer id [0,3]
                            ; 5 bits trainer class [1, 24]
    and TRAINER_CLASS_BIT_MASK
    cp c
    jp z, .player_is_first

    ld a, [hl]
    ld [wTPTTrainer2], a
    and TRAINER_CLASS_BIT_MASK
    cp c
    jp z, .player_is_second

    ; none of the participants is the player
    ld a, [wTPTPlayerData]
    and TRAINER_CLASS_BIT_MASK | TPT_PLAYER_LOST_FLAG  ; reset flags
    ld [wTPTPlayerData], a
    ;pop bc

    ld hl, wStringBuffer2
    ld a, [wTPTTrainer1]
    and TRAINER_CLASS_BIT_MASK
    cp FALKNER
    jr nz, .bugsy
    ld a, "1"
    ld [hl], a
    ld a, "@"
    inc hl
    ld [hl], a
    ret
.bugsy
    cp BUGSY
    jr nz, .whitney
    ld a, "2"
    ld [hl], a
    ld a, "@"
    inc hl
    ld [hl], a
    ret
.whitney
    cp WHITNEY
    jr nz, .morty
    ld a, "3"
    ld [hl], a
    ld a, "@"
    inc hl
    ld [hl], a
    ret
.morty
    cp MORTY
    jr nz, .chuck
    ld a, "4"
    ld [hl], a
    ld a, "@"
    inc hl
    ld [hl], a
    ret
.chuck
    cp CHUCK
    jr nz, .jasmine
    ld a, "5"
    ld [hl], a
    ld a, "@"
    inc hl
    ld [hl], a
    ret
.jasmine
    cp JASMINE
    jr nz, .pryce
    ld a, "6"
    ld [hl], a
    ld a, "@"
    inc hl
    ld [hl], a
    ret
.pryce
    cp PRYCE
    jr nz, .clair
    ld a, "7"
    ld [hl], a
    ld a, "@"
    inc hl
    ld [hl], a
    ret
.clair
    cp CLAIR
    jr nz, .smth
    ld a, "8"
    ld [hl], a
    ld a, "@"
    inc hl
    ld [hl], a
    ret
.smth
    ld a, "X"
    ld [hl], a
    ld a, "@"
    inc hl
    ld [hl], a
    ret

    ret

.player_is_first
    ld a, [hl]  ; fetch the opponent
    ld [wTPTTrainer2], a
    and TRAINER_CLASS_BIT_MASK  ; load the opponent's team
    ld [wOtherTrainerClass], a
    ld a, [hl]
    and TRAINER_TEAM_BIT_MASK
    ; shift right (sra) 5 times is 40 cycles
    ; swap (upper with lower) and shift right (sra) is 16 cycles
    ; rotate right (rrca) 5 times is 20 cycles
    ; rotate left (rlca) 3 times is 12 cycles
    rlca
    rlca
    rlca
    inc a   ; ids start at 1
    ld [wOtherTrainerID], a
    ld a, TPT_BATTLE_SCRIPT_FLAGS
    ld [wBattleScriptFlags], a
    farcall ReadTrainerParty

    ld a, [wTPTPlayerData]
; reset flags
    and TRAINER_CLASS_BIT_MASK | TPT_PLAYER_LOST_FLAG
    xor TPT_PLAYER_BATTLE_FLAG      ; player participates
    xor TPT_PLAYER_TRAINER1_FLAG    ; player is first
    ld [wTPTPlayerData], a
    ;pop bc
    ret

.player_is_second
    ld a, [wTPTTrainer1]    ; fetch the opponent
    and TRAINER_CLASS_BIT_MASK  ; load the opponent's team
    ld [wOtherTrainerClass], a
    ld a, [wTPTTrainer1]
    and TRAINER_TEAM_BIT_MASK
    rlca    ; rotate left 3 times is 12 cycles
    rlca
    rlca
    inc a   ; ids start at 1
    ld [wOtherTrainerID], a
    ld a, TPT_BATTLE_SCRIPT_FLAGS
    ld [wBattleScriptFlags], a
    farcall ReadTrainerParty

    ld a, [wTPTPlayerData]
; reset flags
    and TRAINER_CLASS_BIT_MASK | TPT_PLAYER_LOST_FLAG
    xor TPT_PLAYER_BATTLE_FLAG ; player participates
    ld [wTPTPlayerData], a
    ;pop bc
    ret

; TPT battle in which the player participates
TPTPlayerBattle:
    call BufferScreen
    predef StartBattle

    ld a, [wBattleResult]
    and $ff ^ BATTLERESULT_BITMASK
    ld [wScriptVar], a
    cp LOSE
    jr nz, .player_won
; else: player lost
    ld a, [wTPTPlayerData]
    xor TPT_PLAYER_LOST_FLAG
    ld [wTPTPlayerData], a      ; update loss flag
    and TPT_PLAYER_LOST_FLAG
    jr nz, .lost_first_time
; if zero, already lost twice; signal end of tournament
    ld a, [wTPTVar]
    or TPT_TOURNAMENT_END_FLAG
    ld [wTPTVar], a
    ret

.lost_first_time
    ld a, [wTPTPlayerData]
    and TPT_PLAYER_TRAINER1_FLAG
    jr z, .done     ; player lost and is second, both are in place
; else: swap trainers
    ld a, [wTPTTrainer1]
    ld b, a
    ld a, [wTPTTrainer2]
    ld [wTPTMatchWinner], a
    ld a, b
    ld [wTPTMatchLoser], a
    ret

.player_won
    ld a, [wTPTPlayerData]
    and TPT_PLAYER_TRAINER1_FLAG
    jr nz, .done    ; player won and is first, both are in place
; else: swap trainers
    ld a, [wTPTTrainer1]
    ld b, a
    ld a, [wTPTTrainer2]
    ld [wTPTMatchWinner], a
    ld a, b
    ld [wTPTMatchLoser], a
.done
    ret

; this is supposed to be called after a match
TPTUpdateBrackets:
    ld a, [wTPTNextMatch]
    ld l, a
    ld a, [wTPTNextMatch + 1]
    ld h, a
    ; hl is now pointing to the correct data entry
    inc hl      ; skip offset to current match

    ld a, [hli] ; get offset to store winner
    ld de, wTPTBrackets
.loop1
    and a
    jr z, .store_winner
    inc de
    dec a
    jr .loop1
.store_winner
    ld a, [wTPTMatchWinner]
    ld [de], a

    ld a, [hli] ; get offset to store loser
    ld de, wTPTBrackets
.loop2
    and a
    jr z, .store_loser
    inc de
    dec a
    jr .loop2
.store_loser
    ld a, [wTPTMatchLoser]
    ld [de], a

    ld a, [hl]  ; look ahead to next match
    cp -1
    jr nz, .has_next
    ld a, [wTPTVar]
    or TPT_ROUND_END_FLAG
    ld [wTPTVar], a
    ret
.has_next
    ld e, l
    ld d, h
    ld hl, wTPTNextMatch
    ld [hl], e
    inc hl
    ld [hl], d
	ret


TPTSimulateMatch:
    call Random
    and $1
    jr z, .trainer2_won
    ; leave trainers as they are
    ret

.trainer2_won
    ld a, [wTPTTrainer1]
    ld b, a
    ld a, [wTPTTrainer2]
    ld [wTPTMatchWinner], a
    ld a, b
    ld [wTPTMatchLoser], a
    ret


TPTInitializeWinners1:
; [Johto Gym Leaders] vs [Kanto Gym Leaders]
    ld de, wTPTWinnersBracket
    ld c, OFFSET_JOHTO_CLASSES
    call InitializeRegionTrainers
    ld de, wTPTWinnersBracket
    inc de
    ld c, OFFSET_KANTO_CLASSES
    call InitializeRegionTrainers
    ld de, TPTWinnersRound1Matches
    ld hl, wTPTNextMatch
    ld [hl], e
    inc hl
    ld [hl], d
    ld a, TPT_TOURNAMENT_START_FLAG
    ld [wTPTVar], a
    ret


TPTInitializeWinners2:
; [Winners of Round 1] vs [Elite Trainers]
    ld de, wTPTWinnersBracket
    inc de
    ld c, OFFSET_ELITE_CLASSES
    call InitializeRegionTrainers
    ld de, TPTWinnersRound2Matches
    ld hl, wTPTNextMatch
    ld [hl], e
    inc hl
    ld [hl], d
    ret


INCLUDE "data/trainers/shuffles.asm"

InitializeRegionTrainers:
; assumes that de is pointing to the first slot
; assumes that c equals the trainer class offset (J,K,E)
    push bc
    ld a, NUM_GYM_LEADERS
    call RandomRange
    ld b, $0
    ld c, a
    ; go to random shuffle
    ld hl, TrainerShuffles
    add hl, bc
    pop bc

    ; Trainer 1
    ld a, [hl]
    swap a
    and CLASS_OFFSET_BIT_MASK
    add a, c
    inc a       ; classes start at 1
    ;xor $00    ; use first team
    ld [de], a

    ; Trainer 2
    inc de      ; skip trainer from another class
    inc de      ; skip to next match
    ld a, [hli]
    and CLASS_OFFSET_BIT_MASK
    add a, c
    inc a       ; classes start at 1
    xor TRAINER_SET_TEAM2 ; use second team
    ld [de], a

    ; Trainer 3
    inc de
    inc de
    ld a, [hl]
    swap a
    and CLASS_OFFSET_BIT_MASK
    add a, c
    inc a       ; classes start at 1
    xor TRAINER_SET_TEAM3 ; use third team
    ld [de], a

    ; Trainer 4
    inc de
    inc de
    ld a, [hli]
    and CLASS_OFFSET_BIT_MASK
    add a, c
    inc a       ; classes start at 1
    xor TRAINER_SET_TEAM4 ; use fourth team
    ld [de], a

    ; Trainer 5
    inc de
    inc de
    ld a, [hl]
    swap a
    and CLASS_OFFSET_BIT_MASK
    add a, c
    inc a       ; classes start at 1
    ;xor $00    ; use first team
    ld [de], a

    ; Trainer 6
    inc de
    inc de
    ld a, [hli]
    and CLASS_OFFSET_BIT_MASK
    add a, c
    inc a       ; classes start at 1
    xor TRAINER_SET_TEAM2 ; use second team
    ld [de], a

    ; Trainer 7
    inc de
    inc de
    ld a, [hl]
    swap a
    and CLASS_OFFSET_BIT_MASK
    add a, c
    inc a       ; classes start at 1
    xor TRAINER_SET_TEAM3 ; use third team
    ld [de], a

    ; Trainer 8
    inc de
    inc de
    ld a, [hli]
    and CLASS_OFFSET_BIT_MASK
    add a, c
    inc a       ; classes start at 1
    xor TRAINER_SET_TEAM4 ; use fourth team
    ld [de], a

    ret
