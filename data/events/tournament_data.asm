
; This table contains offsets, counting from wTPTBrackets
;   from which the scripts should read/write match data.
; Index 0 refers to the first match, 1 to the second, etc.
; Each match contains three bytes of data:
;   - offset from wTPTBrackets to read trainers
;   - offset from wTPTBrackets to write winner
;   - offset from wTPTBrackets to write loser

TPTWinnersRound1Matches:
    ; ***** WINNERS BRACKET *****
    ; *****     ROUND 1     *****
    ; Match 1 - Game 1
    db TPT_WINNERS_MATCH_1
    db TPT_WINNERS_MATCH_1
    db TPT_LOSERS_MATCH_1_2
    ; Match 2 - Game 2
    db TPT_WINNERS_MATCH_2
    db TPT_WINNERS_MATCH_2
    db TPT_LOSERS_MATCH_2_2
    ; Match 3 - Game 3
    db TPT_WINNERS_MATCH_3
    db TPT_WINNERS_MATCH_3
    db TPT_LOSERS_MATCH_3_2
    ; Match 4 - Game 4
    db TPT_WINNERS_MATCH_4
    db TPT_WINNERS_MATCH_4
    db TPT_LOSERS_MATCH_4_2
    ; Match 5 - Game 5
    db TPT_WINNERS_MATCH_5
    db TPT_WINNERS_MATCH_5
    db TPT_LOSERS_MATCH_5_2
    ; Match 6 - Game 6
    db TPT_WINNERS_MATCH_6
    db TPT_WINNERS_MATCH_6
    db TPT_LOSERS_MATCH_6_2
    ; Match 7 - Game 7
    db TPT_WINNERS_MATCH_7
    db TPT_WINNERS_MATCH_7
    db TPT_LOSERS_MATCH_7_2
    ; Match 8 - Game 8
    db TPT_WINNERS_MATCH_8
    db TPT_WINNERS_MATCH_8
    db TPT_LOSERS_MATCH_8_2
    db -1

TPTWinnersRound2Matches:
    ; ***** WINNERS BRACKET *****
    ; *****     ROUND 2     *****
    ; Match 1 - Game 9
    db TPT_WINNERS_MATCH_1
    db TPT_WINNERS_MATCH_1
    db TPT_LOSERS_MATCH_8
    ; Match 2 - Game 10
    db TPT_WINNERS_MATCH_2
    db TPT_WINNERS_MATCH_1_2
    db TPT_LOSERS_MATCH_7
    ; Match 3 - Game 11
    db TPT_WINNERS_MATCH_3
    db TPT_WINNERS_MATCH_2
    db TPT_LOSERS_MATCH_6
    ; Match 4 - Game 12
    db TPT_WINNERS_MATCH_4
    db TPT_WINNERS_MATCH_2_2
    db TPT_LOSERS_MATCH_5
    ; Match 5 - Game 13
    db TPT_WINNERS_MATCH_5
    db TPT_WINNERS_MATCH_3
    db TPT_LOSERS_MATCH_4
    ; Match 6 - Game 14
    db TPT_WINNERS_MATCH_6
    db TPT_WINNERS_MATCH_3_2
    db TPT_LOSERS_MATCH_3
    ; Match 7 - Game 15
    db TPT_WINNERS_MATCH_7
    db TPT_WINNERS_MATCH_4
    db TPT_LOSERS_MATCH_2
    ; Match 8 - Game 16
    db TPT_WINNERS_MATCH_8
    db TPT_WINNERS_MATCH_4_2
    db TPT_LOSERS_MATCH_1
    db -1

TPTLosersRound1Matches:
    ; *****  LOSERS BRACKET *****
    ; *****     ROUND 1     *****
    ; Match 1 - Game 17
    db TPT_LOSERS_MATCH_1
    db TPT_LOSERS_MATCH_1
    db TPT_ELIMINATED
    ; Match 2 - Game 18
    db TPT_LOSERS_MATCH_2
    db TPT_LOSERS_MATCH_1_2
    db TPT_ELIMINATED
    ; Match 3 - Game 19
    db TPT_LOSERS_MATCH_3
    db TPT_LOSERS_MATCH_2
    db TPT_ELIMINATED
    ; Match 4 - Game 20
    db TPT_LOSERS_MATCH_4
    db TPT_LOSERS_MATCH_2_2
    db TPT_ELIMINATED
    ; Match 5 - Game 21
    db TPT_LOSERS_MATCH_5
    db TPT_LOSERS_MATCH_3
    db TPT_ELIMINATED
    ; Match 6 - Game 22
    db TPT_LOSERS_MATCH_6
    db TPT_LOSERS_MATCH_3_2
    db TPT_ELIMINATED
    ; Match 7 - Game 23
    db TPT_LOSERS_MATCH_7
    db TPT_LOSERS_MATCH_4
    db TPT_ELIMINATED
    ; Match 8 - Game 24
    db TPT_LOSERS_MATCH_8
    db TPT_LOSERS_MATCH_4_2
    db TPT_ELIMINATED
    db -1

