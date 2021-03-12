
TPT_WINNERS_MATCH_1 EQU $0
TPT_WINNERS_MATCH_2 EQU $2
TPT_WINNERS_MATCH_3 EQU $4
TPT_WINNERS_MATCH_4 EQU $6
TPT_WINNERS_MATCH_5 EQU $8
TPT_WINNERS_MATCH_6 EQU $a
TPT_WINNERS_MATCH_7 EQU $c
TPT_WINNERS_MATCH_8 EQU $e

TPT_WINNERS_MATCH_1_2 EQU $1
TPT_WINNERS_MATCH_2_2 EQU $3
TPT_WINNERS_MATCH_3_2 EQU $5
TPT_WINNERS_MATCH_4_2 EQU $7
TPT_WINNERS_MATCH_5_2 EQU $9
TPT_WINNERS_MATCH_6_2 EQU $b
TPT_WINNERS_MATCH_7_2 EQU $d
TPT_WINNERS_MATCH_8_2 EQU $f

TPT_LOSERS_MATCH_1 EQU $10
TPT_LOSERS_MATCH_2 EQU $12
TPT_LOSERS_MATCH_3 EQU $14
TPT_LOSERS_MATCH_4 EQU $16
TPT_LOSERS_MATCH_5 EQU $18
TPT_LOSERS_MATCH_6 EQU $1a
TPT_LOSERS_MATCH_7 EQU $1c
TPT_LOSERS_MATCH_8 EQU $1e

TPT_LOSERS_MATCH_1_2 EQU $11
TPT_LOSERS_MATCH_2_2 EQU $13
TPT_LOSERS_MATCH_3_2 EQU $15
TPT_LOSERS_MATCH_4_2 EQU $17
TPT_LOSERS_MATCH_5_2 EQU $19
TPT_LOSERS_MATCH_6_2 EQU $1b
TPT_LOSERS_MATCH_7_2 EQU $1d
TPT_LOSERS_MATCH_8_2 EQU $1f

TPT_ELIMINATED EQU $21

TPT_PLAYER_BATTLE_FLAG   EQU (1 << 7)
TPT_PLAYER_TRAINER1_FLAG EQU (1 << 6)
TPT_PLAYER_LOST_FLAG     EQU (1 << 5)

TPT_TOURNAMENT_BATTLE_FLAG  EQU 2
TPT_BATTLE_SCRIPT_FLAGS     EQU (1 << 7) | TPT_TOURNAMENT_BATTLE_FLAG | 1

TPT_TOURNAMENT_START_FLAG   EQU 1
TPT_ROUND_END_FLAG          EQU (1 << 6)
TPT_TOURNAMENT_END_FLAG     EQU (1 << 7)

