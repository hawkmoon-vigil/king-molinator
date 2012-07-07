﻿-- The Ember.Szath Boss Mod for King Boss Mods
-- Written by Paul Snart
-- Copyright 2011
--

KBMINDEC_Settings = nil
chKBMINDEC_Settings = nil

-- Link Mods
local AddonData = Inspect.Addon.Detail("KingMolinator")
local KBM = AddonData.data
if not KBM.BossMod then
	return
end
local IND = KBM.BossMod["Infernal Dawn"]

local EC = {
	Enabled = true,
	Directory = IND.Directory,
	File = "Conclave.lua",
	Instance = IND.Name,
	Type = "20man",
	HasPhases = true,
	Lang = {},
	ID = "The Ember Conclave",
	Object = "EC",
	Enrage = 7.5 * 60,
}

EC.Szath = {
	Mod = EC,
	Level = "??",
	Active = false,
	Name = "Witchlord Szath",
	NameShort = "Szath",
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	MechRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Blood = KBM.Defaults.TimerObj.Create("purple"),
		},
		AlertsRef = {
			Enabled = true,
			Blood = KBM.Defaults.AlertObj.Create("purple"),
		},
		MechRef = {
			Enabled = true,
			Blood = KBM.Defaults.MechObj.Create("purple"),
		},
	}
}

KBM.RegisterMod(EC.ID, EC)

-- Main Unit Dictionary
EC.Lang.Unit = {}
EC.Lang.Unit.Szath = KBM.Language:Add(EC.Szath.Name)
EC.Lang.Unit.Szath:SetFrench("Seigneur-sorcier Szath")
EC.Lang.Unit.Szath:SetGerman("Hexenmeister Szath")
EC.Lang.Unit.Szath:SetKorean("대마녀 스자스")
EC.Lang.Unit.SzShort = KBM.Language:Add(EC.Szath.NameShort)
EC.Lang.Unit.SzShort:SetFrench()
EC.Lang.Unit.SzShort:SetGerman()
EC.Lang.Unit.SzShort:SetKorean("스자스")
EC.Lang.Unit.Nahoth = KBM.Language:Add("Packmaster Nahoth")
EC.Lang.Unit.Nahoth:SetFrench("Maître-fourrier Nahoth")
EC.Lang.Unit.Nahoth:SetGerman("Rudelmeister Nahoth")
EC.Lang.Unit.Nahoth:SetKorean("무리 대장 나호스")
EC.Lang.Unit.NahShort = KBM.Language:Add("Nahoth")
EC.Lang.Unit.NahShort:SetFrench()
EC.Lang.Unit.NahShort:SetGerman()
EC.Lang.Unit.NahShort:SetKorean("나호스")
EC.Lang.Unit.Ereetu = KBM.Language:Add("Emberlord Ereetu")
EC.Lang.Unit.Ereetu:SetFrench("Seigneur de Braise Ereetu")
EC.Lang.Unit.Ereetu:SetGerman("Glutfürst Ereetu")
EC.Lang.Unit.Ereetu:SetKorean("불씨군주 에리두")
EC.Lang.Unit.EreShort = KBM.Language:Add("Ereetu")
EC.Lang.Unit.EreShort:SetFrench()
EC.Lang.Unit.EreShort:SetGerman()
EC.Lang.Unit.EreShort:SetKorean("에리두")

EC.Nahoth = {
	Mod = EC,
	Level = "??",
	Active = false,
	Name = EC.Lang.Unit.Nahoth[KBM.Lang],
	NameShort = EC.Lang.Unit.NahShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	-- TimersRef = {},
	-- AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		-- TimersRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.TimerObj.Create("red"),
		-- },
		-- AlertsRef = {
			-- Enabled = true,
			-- Funnel = KBM.Defaults.AlertObj.Create("red"),
		-- },
	}
}

