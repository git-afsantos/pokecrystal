	object_const_def
	const VIOLETGYM_FALKNER
	const VIOLETGYM_BUGSY
	const VIOLETGYM_YOUNGSTER1
	const VIOLETGYM_YOUNGSTER2
	const VIOLETGYM_GYM_GUIDE

VioletGym_MapScripts:
	def_scene_scripts

	def_callbacks

VioletGymDummyScript:
	faceplayer
	opentext
	checkroundended
	iftrue EndOfRound
	special TPTLoadNextMatch
	writetext DebugTPTText
	waitbutton
	closetext
	opentext
	checkplayermatch
	iffalse .NotPlayerMatch
	writetext DummyIntroText
	waitbutton
	closetext
	winlosstext DummyWinText, DummyLossText
	special TPTPlayerBattle
	reloadmapafterbattle
	special TPTUpdateBrackets
	end

.NotPlayerMatch:
	writetext DummyNotPlayerText
	waitbutton
	closetext
	special TPTSimulateMatch
	special TPTUpdateBrackets
	end

EndOfRound:
	writetext DummyEndRoundText
	waitbutton
	closetext
	end

VioletGymFalknerScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_FALKNER
	iftrue .FightDone
	writetext FalknerIntroText
	waitbutton
	closetext
	winlosstext FalknerWinLossText, 0
	loadtrainer FALKNER, FALKNER1
	startbattle
	reloadmapafterbattle
	setevent EVENT_BEAT_FALKNER
	opentext
	writetext ReceivedZephyrBadgeText
	playsound SFX_GET_BADGE
	waitsfx
	setflag ENGINE_ZEPHYRBADGE
	readvar VAR_BADGES
	scall VioletGymActivateRockets
.FightDone:
	checkevent EVENT_GOT_TM31_MUD_SLAP
	iftrue .SpeechAfterTM
	setevent EVENT_BEAT_BIRD_KEEPER_ROD
	setevent EVENT_BEAT_BIRD_KEEPER_ABE
	setmapscene ELMS_LAB, SCENE_ELMSLAB_NOTHING
	specialphonecall SPECIALCALL_ASSISTANT
	writetext FalknerZephyrBadgeText
	promptbutton
	verbosegiveitem TM_MUD_SLAP
	iffalse .NoRoomForMudSlap
	setevent EVENT_GOT_TM31_MUD_SLAP
	writetext FalknerTMMudSlapText
	waitbutton
	closetext
	end

.SpeechAfterTM:
	writetext FalknerFightDoneText
	waitbutton
.NoRoomForMudSlap:
	closetext
	end

VioletGymActivateRockets:
	ifequal 7, .RadioTowerRockets
	ifequal 6, .GoldenrodRockets
	end

.GoldenrodRockets:
	jumpstd GoldenrodRocketsScript

.RadioTowerRockets:
	jumpstd RadioTowerRocketsScript

TrainerBirdKeeperRod:
	trainer BIRD_KEEPER, ROD, EVENT_BEAT_BIRD_KEEPER_ROD, BirdKeeperRodSeenText, BirdKeeperRodBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BirdKeeperRodAfterBattleText
	waitbutton
	closetext
	end

TrainerBirdKeeperAbe:
	trainer BIRD_KEEPER, ABE, EVENT_BEAT_BIRD_KEEPER_ABE, BirdKeeperAbeSeenText, BirdKeeperAbeBeatenText, 0, .Script

.Script:
	endifjustbattled
	opentext
	writetext BirdKeeperAbeAfterBattleText
	waitbutton
	closetext
	end

VioletGymGuideScript:
    faceplayer
    opentext
    checktptstarted
    iffalse .InitializeTPT
    special TPTInitializeWinners2
    ;writetext DummyTPTCont
    writetext DebugTPTBrackets
    waitbutton
    closetext
    end

.InitializeTPT:
    special TPTInitializeWinners1
    ;writetext DummyTPTInit
    writetext DebugTPTBrackets
    waitbutton
    closetext
    end

OldVioletGymGuideScript:
	faceplayer
	opentext
	checkevent EVENT_BEAT_FALKNER
	iftrue .VioletGymGuideWinScript
	writetext VioletGymGuideText
	waitbutton
	closetext
	end

.VioletGymGuideWinScript:
	writetext VioletGymGuideWinText
	waitbutton
	closetext
	end

VioletGymStatue:
	checkflag ENGINE_ZEPHYRBADGE
	iftrue .Beaten
	jumpstd GymStatue1Script
.Beaten:
	gettrainername STRING_BUFFER_4, FALKNER, FALKNER1
	jumpstd GymStatue2Script

DummyIntroText:
	text "Let's do it!"
	done

DummyWinText:
	text "All right!"
	line "Let's do it again"
	cont "sometime."
	done

DummyLossText:
	text "I won! Better"
	line "luck next time."
	done

DebugTPTText:
    text "Next Match:"
    line "  @"
    text_decimal wTPTTrainer1, 1, 3
    text " vs @"
    text_decimal wTPTTrainer2, 1, 3
    text "!"
    done

