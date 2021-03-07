; Double elimination tournament logic

; 8 JOHTO_GYM_LEADER classes [0-7]
; 8 KANTO_GYM_LEADER classes [8-15]
; 8 ELITE_TRAINER classes [16-23]

; 1 byte with flags
;   7 - 
;   6 - 
;   5 - 
;   4 - 1 if player is ELITE_TRAINER
;   3 - 1 if player is JOHTO_GYM_LEADER
;   2 - 
;   1 - 
;   0 - 


; special for script
;InitializeTournament:
;    call InitializeWinners1
;    ld a, [wTPTPlayerClass]
    ;cp OFFSET_ELITE_CLASSES
    ;jr c, .is_gym_leader
;    call PlayWinners1
;    ret


INCLUDE "data/events/tournament.asm"


; special for a script
; wScriptVar should contain an offset in bytes, counting from wTPTBrackets
;   and pointing to the current match (first trainer)
TPTLoadNextMatch:
    push bc
    ld c, 2             ; 2 bytes per match
    ld b, 0
    ld a, [wScriptVar]  ; offset to skip
    ld hl, wTPTBrackets ; from the start
    call AddNTimes      ; hl now points to the next match

    ld a, [wTPTPlayerClass]
    ld c, a

    ld a, [hli]
    ld [wTPTTrainer1], a    ; this byte is [1][2][5]
                            ; 1 bit leftover/flag
                            ; 2 bits trainer id [0,3]
                            ; 5 bits trainer class [0, 23]
    and TRAINER_CLASS_BIT_MASK
    cp c
    jr z, .player_is_first

    ld a, [hl]
    ld [wTPTTrainer2], a
    and TRAINER_CLASS_BIT_MASK
    cp c
    jr z, .player_is_second

    ld a, 0
    ld [wScriptVar], a  ; none of the participants is the player
    pop bc
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
    farcall ReadTrainerParty

    ld a, 1
    ld [wScriptVar], a  ; player participates
    pop bc
    ret

.player_is_second
    ld a, [wTPTTrainer1]    ; fetch the opponent
    and TRAINER_CLASS_BIT_MASK  ; load the opponent's team
    ld [wOtherTrainerClass], a
    ld a, [hl]
    and TRAINER_TEAM_BIT_MASK
    rlca    ; rotate left 3 times is 12 cycles
    rlca
    rlca
    inc a   ; ids start at 1
    ld [wOtherTrainerID], a
    farcall ReadTrainerParty

    ld a, 1
    ld [wScriptVar], a  ; player participates
    pop bc
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
    ret


TPTInitializeWinners2:
; [Winners of Round 1] vs [Elite Trainers]
    ld de, wTPTWinnersBracket
    inc de
    ld c, OFFSET_ELITE_CLASSES
    call InitializeRegionTrainers
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