EC.Ereetu = {
	Mod = EC,
	Level = "??",
	Active = false,
	Name = EC.Lang.Unit.Ereetu[KBM.Lang],
	NameShort = EC.Lang.Unit.EreShort[KBM.Lang],
	Dead = false,
	Available = false,
	Menu = {},
	UnitID = nil,
	TimeOut = 5,
	Castbar = nil,
	TimersRef = {},
	AlertsRef = {},
	Triggers = {},
	Settings = {
		CastBar = KBM.Defaults.CastBar(),
		TimersRef = {
			Enabled = true,
			Dark = KBM.Defaults.TimerObj.Create("yellow"),
		},
		AlertsRef = {
			Enabled = true,
			Dark = KBM.Defaults.AlertObj.Create("yellow"),
		},
	}
}

-- Ability Dictionary
EC.Lang.Ability = {}
EC.Lang.Ability.Dark = KBM.Language:Add("Dark Invocation")

-- Ability Dictionary
EC.Lang.Debuff = {}
EC.Lang.Debuff.Hem = KBM.Language:Add("Profuse Hemorrhage")
EC.Lang.Debuff.Blood = KBM.Language:Add("Traitorous Blood")

-- Description Dictionary
EC.Lang.Main = {}
EC.Lang.Main.Descript = KBM.Language:Add("The Ember Conclave")
EC.Lang.Main.Descript:SetFrench("Conclave de braise")
EC.Lang.Main.Descript:SetGerman("Die Glutkonklave")
EC.Lang.Main.Descript:SetRussian("Раскаленный Конклав")
EC.Lang.Main.Descript:SetKorean("불씨 결사단")

EC.Szath.Name = EC.Lang.Unit.Szath[KBM.Lang]
EC.Szath.NameShort = EC.Lang.Unit.SzShort[KBM.Lang]
EC.Descript = EC.Lang.Main.Descript[KBM.Lang]

function EC:AddBosses(KBM_Boss)
	self.MenuName = self.Descript
	self.Bosses = {
		[self.Szath.Name] = self.Szath,
		[self.Nahoth.Name] = self.Nahoth,
		[self.Ereetu.Name] = self.Ereetu,
	}
	KBM_Boss[self.Szath.Name] = self.Szath
	KBM_Boss[self.Nahoth.Name] = self.Nahoth
	KBM_Boss[self.Ereetu.Name] = self.Ereetu
	
	for BossName, BossObj in pairs(self.Bosses) do
		if BossObj.Settings then
			if BossObj.Settings.CastBar then
				BossObj.Settings.CastBar.Override = true
				BossObj.Settings.CastBar.Multi = true
			end
		end
	end	
end

function EC:InitVars()
	self.Settings = {
		Enabled = true,
		CastBar = {
			Override = true,
			Multi = true,
		},
		EncTimer = KBM.Defaults.EncTimer(),
		PhaseMon = KBM.Defaults.PhaseMon(),
		MechSpy = KBM.Defaults.MechSpy(),
		Szath = {
			CastBar = self.Szath.Settings.CastBar,
			TimersRef = self.Szath.Settings.TimersRef,
			AlertsRef = self.Szath.Settings.AlertsRef,
			MechRef = self.Szath.Settings.MechRef,
		},
		Nahoth = {
			CastBar = self.Nahoth.Settings.CastBar,
			-- TimersRef = self.Nahoth.Settings.TimersRef,
			-- AlertsRef = self.Nahoth.Settings.AlertsRef,
		},
		Ereetu = {
			CastBar = self.Ereetu.Settings.CastBar,
			TimersRef = self.Ereetu.Settings.TimersRef,
			AlertsRef = self.Ereetu.Settings.AlertsRef,
		},
		MechTimer = KBM.Defaults.MechTimer(),
		Alerts = KBM.Defaults.Alerts(),
	}
	KBMINDEC_Settings = self.Settings
	chKBMINDEC_Settings = self.Settings
	
end

function EC:SwapSettings(bool)

	if bool then
		KBMINDEC_Settings = self.Settings
		self.Settings = chKBMINDEC_Settings
	else
		chKBMINDEC_Settings = self.Settings
		self.Settings = KBMINDEC_Settings
	end

end

