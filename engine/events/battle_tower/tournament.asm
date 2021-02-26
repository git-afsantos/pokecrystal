; Double elimination tournament logic

; const NUM_TRAINER_CLASSES


; 8 JOHTO_GYM_LEADER classes [0-7]
; 8 KANTO_GYM_LEADER classes [8-15]
; 8 ELITE_TRAINER classes [16-23]

; 1 byte with flags
;   8 - 
;   7 - 
;   6 - 
;   5 - 1 if player is ELITE_TRAINER
;   4 - 1 if player is JOHTO_GYM_LEADER
;   3 - 
;   2 - 
;   1 - 

; Round 1
; Only Johto vs Kanto Gym leaders
;   select opponent randomly: RANDOM(0, 8)
;   offset = 8 & flags
;   add offset to random number
;   (opponent is KANTO if player is JOHTO and vice-versa)

; Round 2
; Winner of Round 1 vs Elite trainer

TournamentLogic:
    ld a, [wTPTFlags]
    and $10  ; check if player is an Elite Trainer
    jp nz, Round2WinnersElite
    ; player is a Gym Leader
.Round1WinnersGymLeader
    ld a, $8
    call RandomRange
    ld c, a ; store random number in [0, 7]
    ld a, [wTPTFlags]
    and $8 ; is the player a Johto Gym Leader?
    add a, c ; [0, 7] if Kanto, [8, 15] if Johto
    ld [wOtherTrainerClass], a
    ld a, $4 ; select one of four possible teams
    call RandomRange
    ld [wOtherTrainerID], a
    call ReadTrainerParty
    ; TODO start battle
    ; TODO store results
    ; TODO update the remainder of the matches
.Round2WinnersGymLeader
    ld a, $8
    call RandomRange
    ld c, $10 ; start at 16, opponent is Elite Trainer
    add a, c
    ld [wOtherTrainerClass], a
    ld a, $4 ; select one of four possible teams
    call RandomRange
    ld [wOtherTrainerID], a
    call ReadTrainerParty
    ; TODO start battle
    ; TODO store results
    ; TODO update the remainder of the matches
    jr Round3Winners

Round2WinnersElite:
    ; TODO update results of Round 1 matches
    ld a, $10 ; choose one of 16 Gym Leaders
    call RandomRange
    ld [wOtherTrainerClass], a
    ld a, $4 ; select one of four possible teams
    call RandomRange
    ld [wOtherTrainerID], a
    call ReadTrainerParty
    ; TODO start battle
    ; TODO store results
    ; TODO update the remainder of the matches

Round3Winners:
    ; TODO







; special for script
InitializeTournament:
    call InitializeWinners1
    ld a, [wTPTPlayerClass]
    ;cp OFFSET_ELITE_CLASSES
    ;jr c, .is_gym_leader
    call PlayWinners1
    ret


; this is going to be a script
PlayWinners1:
    ld hl, wTPTWinnersBracket
    call LoadWinnersMatch
    call LoadWinnersMatch
    call LoadWinnersMatch
    ; ...
    ret


; special for a script
LoadNextMatch:
    push bc
    ld a, [wTPTPlayerClass]
    ld c, a
    
    ld hl, wTPTNextMatch
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

    ; none of the participants is the player
    pop bc
    ; TODO set some flag that scripts can use to check if player plays
    ret

.player_is_first
    inc hl      ; fetch the opponent
    ld a, [hl]
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
    ld [wOtherTrainerID], a
    farcall ReadTrainerParty

    pop bc
    ; TODO set some flag that scripts can use to check if player plays
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
    ld [wOtherTrainerID], a
    farcall ReadTrainerParty

    pop bc
    ; TODO set some flag that scripts can use to check if player plays
    ret



InitializeWinners1:
; [Johto Gym Leaders] vs [Kanto Gym Leaders]
    ld de, wTPTWinnersBracket
    ld c, OFFSET_JOHTO_CLASSES
    call InitializeRegionTrainers
    ld de, wTPTWinnersBracket
    inc de
    ld c, OFFSET_KANTO_CLASSES
    call InitializeRegionTrainers
    ret

InitializeWinners2:
; [Winners of Round 1] vs [Elite Trainers]
    ld de, wTPTWinnersBracket
    inc de
    ld c, OFFSET_ELITE_CLASSES
    call InitializeRegionTrainers
    ret


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
    ;xor $00    ; use first team
    ld [de], a

    ; Trainer 2
    inc de      ; skip trainer from another class
    inc de      ; skip to next match
    ld a, [hli]
    and CLASS_OFFSET_BIT_MASK
    add a, c
    xor TRAINER_SET_TEAM2 ; use second team
    ld [de], a

    ; Trainer 3
    inc de
    inc de
    ld a, [hl]
    swap a
    and CLASS_OFFSET_BIT_MASK
    add a, c
    xor TRAINER_SET_TEAM3 ; use third team
    ld [de], a

    ; Trainer 4
    inc de
    inc de
    ld a, [hli]
    and CLASS_OFFSET_BIT_MASK
    add a, c
    xor TRAINER_SET_TEAM4 ; use fourth team
    ld [de], a

    ; Trainer 5
    inc de
    inc de
    ld a, [hl]
    swap a
    and CLASS_OFFSET_BIT_MASK
    add a, c
    ;xor $00    ; use first team
    ld [de], a

    ; Trainer 6
    inc de
    inc de
    ld a, [hli]
    and CLASS_OFFSET_BIT_MASK
    add a, c
    xor TRAINER_SET_TEAM2 ; use second team
    ld [de], a

    ; Trainer 7
    inc de
    inc de
    ld a, [hl]
    swap a
    and CLASS_OFFSET_BIT_MASK
    add a, c
    xor TRAINER_SET_TEAM3 ; use third team
    ld [de], a

    ; Trainer 8
    inc de
    inc de
    ld a, [hli]
    and CLASS_OFFSET_BIT_MASK
    add a, c
    xor TRAINER_SET_TEAM4 ; use fourth team
    ld [de], a

    ret