DebugTPTBrackets:
    text "Match 1:"
    line "  @"
    text_decimal wTPTBrackets, 1, 3
    text " vs @"
    text_decimal wTPTBrackets+1, 1, 3
    text "!"

    para "Match 2:"
    line "  @"
    text_decimal wTPTBrackets+2, 1, 3
    text " vs @"
    text_decimal wTPTBrackets+3, 1, 3
    text "!"

    para "Match 3:"
    line "  @"
    text_decimal wTPTBrackets+4, 1, 3
    text " vs @"
    text_decimal wTPTBrackets+5, 1, 3
    text "!"

    para "Match 4:"
    line "  @"
    text_decimal wTPTBrackets+6, 1, 3
    text " vs @"
    text_decimal wTPTBrackets+7, 1, 3
    text "!"

    para "Match 5:"
    line "  @"
    text_decimal wTPTBrackets+8, 1, 3
    text " vs @"
    text_decimal wTPTBrackets+9, 1, 3
    text "!"

    para "Match 6:"
    line "  @"
    text_decimal wTPTBrackets+10, 1, 3
    text " vs @"
    text_decimal wTPTBrackets+11, 1, 3
    text "!"

    para "Match 7:"
    line "  @"
    text_decimal wTPTBrackets+12, 1, 3
    text " vs @"
    text_decimal wTPTBrackets+13, 1, 3
    text "!"

    para "Match 8:"
    line "  @"
    text_decimal wTPTBrackets+14, 1, 3
    text " vs @"
    text_decimal wTPTBrackets+15, 1, 3
    text "!"
    done

DummyNotPlayerText:
    text "Not your turn"
    line "now. Maybe next."
    done

DummyEndRoundText:
    text "This tournament"
    line "round has ended!"
    done

DummyTPTInit:
    text "The Tournament can"
    line "now begin!"
    done

DummyTPTCont:
    text "The Tournament can"
    line "now continue!"
    done

FalknerIntroText:
	text "I'm FALKNER, the"
	line "VIOLET #MON GYM"
	cont "leader!"

	para "People say you can"
	line "clip flying-type"

	para "#MON's wings"
	line "with a jolt of"
	cont "electricity…"

	para "I won't allow such"
	line "insults to bird"
	cont "#MON!"

	para "I'll show you the"
	line "real power of the"

	para "magnificent bird"
	line "#MON!"
	done

FalknerWinLossText:
	text "…Darn! My dad's"
	line "cherished bird"
	cont "#MON…"

	para "All right."
	line "Take this."

	para "It's the official"
	line "#MON LEAGUE"
	cont "ZEPHYRBADGE."
	done

ReceivedZephyrBadgeText:
	text "<PLAYER> received"
	line "ZEPHYRBADGE."
	done

FalknerZephyrBadgeText:
	text "ZEPHYRBADGE"
	line "raises the attack"
	cont "power of #MON."

	para "It also enables"
	line "#MON to use"

	para "FLASH, if they"
	line "have it, anytime."

	para "Here--take this"
	line "too."
	done

FalknerTMMudSlapText:
	text "By using a TM, a"
	line "#MON will"

	para "instantly learn a"
	line "new move."

	para "Think before you"
	line "act--a TM can be"
	cont "used only once."

	para "TM31 contains"
	line "MUD-SLAP."

	para "It reduces the"
	line "enemy's accuracy"

	para "while it causes"
	line "damage."

	para "In other words, it"
	line "is both defensive"
	cont "and offensive."
	done

FalknerFightDoneText:
	text "There are #MON"
	line "GYMS in cities and"
	cont "towns ahead."

	para "You should test"
	line "your skills at"
	cont "these GYMS."

	para "I'm going to train"
	line "harder to become"

	para "the greatest bird"
	line "master!"
	done

BirdKeeperRodSeenText:
	text "The keyword is"
	line "guts!"

	para "Those here are"
	line "training night and"

	para "day to become bird"
	line "#MON masters."

	para "Come on!"
	done

BirdKeeperRodBeatenText:
	text "Gaaah!"
	done

BirdKeeperRodAfterBattleText:
	text "FALKNER's skills"
	line "are for real!"

	para "Don't get cocky"
	line "just because you"
	cont "beat me!"
	done

BirdKeeperAbeSeenText:
	text "Let me see if you"
	line "are good enough to"
	cont "face FALKNER!"
	done

BirdKeeperAbeBeatenText:
	text "This can't be"
	line "true!"
	done

BirdKeeperAbeAfterBattleText:
	text "This is pathetic,"
	line "losing to some"
	cont "rookie trainer…"
	done

VioletGymGuideText:
	text "Hey! I'm no train-"
	line "er but I can give"
	cont "some advice!"

	para "Believe me!"
	line "If you believe, a"

	para "championship dream"
	line "can come true."

	para "You believe?"
	line "Then listen."

	para "The grass-type is"
	line "weak against the"

	para "flying-type. Keep"
	line "this in mind."
	done

VioletGymGuideWinText:
	text "Nice battle! Keep"
	line "it up, and you'll"

	para "be the CHAMP in no"
	line "time at all!"
	done

VioletGym_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 15, VIOLET_CITY, 2
	warp_event  5, 15, VIOLET_CITY, 2

	def_coord_events

	def_bg_events
	bg_event  3, 13, BGEVENT_READ, VioletGymStatue
	bg_event  6, 13, BGEVENT_READ, VioletGymStatue

	def_object_events
	object_event  5,  1, SPRITE_FALKNER, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, VioletGymFalknerScript, -1
	object_event  7,  15, SPRITE_BUGSY, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, VioletGymDummyScript, -1
	object_event  7,  6, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_LEFT, 2, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeperRod, -1
	object_event  2, 10, SPRITE_YOUNGSTER, SPRITEMOVEDATA_STANDING_RIGHT, 2, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_TRAINER, 3, TrainerBirdKeeperAbe, -1
	object_event  7, 13, SPRITE_GYM_GUIDE, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, VioletGymGuideScript, -1