function EC:LoadVars()	
	if KBM.Options.Character then
		KBM.LoadTable(chKBMINDEC_Settings, self.Settings)
	else
		KBM.LoadTable(KBMINDEC_Settings, self.Settings)
	end
	
	if KBM.Options.Character then
		chKBMINDEC_Settings = self.Settings
	else
		KBMINDEC_Settings = self.Settings
	end	
end

function EC:SaveVars()	
	if KBM.Options.Character then
		chKBMINDEC_Settings = self.Settings
	else
		KBMINDEC_Settings = self.Settings
	end	
end

function EC:Castbar(units)
end

function EC:RemoveUnits(UnitID)
	if self.Szath.UnitID == UnitID then
		self.Szath.Available = false
		return true
	end
	return false
end

function EC.SetBossObj()
	if EC.Ereetu.Dead == false then
		EC.PhaseObj.Objectives:AddPercent(EC.Ereetu.Name, 0, 100)
	end
	if EC.Szath.Dead == false then
		EC.PhaseObj.Objectives:AddPercent(EC.Szath.Name, 0, 100)
	end
	if EC.Nahoth.Dead == false then
		EC.PhaseObj.Objectives:AddPercent(EC.Nahoth.Name, 0, 100)
	end
end

function EC.PhaseTwo()
	local PhaseText = "2"
	if EC.HardMode then
		PhaseText = PhaseText.." (HM)"
	end
	EC.Phase = 2
	EC.PhaseObj.Objectives:Remove()
	EC.PhaseObj:SetPhase(PhaseText)
	EC.SetBossObj()
	if EC.Szeth.Dead == false then
		KBM.TankSwap:Start(EC.Lang.Debuff.Hem[KBM.Lang], EC.Szeth.UnitID)
	end	
	
end

function EC.PhaseFinal()
	local PhaseText = "Final"
	EC.Phase = 3
	if EC.HardMode then
		PhaseText = PhaseText.." (HM)"
	end
	EC.PhaseObj.Objectives:Remove()
	EC.PhaseObj:SetPhase(PhaseText)
	EC.SetBossObj()
	if KBM.TankSwap.Active then
		KBM.TankSwap:Remove()
	end	
end

function EC:Death(UnitID)
	if self.Szath.UnitID == UnitID then
		if self.Ereetu.Dead == false then
			self.HardMode = true
		else
			self.HardMode = false
		end
		if self.Phase == 1 then
			self.PhaseTwo()
		else
			self.PhaseFinal()
		end
		self.Szath.Dead = true
	elseif self.Nahoth.UnitID == UnitID then
		if self.Ereetu.Dead == false then
			self.HardMode = true
		else
			self.HardMode = false
		end
		if self.Phase == 1 then
			self.PhaseTwo()
		else
			self.PhaseFinal()
		end
		self.Nahoth.Dead = true
	elseif self.Ereetu.UnitID == UnitID then
		if self.Phase == 1 then
			self.HardMode = false
			self.PhaseTwo()
		elseif self.Phase == 2 then
			self.HardMode = false
			self.PhaseFinal()
		end
		self.Ereetu.Dead = true
	end
	if self.Szath.Dead == true then
		if self.Nahoth.Dead == true then
			if self.Ereetu.Dead == true then
				return true
			end
		end
	end
	return false
end

function EC:UnitHPCheck(unitDetails, unitID)	
	if unitDetails and unitID then
		if not unitDetails.player then
			if self.Bosses[unitDetails.name] then
				local BossObj = self.Bosses[unitDetails.name]
				if not self.EncounterRunning then
					self.EncounterRunning = true
					self.StartTime = Inspect.Time.Real()
					self.HeldTime = self.StartTime
					self.TimeElapsed = 0
					BossObj.Dead = false
					BossObj.Casting = false
					BossObj.CastBar:Create(unitID)
					self.PhaseObj:Start(self.StartTime)
					self.PhaseObj:SetPhase("1 (HM)")
					self.PhaseObj.Objectives:AddPercent(self.Szath.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Nahoth.Name, 0, 100)
					self.PhaseObj.Objectives:AddPercent(self.Ereetu.Name, 0, 100)
					self.Phase = 1
				else
					if not BossObj.CastBar.Active then
						BossObj.CastBar:Create(unitID)
					end
					BossObj.Dead = false
					BossObj.Casting = false
				end
				BossObj.UnitID = unitID
				BossObj.Available = true
				return BossObj
			end
		end
	end
