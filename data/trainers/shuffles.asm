; Pre-calculated shuffles, so that we trade space for time
; Numbers range from 0 to 8 (exclusive), so they fit in nibbles

TrainerShuffles:
; 4*8 = 32 bytes
    db $1,  $72, $53, $46
    db $17, $42, $3,  $65
    db $27, $46, $15, $30
    db $30, $24, $67, $15
    db $40, $56, $13, $27
    db $56, $47, $2,  $13
    db $63, $7,  $12, $54
    db $74, $60, $21, $53
