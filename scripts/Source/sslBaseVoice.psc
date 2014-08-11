scriptname sslBaseVoice extends sslBaseObject

Sound property Mild auto hidden
Sound property Medium auto hidden
Sound property Hot auto hidden

int property Gender auto hidden
bool property Male hidden
	bool function get()
		return (Gender == 0 || Gender == -1)
	endFunction
endProperty
bool property Female hidden
	bool function get()
		return (Gender == 1 || Gender == -1)
	endFunction
endProperty

function Moan(Actor ActorRef, int Strength = 30, bool IsVictim = false)
	if Config.UseLipSync && Game.GetCameraState() != 3
		ActorRef.Say(Config.LipSync)
	endIf
	GetSound(Strength, IsVictim).PlayAndWait(ActorRef)
endFunction

Sound function GetSound(int Strength, bool IsVictim = false)
	if IsVictim
		return Medium
	elseIf Strength > 75
		return Hot
	endIf
	return Mild
endFunction

bool function CheckGender(int CheckGender)
	return Gender == CheckGender || (Gender == -1 && (CheckGender == 1 || CheckGender == 0))
endFunction

function Save(int id = -1)
	; Make sure we have a gender tag
	if Gender == 0 || Gender == -1
		AddTag("Male")
	elseIf Gender == 1 || Gender == -1
		AddTag("Female")
	endIf
	; Log
	Log(Name, "Voices["+id+"]")
endFunction

function Initialize()
	Gender = -1
	Mild   = none
	Medium = none
	Hot    = none
	parent.Initialize()
endFunction