end

function EC:Reset()
	self.EncounterRunning = false
	for Name, BossObj in pairs(self.Bosses) do
		BossObj.Available = false
		BossObj.UnitID = nil
		BossObj.Dead = false
		if BossObj.CastBar.Active then
			BossObj.CastBar:Remove()
		end
	end
	self.PhaseObj:End(Inspect.Time.Real())
	self.HardMode = true
	self.Phase = 1
end

function EC:Timer()	
end

function EC:DefineMenu()
	self.Menu = IND.Menu:CreateEncounter(self.Szath, self.Enabled)
end

function EC:Start()
	-- Create Timers (Ereetu)
	self.Ereetu.TimersRef.Dark = KBM.MechTimer:Add(self.Lang.Ability.Dark[KBM.Lang], 15)
	KBM.Defaults.TimerObj.Assign(self.Ereetu)
	
	-- Create Timers (Szath)
	self.Szath.TimersRef.Blood = KBM.MechTimer:Add(self.Lang.Debuff.Blood[KBM.Lang], 40)
	KBM.Defaults.TimerObj.Assign(self.Szath)
	
	-- Create Alerts (Ereetu)
	self.Ereetu.AlertsRef.Dark = KBM.Alert:Create(self.Lang.Ability.Dark[KBM.Lang], nil, false, true, "yellow")
	KBM.Defaults.AlertObj.Assign(self.Ereetu)
	
	-- Create Alerts (Szath)
	self.Szath.AlertsRef.Blood = KBM.Alert:Create(self.Lang.Debuff.Blood[KBM.Lang], 2, true, false, "purple")
	KBM.Defaults.AlertObj.Assign(self.Szath)
	
	-- Create Mechanic Spies (Szath)
	self.Szath.MechRef.Blood = KBM.MechSpy:Add(self.Lang.Debuff.Blood[KBM.Lang], -1, "playerDebuff", self.Szath)
	KBM.Defaults.MechObj.Assign(self.Szath)
	
	-- Assign Alerts and Timers to Triggers
	self.Ereetu.Triggers.Dark = KBM.Trigger:Create(self.Lang.Ability.Dark[KBM.Lang], "cast", self.Ereetu)
	self.Ereetu.Triggers.Dark:AddTimer(self.Ereetu.TimersRef.Dark)
	self.Ereetu.Triggers.Dark:AddAlert(self.Ereetu.AlertsRef.Dark)
	self.Ereetu.Triggers.DarkInt = KBM.Trigger:Create(self.Lang.Ability.Dark[KBM.Lang], "interrupt", self.Ereetu)
	self.Ereetu.Triggers.DarkInt:AddStop(self.Ereetu.AlertsRef.Dark)
	self.Szath.Triggers.Blood = KBM.Trigger:Create("B04039E99174644055", "playerIDBuff", self.Szath)
	self.Szath.Triggers.Blood:AddAlert(self.Szath.AlertsRef.Blood)
	self.Szath.Triggers.Blood:AddSpy(self.Szath.MechRef.Blood)
	self.Szath.Triggers.Blood:AddTimer(self.Szath.TimersRef.Blood)
	self.Szath.Triggers.BloodRem = KBM.Trigger:Create("B04039E99174644055", "playerIDBuffRemove", self.Szath)
	self.Szath.Triggers.Blood:AddStop(self.Szath.MechRef.Blood)
	
	self.Szath.CastBar = KBM.CastBar:Add(self, self.Szath)
	self.Nahoth.CastBar = KBM.CastBar:Add(self, self.Nahoth)
	self.Ereetu.CastBar = KBM.CastBar:Add(self, self.Ereetu)
	self.PhaseObj = KBM.PhaseMonitor.Phase:Create(1)
	self:DefineMenu()
end