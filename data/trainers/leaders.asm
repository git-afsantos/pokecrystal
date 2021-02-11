; These lists determine the battle music and victory music, and whether to
; award HAPPINESS_GYMBATTLE for winning.

; Note: CHAMPION and RED are unused for battle music checks, since they are
; accounted for prior to the list check.

GymLeaders:
	db FALKNER
	db BUGSY
	db WHITNEY
	db MORTY
	db CHUCK
	db JASMINE
	db PRYCE
	db CLAIR
	db WILL
	db KOGA
	db BRUNO
	db KAREN
	db CHAMPION
	db RED
; fallthrough
KantoGymLeaders:
	db BROCK
	db MISTY
	db LT_SURGE
	db ERIKA
	db JANINE
	db SABRINA
	db BLAINE
	db BLUE
	db -1
