scriptname sslSystemLibrary extends Quest

Actor property PlayerRef auto

; Libraries
sslAnimationLibrary property AnimLib auto
sslVoiceLibrary property VoiceLib auto
sslThreadLibrary property ThreadLib auto
sslActorLibrary property ActorLib auto
sslControlLibrary property ControlLib auto
sslExpressionLibrary property ExpressionLib auto

; Object Registeries
sslAnimationSlots property Animations auto
sslCreatureAnimationSlots property CreatureAnimations auto
sslVoiceSlots property Voices auto
sslThreadSlots property Threads auto
sslActorSlots property Actors auto
sslExpressionSlots property Expressions auto

; Misc
sslActorStats property ActorStats auto

function _Setup()
	PlayerRef = Game.GetPlayer()

	; Fetch quests and cast to appropiate quests to ensure properties aren't stuck as none or wrong value
	Quest AnimationQuest = Quest.GetQuest("SexLabQuestAnimationSlots")
	if AnimationQuest != none
		AnimLib = AnimationQuest as sslAnimationLibrary
		Animations = AnimationQuest as sslAnimationSlots
	endIf
	Quest CreatureQuest = Quest.GetQuest("SexLabQuestCreatureAnimationSlots")
	if CreatureQuest != none
		CreatureAnimations = CreatureQuest as sslCreatureAnimationSlots
	endIf
	Quest VoiceQuest = Quest.GetQuest("SexLabQuestVoiceSlots")
	if VoiceQuest != none
		VoiceLib = VoiceQuest as sslVoiceLibrary
		Voices = VoiceQuest as sslVoiceSlots
	endIf
	Quest ThreadQuest = Quest.GetQuest("SexLabQuestThreadSlots")
	if ThreadQuest != none
		ThreadLib = ThreadQuest as sslThreadLibrary
		Threads = ThreadQuest as sslThreadSlots
	endIf
	Quest ActorQuest = Quest.GetQuest("SexLabQuestActorSlots")
	if ActorQuest != none
		ActorLib = ActorQuest as sslActorLibrary
		Actors = ActorQuest as sslActorSlots
		ActorStats = ActorQuest as sslActorStats
	endIf
	Quest ExpressionQuest = Quest.GetQuest("SexLabQuestExpressionSlots")
	if ExpressionQuest != none
		ExpressionLib = ExpressionQuest as sslExpressionLibrary
		Expressions = ExpressionQuest as sslExpressionSlots
	endIf
	Quest ControlQuest = Quest.GetQuest("SexLabQuestControl")
	if ControlQuest != none
		ControlLib = ControlQuest as sslControlLibrary
	endIf
	Debug.Trace("SexLab --- "+self+" --- "+PlayerRef+" --- \nsslSystemLibrary _Setup() Quests --- \nAnimationQuest: "+AnimationQuest+" --- CreatureQuest: "+CreatureQuest+" --- VoiceQuest: "+VoiceQuest+" --- ThreadQuest: "+ThreadQuest+" --- ActorQuest: "+ActorQuest+" --- ExpressionQuest: "+ExpressionQuest+" --- ControlQuest: "+ControlQuest)
	Debug.Trace("SexLab --- "+self+" --- "+PlayerRef+" --- \nsslSystemLibrary _Setup() Libraries --- \nAnimLib: "+AnimLib+" --- VoiceLib: "+VoiceLib+" --- ThreadLib: "+ThreadLib+" --- ActorLib: "+ActorLib+" --- ControlLib: "+ControlLib+" --- ExpressionLib: "+ExpressionLib+" --- Animations: "+Animations+" --- CreatureAnimations: "+CreatureAnimations+" --- Voices: "+Voices+" --- Threads: "+Threads+" --- Actors: "+Actors+" --- Expressions: "+Expressions+" --- ActorStats: "+ActorStats)
endFunction

function _ExportFloat(string name, float value)
	StorageUtil.FileSetFloatValue("SexLabConfig."+name, value)
endFunction
function _ExportInt(string name, int value)
	StorageUtil.FileSetIntValue("SexLabConfig."+name, value)
endFunction
function _ExportBool(string name, bool value)
	StorageUtil.FileSetIntValue("SexLabConfig."+name, value as int)
endFunction
function _ExportString(string name, string value)
	StorageUtil.FileSetStringValue("SexLabConfig."+name, value)
endFunction

float function _ImportFloat(string name, float value)
	if StorageUtil.FileHasFloatValue("SexLabConfig."+name)
		value = StorageUtil.FileGetFloatValue("SexLabConfig."+name, value)
		StorageUtil.FileUnsetFloatValue("SexLabConfig."+name)
	endIf
	return value
endFunction
int function _ImportInt(string name, int value)
	if StorageUtil.FileHasIntValue("SexLabConfig."+name)
		value = StorageUtil.FileGetIntValue("SexLabConfig."+name, value)
		StorageUtil.FileUnsetIntValue("SexLabConfig."+name)
	endIf
	return value
endFunction
bool function _ImportBool(string name, bool value)
	if StorageUtil.FileHasIntValue("SexLabConfig."+name)
		value = StorageUtil.FileGetIntValue("SexLabConfig."+name, value as int) as bool
		StorageUtil.FileUnsetIntValue("SexLabConfig."+name)
	endIf
	return value
endFunction
string function _ImportString(string name, string value)
	if StorageUtil.FileHasStringValue("SexLabConfig."+name)
		value = StorageUtil.FileGetStringValue("SexLabConfig."+name, value)
		StorageUtil.FileUnsetStringValue("SexLabConfig."+name)
	endIf
	return value
endFunction

function _ExportFloatList(string name, float[] values, int len)
	StorageUtil.FileFloatListClear("SexLabConfig."+name)
	int i
	while i < len
		StorageUtil.FileFloatListAdd("SexLabConfig."+name, values[i])
		i += 1
	endWhile
endFunction
function _ExportBoolList(string name, bool[] values, int len)
	StorageUtil.FileIntListClear("SexLabConfig."+name)
	int i
	while i < len
		StorageUtil.FileIntListAdd("SexLabConfig."+name, values[i] as int)
		i += 1
	endWhile
endFunction

float[] function _ImportFloatList(string name, float[] values, int len)
	if StorageUtil.FileFloatListCount("SexLabConfig."+name) == len
		int i
		while i < len
			values[i] = StorageUtil.FileFloatListGet("SexLabConfig."+name, i)
			i += 1
		endWhile
	endIf
	StorageUtil.FileFloatListClear("SexLabConfig."+name)
	return values
endFunction
bool[] function _ImportBoolList(string name, bool[] values, int len)
	if StorageUtil.FileIntListCount("SexLabConfig."+name) == len
		int i
		while i < len
			values[i] = StorageUtil.FileIntListGet("SexLabConfig."+name, i) as bool
			i += 1
		endWhile
	endIf
	StorageUtil.FileIntListClear("SexLabConfig."+name)
	return values
endFunction
