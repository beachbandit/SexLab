scriptname sslVoiceSlots extends Quest

sslVoiceDefaults property Defaults auto
sslVoiceLibrary property Lib auto

sslBaseVoice[] Slots
sslBaseVoice[] property Voices hidden
	sslBaseVoice[] function get()
		return Slots
	endFunction
endProperty

int property Slotted auto hidden
bool property FreeSlots hidden
	bool function get()
		return slotted < 50
	endFunction
endProperty

;/-----------------------------------------------\;
;|	Search Voices                                |;
;\-----------------------------------------------/;

sslBaseVoice function GetRandom(int gender)
	; Select valid voices by gender
	bool[] valid = sslUtility.BoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		valid[i] = Slots[i].Registered && Slots[i].Enabled && Slots[i].Gender == gender
	endWhile
	; No valid voices found
	if valid.Find(true) == -1
		return none
	endIf
	; Pick random index within range of valid
	int rand = Utility.RandomInt(valid.Find(true), valid.RFind(true))
	int pos = valid.Find(true, rand)
	if pos == -1
		pos = valid.RFind(true, rand)
	endIf
	if pos != -1
		return Slots[pos]
	endIf
	return none
endFunction

sslBaseVoice function GetByName(string findName)
	int i
	while i < slotted
		if Slots[i].Registered && Slots[i].name == findName
			return Slots[i]
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseVoice function GetByTag(string tag1, string tag2 = "", string tagSuppress = "", bool requireAll = true)
	int i
	while i < slotted
		if Slots[i].Enabled
			bool check1 = Slots[i].HasTag(tag1)
			bool check2 = Slots[i].HasTag(tag2)
			bool supress = Slots[i].HasTag(tagSuppress)
			if requireAll && check1 && (check2 || tag2 == "") && !(supress && tagSuppress != "")
				return Slots[i]
			elseif !requireAll && (check1 || check2) && !(supress && tagSuppress != "")
				return Slots[i]
			endIf
		endIf
		i += 1
	endWhile
	return none
endFunction

sslBaseVoice function GetBySlot(int slot)
	return Slots[slot]
endFunction

;/-----------------------------------------------\;
;|	Locate Voices                                |;
;\-----------------------------------------------/;

int function FindByName(string findName)
	int i
	while i < slotted
		if Slots[i].Registered && Slots[i].Name == findName
			return i
		endIf
		i += 1
	endWhile
	return -1
endFunction

int function FindByRegistrar(string registrar)
	return StorageUtil.StringListFind(self, "Registry", registrar)
endFunction

int function Find(sslBaseVoice findVoice)
	return Slots.Find(findVoice)
endFunction

;/-----------------------------------------------\;
;|	Manage Voices                                |;
;\-----------------------------------------------/;

sslBaseVoice function GetFree()
	return Slots[slotted]
endFunction

int function Register(sslBaseVoice Claiming, string registrar)
	Claiming.Initialize()
	Claiming.Registry = registrar
	StorageUtil.StringListAdd(self, "Registry", registrar, false)
	Slotted = StorageUtil.StringListCount(self, "Registry")
	return Slots.Find(Claiming)
endFunction

int function GetCount(bool ignoreDisabled = true)
	if !ignoreDisabled
		return slotted
	endIf
	int count = 0
	int i = 0
	while i < slotted
		if Slots[i].Registered && Slots[i].Enabled
			count += 1
		endIf
		i += 1
	endWhile
	return count
endFunction

;/-----------------------------------------------\;
;|	System Voices                                |;
;\-----------------------------------------------/;

function _Setup()
	Slots = new sslBaseVoice[50]
	int i = 50
	while i
		i -= 1
		Slots[i] = GetNthAlias(i) as sslBaseVoice
		Slots[i].Initialize()
	endWhile
	Initialize()
	Defaults.LoadVoices()
	SendModEvent("SexLabSlotVoices")
	Debug.Notification("$SSL_NotifyVoiceInstall")
endFunction

function Initialize()
	Slotted = 0
	StorageUtil.StringListClear(self, "Registry")
endFunction
