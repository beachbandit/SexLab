Scriptname sslEffectDebug extends ActiveMagicEffect

SexLabFramework property SexLab Auto
import SexLabUtil

event OnEffectStart(actor TargetRef, actor CasterRef)
	sslBaseAnimation Anim = SexLab.GetAnimationByName("Rough Missionary")
	Log("Current: "+Anim.AccessOffset(0, 2, 0), Anim.Name, "", "trace,box,console")
	Anim.UpdateOffset(0, 2, 0, 30)
	Log("Adjusted: "+Anim.AccessOffset(0, 2, 0), Anim.Name, "", "trace,box,console")
endEvent

event OnEffectFinish(Actor TargetRef, Actor CasterRef)
endEvent



;/-----------------------------------------------\;
;|	Debug Utility Functions                      |;
;\-----------------------------------------------/;

function LockActor(actor ActorRef)
	; Start DoNothing package
	ActorUtil.AddPackageOverride(ActorRef, (Game.GetFormFromFile(0x0E50E, "SexLab.esm") as Package), 100)
	ActorRef.SetFactionRank(SexLab.AnimatingFaction, 1)
	ActorRef.EvaluatePackage()
	; Disable movement
	if ActorRef == SexLab.PlayerRef
		Game.DisablePlayerControls(false, false, false, false, false, false, true, false, 0)
		Game.ForceThirdPerson()
		Game.SetPlayerAIDriven()
	else
		ActorRef.SetRestrained(true)
		ActorRef.SetDontMove(true)
		; ActorRef.SetAnimationVariableBool("bHumanoidFootIKDisable", true)
	endIf
endFunction

function UnlockActor(actor ActorRef)
	; Enable movement
	if ActorRef == SexLab.PlayerRef
		Game.EnablePlayerControls(false, false, false, false, false, false, true, false, 0)
		Game.SetPlayerAIDriven(false)
		; Game.SetInChargen(false, false, false)
	else
		ActorRef.SetRestrained(false)
		ActorRef.SetDontMove(false)
		; ActorRef.SetAnimationVariableBool("bHumanoidFootIKEnable", true)
	endIf
	; Remove from animation faction
	ActorUtil.RemovePackageOverride(ActorRef, (Game.GetFormFromFile(0x0E50E, "SexLab.esm") as Package))
	ActorRef.RemoveFromFaction(SexLab.AnimatingFaction)
	ActorRef.EvaluatePackage()
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
endFunction

function Wait(float seconds)
	float timer = Utility.GetCurrentRealTime() + seconds
	while Utility.GetCurrentRealTime() < timer
		Utility.Wait(0.5)
	endWhile
endFunction
