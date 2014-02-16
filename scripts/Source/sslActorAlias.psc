scriptname sslActorAlias extends ReferenceAlias

; Necessary libraries
sslActorLibrary property Lib auto
sslSystemConfig property Config auto

; Actor Info
Actor property ActorRef auto hidden
int property Gender auto hidden
bool IsMale
bool IsFemale
bool IsCreature
bool IsPlayer
bool IsVictim
string ActorName
ActorBase BaseRef

; Current Thread state
int Stage
int Position
sslBaseAnimation Animation
sslThreadController Thread

; Voice
bool IsSilent
bool IsForcedSilent
float VoiceDelay
sslBaseVoice Voice

; Positioning
ObjectReference MarkerRef
float[] loc

; Storage
bool[] StripOverride
form strapon
float ActorScale
float AnimScale

; ------------------------------------------------------- ;
; --- Load/Clear Alias For Use                        --- ;
; ------------------------------------------------------- ;

bool function PrepareAlias(Actor ProspectRef, bool MakeVictim = false, sslBaseVoice UseVoice = none, bool ForceSilence = false)
	if ProspectRef == none || GetReference() != ProspectRef; || !Lib.ValidateActor(ProspectRef)
		return false ; Failed to set prospective actor into alias
	endIf
	; Register actor as active
	StorageUtil.FormListAdd(Lib, "Registry", ProspectRef, false)
	; Init actor alias information
	ActorRef = ProspectRef
	BaseRef = ActorRef.GetLeveledActorBase()
	ActorName = BaseRef.GetName()
	Gender = Lib.GetGender(ActorRef)
	IsMale = Gender == 0
	IsFemale = Gender == 1
	IsCreature = Gender == 2
	IsPlayer = ActorRef == Lib.PlayerRef
	IsForcedSilent = ForceSilence
	Voice = UseVoice
	IsVictim = MakeVictim
	if MakeVictim
		Thread.VictimRef = ActorRef
	endIf
	Thread.Log("ActorAlias has successfully slotted '"+ActorName+"'", self)
	GoToState("")
	return true
endFunction

function Clear()
	if GetReference() != none
		StorageUtil.FormListRemove(Lib, "Registry", GetReference(), true)
		UnlockActor()
	endIf
	parent.Clear()
	Initialize()
endFunction

; ------------------------------------------------------- ;
; --- Actor Thread Syncing                            --- ;
; ------------------------------------------------------- ;

function SyncThread()
	Stage = Thread.Stage
	Position = Thread.Positions.Find(ActorRef)
	Animation = Thread.Animation
endFunction

function SyncAnimation(sslBaseAnimation ToAnimation)
	Animation = ToAnimation
	IsSilent = Animation.IsSilent(Position, Stage)
	if Animation.UseOpenMouth(Position, Stage)
		ActorRef.SetExpressionOverride(16, 100)
	endIf
endFunction

function SyncStage(int ToStage)
	Stage = ToStage
endFunction

function SyncPosition(int ToPosition)
	Position = ToPosition
endFunction

; ------------------------------------------------------- ;
; --- Actor Prepartion                                --- ;
; ------------------------------------------------------- ;

function LockActor()
	if ActorRef == none
		return
	endIf
	; Start DoNothing package
	ActorRef.SetFactionRank(Lib.AnimatingFaction, 1)
	ActorUtil.AddPackageOverride(ActorRef, Lib.DoNothing, 100, 1)
	ActorRef.EvaluatePackage()
	; Disable movement
	if IsPlayer
		Game.ForceThirdPerson()
		Game.SetPlayerAIDriven()
		Game.DisablePlayerControls(false, false, false, false, false, false, true, false, 0)
		; Enable hotkeys, if needed
		if IsVictim && Config.bDisablePlayer
			Thread.AutoAdvance = true
		else
			; Lib.ControlLib._HKStart(Controller)
		endIf
	else
		; ActorRef.SetRestrained(true)
		ActorRef.SetDontMove(true)
	endIf
	; Attach positioning marker
	if !MarkerRef
		MarkerRef = ActorRef.PlaceAtMe(Lib.BaseMarker)
	endIf
	MarkerRef.Enable()
	MarkerRef.MoveTo(ActorRef)
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(MarkerRef)
endFunction

function UnlockActor()
	if ActorRef == none
		return
	endIf
	; Disable free camera, if in it
	if IsPlayer && Game.GetCameraState() == 3
		MiscUtil.ToggleFreeCamera()
	endIf
	; Enable movement
	if IsPlayer
		; Lib.ControlLib._HKClear()
		Game.SetPlayerAIDriven(false)
		Game.EnablePlayerControls(false, false, false, false, false, false, true, false, 0)
	else
		ActorRef.SetRestrained(false)
	endIf
	; Remove from animation faction
	ActorRef.RemoveFromFaction(Lib.AnimatingFaction)
	ActorUtil.RemovePackageOverride(ActorRef, Lib.DoNothing)
	ActorRef.EvaluatePackage()
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
	; Cleanup
	if !IsCreature
		TryToStopCombat()
		if ActorRef.IsWeaponDrawn()
			ActorRef.SheatheWeapon()
		endIf
	endIf
endFunction

state Prepare
	function FireAction()
		RegisterForSingleUpdate(0.05)
	endFunction
	event OnUpdate()
		TryToStopCombat()
		if ActorRef.IsWeaponDrawn()
			ActorRef.SheatheWeapon()
		endIf
		LockActor()
		; Calculate scales
		float display = ActorRef.GetScale()
		ActorRef.SetScale(1.0)
		float base = ActorRef.GetScale()
		ActorScale = ( display / base )
		AnimScale = ActorScale
		ActorRef.SetScale(ActorScale)
		if Thread.ActorCount > 1 && Config.bScaleActors
			AnimScale = (1.0 / base)
		endIf
		; Non Creatures
		if !IsCreature

		endIf
		GoToState("Ready")
	endEvent
endState

state Ready
	function StartAnimating()
		Action("Animating")
	endFunction
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;

state Animating
	function FireAction()
		RegisterForSingleUpdate(Utility.RandomFloat(0.50,1.80))
	endFunction

	event OnUpdate()
		Debug.TraceAndBox(ActorName+" Animating Update")
	endEvent
endState

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;


function Initialize()
	UnregisterForUpdate()
	GoToState("")
	Thread = (GetOwningQuest() as sslThreadController)
	Lib = (Quest.GetQuest("SexLabQuestFramework") as sslActorLibrary)
	Config = (Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig)

	if MarkerRef
		MarkerRef.Disable()
		MarkerRef.Delete()
	endIf
	MarkerRef = none
	ActorRef = none

endFunction

; event OnInit()
; 	Thread = (GetOwningQuest() as sslThreadController)
; 	Lib = (Quest.GetQuest("SexLabQuestFramework") as sslActorLibrary)
; 	Config = (Quest.GetQuest("SexLabQuestFramework") as sslSystemConfig)
; endEvent

function Action(string FireState)
	UnregisterForUpdate()
	if ActorRef != none
		GoToState(FireState)
		FireAction()
	endIf
endFunction

; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

; Ready
function StartAnimating()
	SexLabUtil.Log("StartAnimating() - Null start, alias not in Ready state. Currently: '"+GetState()+"'", ActorName, "FATAL", "trace,stack,console")
endFunction

; Varied
function FireAction()
endFunction
