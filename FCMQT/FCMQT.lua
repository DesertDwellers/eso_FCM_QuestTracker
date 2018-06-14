-- Name    : Fully Customizable MultiQuests Tracker (FCMQT)
-- Author  : DesertDwellers Original Coding by Black Storm
-- Version : 1.4.3.23
-- Date    : 2017/09/01
FCMQT = FCMQT or {}

-- Load libraries
local LAM = LibStub("LibAddonMenu-2.0")
local LMP = LibStub("LibMediaProvider-1.0")
local WM = WINDOW_MANAGER
local EM = EVENT_MANAGER
local QUEST_TIMER_TEXT_COLOR = "#ffaf61"
local QUEST_TIMER_TEXT = ""
-- ***********************************************************
-- Vars
-- ***********************************************************


LMP:Register("font", "ESO Standard Font", "EsoUI/Common/Fonts/univers57.otf")
LMP:Register("font", "ESO Book Font", "EsoUI/Common/Fonts/ProseAntiquePSMT.otf")
LMP:Register("font", "ESO Tablet Font", "EsoUI/Common/Fonts/TrajanPro-Regular.otf")


----------------------------------
--  Save & Load User Variables
----------------------------------
-- Init defaults vars
local Step_Type_And = QUEST_STEP_TYPE_AND -- 1
local Step_Type_End = QUEST_STEP_TYPE_END -- 3
local Step_Type_OR = QUEST_STEP_TYPE_OR  -- 2

local Step_Vis_Hidden = QUEST_STEP_VISIBILITY_HIDDEN -- 2
local Step_Vis_Hint = QUEST_STEP_VISIBILITY_HINT -- 0
local Step_Vis_Optional = QUEST_STEP_VISIBILITY_OPTIONAL -- 1

FCMQT.CyrodiilNumZoneIndex = 37
--**REMOVE 1.3**FCMQT.QuestTimer="Quest Time"


FCMQT.DEBUG = 0
SLASH_COMMANDS["/fcmqt_debug1"] = FCMQT.CMD_DEBUG1
SLASH_COMMANDS["/fcmqt_debug2"] = FCMQT.CMD_DEBUG2
SLASH_COMMANDS["/fcmqt_debug3"] = FCMQT.CMD_DEBUG3
SLASH_COMMANDS["/fcmqt_debug4"] = FCMQT.CMD_DEBUG4
SLASH_COMMANDS["/fcmqt_resetpos"] = FCMQT.CMD_Position
SLASH_COMMANDS["/fcmqt_lock"] = FCMQT.CMD_ToggleLock
FCMQT.CyrodiilNumZoneIndex = 37
FCMQT.QuestTimer="Quest Time"

-- Build and structure the box  ?? Did AddNewUIBox cause the issue with missings steps ??

function FCMQT.AddNewUIBox()
	if not FCMQT.box[FCMQT.boxmarker] then
		local dir = FCMQT.SavedVars.DirectionBox
		local myboxdirection = BOTTOMLEFT
		if dir == "BOTTOM" then
			myboxdirection = BOTTOMLEFT
		elseif dir == "TOP" then
			myboxdirection = TOPLEFT
		end
		-- Create Contener box
		FCMQT.box[FCMQT.boxmarker] = WM:CreateControl(nil, FCMQT.bg, CT_LABEL)
		FCMQT.box[FCMQT.boxmarker]:ClearAnchors()
		if FCMQT.boxmarker == 1 then
			FCMQT.box[FCMQT.boxmarker]:SetAnchor(TOPLEFT,FCMQT.boxqtimer, myboxdirection, 0, 0)
		else
			FCMQT.box[FCMQT.boxmarker]:SetAnchor(TOPLEFT,FCMQT.box[FCMQT.boxmarker-1],myboxdirection,0,0)
		end
		FCMQT.box[FCMQT.boxmarker]:SetResizeToFitDescendents(true)
		-- Create Icon Box
		FCMQT.icon[FCMQT.boxmarker] = WM:CreateControl(nil, FCMQT.bg, CT_TEXTURE)
		FCMQT.icon[FCMQT.boxmarker]:ClearAnchors()
		FCMQT.icon[FCMQT.boxmarker]:SetAnchor(TOPRIGHT,FCMQT.box[FCMQT.boxmarker],TOPLEFT,0,0)
		FCMQT.icon[FCMQT.boxmarker]:SetDimensions(FCMQT.SavedVars.QuestIconSize, FCMQT.SavedVars.QuestIconSize)
		-- Create Title Box
		FCMQT.textbox[FCMQT.boxmarker] = WM:CreateControl(nil, FCMQT.box[FCMQT.boxmarker] , CT_LABEL)
		FCMQT.textbox[FCMQT.boxmarker]:ClearAnchors()
		FCMQT.textbox[FCMQT.boxmarker]:SetAnchor(CENTER,FCMQT.box[FCMQT.boxmarker],CENTER,0,0)
		FCMQT.textbox[FCMQT.boxmarker]:SetDrawLayer(1)
	end
end

-- Add New Title

function FCMQT.AddNewTitle(qindex, qlevel, qname, qtype, qzone, qfocusedzoneval)
	if FCMQT.DEBUG == 2 then d("*** ADD NEW TITLE qzone "..qzone.." qfocusedzoneval  "..qfocusedzoneval) end
	-- Generate a new box if not exist one
	FCMQT.AddNewUIBox()
	-- Refresh content
	if FCMQT.SavedVars.QuestIcon == "Icon Dragonknight" then
		FCMQT.icon[FCMQT.boxmarker]:SetTexture("esoui/art/contacts/social_classicon_dragonknight.dds")
	elseif FCMQT.SavedVars.QuestIcon == "Icon Nightblade" then
		FCMQT.icon[FCMQT.boxmarker]:SetTexture("esoui/art/contacts/social_classicon_nightblade.dds")
	elseif FCMQT.SavedVars.QuestIcon == "Icon Sorcerer" then
		FCMQT.icon[FCMQT.boxmarker]:SetTexture("esoui/art/contacts/social_classicon_sorcerer.dds")
	elseif FCMQT.SavedVars.QuestIcon == "Icon Templar" then
		FCMQT.icon[FCMQT.boxmarker]:SetTexture("esoui/art/contacts/social_classicon_templar.dds")
	else
		FCMQT.icon[FCMQT.boxmarker]:SetTexture("/esoui/art/compass/quest_icon_assisted.dds")
	end	
	FCMQT.box[FCMQT.boxmarker]:SetDimensionConstraints(FCMQT.SavedVars.BgWidth,-1,FCMQT.SavedVars.BgWidth,-1)
	FCMQT.textbox[FCMQT.boxmarker]:SetDimensionConstraints(FCMQT.SavedVars.BgWidth-FCMQT.SavedVars.TitlePadding,-1,FCMQT.SavedVars.BgWidth-FCMQT.SavedVars.TitlePadding,-1)
	FCMQT.textbox[FCMQT.boxmarker]:SetFont(("%s|%s|%s"):format(LMP:Fetch('font', FCMQT.SavedVars.TitleFont), FCMQT.SavedVars.TitleSize, FCMQT.SavedVars.TitleStyle))
	
	if FCMQT.SavedVars.PositionLockOption == true then
		if not FCMQT.textbox[FCMQT.boxmarker]:IsMouseEnabled() then
			FCMQT.textbox[FCMQT.boxmarker]:SetMouseEnabled(true)
		end
		FCMQT.textbox[FCMQT.boxmarker]:SetHandler("OnMouseDown", function(self, click)
			FCMQT.MouseController(click, qindex, qname)
		end)
	else
		if FCMQT.textbox[FCMQT.boxmarker]:IsMouseEnabled() then
			FCMQT.textbox[FCMQT.boxmarker]:SetMouseEnabled(false)
		end
		FCMQT.textbox[FCMQT.boxmarker]:SetHandler()
	end	
	
	local CurrentFocusedQuest = GetTrackedIsAssisted(1,qindex,0)
	if CurrentFocusedQuest == true then
		FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
		FCMQT.currentAssistedArea = FCMQT.currentAreaBox
		if FCMQT.SavedVars.QuestIconOption then
			FCMQT.icon[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.QuestIconColor.r,FCMQT.SavedVars.QuestIconColor.g,FCMQT.SavedVars.QuestIconColor.b,FCMQT.SavedVars.QuestIconColor.a)
			FCMQT.icon[FCMQT.boxmarker]:SetHidden(false)
			FCMQT.currenticon = qindex
		else
			FCMQT.icon[FCMQT.boxmarker]:SetHidden(true)
		end
	else
		FCMQT.icon[FCMQT.boxmarker]:SetHidden(true)
		if FCMQT.QuestsNoFocusOption == false then
			FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
		else
			if FCMQT.FocusedQuestAreaNoTrans == true and qfocusedzoneval == 1 then
				FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
			else
				FCMQT.box[FCMQT.boxmarker]:SetAlpha(FCMQT.SavedVars.QuestsNoFocusTransparency/100)
			end
		end	
	end
	-- Set qname to add in quest type if selected
	-- sub first two lines with saved vars item
	if FCMQT.QuestsHybridOption == false or FCMQT.QuestsAreaOption == false then
		if qtype == QUEST_TYPE_AVA or qtype == QUEST_TYPE_AVA_GRAND or qtype == QUEST_TYPE_AVA_GROUP then
			qname = qname.." (AvA)"
		elseif qtype == QUEST_TYPE_GUILD then
			qname = qname.." ("..FCMQT.mylanguage.lang_tracker_type_guild..")"
		elseif qtype == QUEST_TYPE_MAIN_STORY then
			qname = qname.." ("..FCMQT.mylanguage.lang_tracker_type_mainstory..")"
		elseif qtype == QUEST_TYPE_CLASS then
			qname = qname.." ("..FCMQT.mylanguage.lang_tracker_type_class..")"
		elseif qtype == QUEST_TYPE_CRAFTING then
			qname = qname.." ("..FCMQT.mylanguage.lang_tracker_type_craft..")"
		elseif qtype == QUEST_TYPE_GROUP then
			qname = qname.." ("..FCMQT.mylanguage.lang_tracker_type_group..")"
		elseif qtype == QUEST_TYPE_DUNGEON then
			qname = qname.." ("..FCMQT.mylanguage.lang_tracker_type_dungeon..")"
		elseif qtype == QUEST_TYPE_RAID then
			qname = qname.." ("..FCMQT.mylanguage.lang_tracker_type_raid..")"
		elseif qtype == QUEST_TYPE_BATTLEGROUND then
			qname = qname.." ("..FCMQT.mylanguage.lang_tracker_type_bg..")"
		elseif qtype == QUEST_TYPE_HOLIDAY_EVENT then
			qname = qname.." ("..FCMQT.mylanguage.lang_tracker_type_holiday_event..")"
		elseif qtype == QUEST_TYPE_QA_TEST then
			qname = qname.." ("..FCMQT.mylanguage.lang_tracker_type_test..")"
		end
	end
	FCMQT.textbox[FCMQT.boxmarker]:SetText(qname)
	FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TitleColor.r, FCMQT.SavedVars.TitleColor.g, FCMQT.SavedVars.TitleColor.b, FCMQT.SavedVars.TitleColor.a)
	FCMQT.boxmarker = FCMQT.boxmarker + 1
end

-- Check content is used when new content is being added, only add what is not selected to be hidden.  Called by AddNewContent().
-- Done seperate to help keep it cleaner as the options grew.

function FCMQT.CheckContent(qcindex, qcstep, qctext, qcmytype, qczone, qcfocusedzoneval)
	if qcmytype == 2 and FCMQT.SavedVars.HideCompleteObjHints == false then
		FCMQT.AddNewContent(qcindex, qcstep, qctext, qcmytype, qczone, qcfocusedzoneval)
	elseif qcmytype == 3 and FCMQT.SavedVars.HideOptionalInfo == false and FCMQT.HideInfoHintsOption == false then
		FCMQT.AddNewContent(qcindex, qcstep, qctext, qcmytype, qczone, qcfocusedzoneval)
	elseif qcmytype == 4 and FCMQT.SavedVars.HideCompleteObjHints == false and FCMQT.SavedVars.HideOptionalInfo == false and FCMQT.HideInfoHintsOption == false then
		FCMQT.AddNewContent(qcindex, qcstep, qctext, qcmytype, qczone, qcfocusedzoneval)
	elseif qcmytype == 5 and FCMQT.SavedVars.HideOptObjective == false and FCMQT.HideInfoHintsOption == false then
		FCMQT.AddNewContent(qcindex, qcstep, qctext, qcmytype, qczone, qcfocusedzoneval)
	elseif qcmytype == 6 and FCMQT.SavedVars.HideCompleteObjHints == false and FCMQT.SavedVars.HideOptObjective == false and FCMQT.HideInfoHintsOption == false then
		FCMQT.AddNewContent(qcindex, qcstep, qctext, qcmytype, qczone, qcfocusedzoneval)
	elseif qcmytype == 7 and FCMQT.SavedVars.HideHintsOption == false and FCMQT.HideInfoHintsOption == false then
		FCMQT.AddNewContent(qcindex, qcstep, qctext, qcmytype, qczone, qcfocusedzoneval)
	elseif qcmytype == 8 and FCMQT.SavedVars.HideCompleteObjHints == false and FCMQT.SavedVars.HideHintsOption == false and FCMQT.HideInfoHintsOption == false then
		FCMQT.AddNewContent(qcindex, qcstep, qctext, qcmytype, qczone, qcfocusedzoneval)
	elseif qcmytype == 9 and FCMQT.SavedVars.HideHiddenOptions == false and FCMQT.HideInfoHintsOption == false then
		FCMQT.AddNewContent(qcindex, qcstep, qctext, qcmytype, qczone, qcfocusedzoneval)
	elseif qcmytype == 10 and FCMQT.SavedVars.HideCompleteObjHints == false and FCMQT.SavedVars.HideHiddenOptions == false and FCMQT.HideInfoHintsOption == false then
		FCMQT.AddNewContent(qcindex, qcstep, qctext, qcmytype, qczone, qcfocusedzoneval)
	elseif qcmytype == 1 then 
		FCMQT.AddNewContent(qcindex, qcstep, qctext, qcmytype, qczone, qcfocusedzoneval)
	end
end

function FCMQT.AddNewContent(qindex, qstep, qtext, mytype, qzone, qfocusedzoneval)
	local mytype = mytype
	-- Generate a new box if not exist one
	FCMQT.AddNewUIBox()
	-- Refresh content
	if FCMQT.SavedVars.QuestIcon == "Icon Dragonknight" then 
	FCMQT.icon[FCMQT.boxmarker]:SetTexture("esoui/art/contacts/social_classicon_dragonknight.dds")
	elseif FCMQT.SavedVars.QuestIcon == "Icon Nightblade" then
	FCMQT.icon[FCMQT.boxmarker]:SetTexture("esoui/art/contacts/social_classicon_nightblade.dds")
	elseif FCMQT.SavedVars.QuestIcon == "Icon Sorcerer" then
	FCMQT.icon[FCMQT.boxmarker]:SetTexture("esoui/art/contacts/social_classicon_sorcerer.dds")
	elseif FCMQT.SavedVars.QuestIcon == "Icon Templar" then
	FCMQT.icon[FCMQT.boxmarker]:SetTexture("esoui/art/contacts/social_classicon_templar.dds")
	else
		FCMQT.icon[FCMQT.boxmarker]:SetTexture("/esoui/art/compass/quest_icon_assisted.dds")
	end
	FCMQT.box[FCMQT.boxmarker]:SetDimensionConstraints(FCMQT.SavedVars.BgWidth,-1,FCMQT.SavedVars.BgWidth,-1)
	FCMQT.icon[FCMQT.boxmarker]:SetHidden(true)
	FCMQT.textbox[FCMQT.boxmarker]:SetDimensionConstraints(FCMQT.SavedVars.BgWidth-FCMQT.SavedVars.TextPadding,-1,FCMQT.SavedVars.BgWidth-FCMQT.SavedVars.TextPadding,-1)
	FCMQT.textbox[FCMQT.boxmarker]:SetFont(("%s|%s|%s"):format(LMP:Fetch('font', FCMQT.SavedVars.TextFont), FCMQT.SavedVars.TextSize, FCMQT.SavedVars.TextStyle))
	
	if FCMQT.SavedVars.PositionLockOption == true then
		if not FCMQT.textbox[FCMQT.boxmarker]:IsMouseEnabled() then
			FCMQT.textbox[FCMQT.boxmarker]:SetMouseEnabled(true)
		end
		FCMQT.textbox[FCMQT.boxmarker]:SetHandler("OnMouseDown", function(self, click)
			local qname = GetJournalQuestName(qindex)
			FCMQT.MouseController(click, qindex, qname)
		end)
	else
		if FCMQT.textbox[FCMQT.boxmarker]:IsMouseEnabled() then
			FCMQT.textbox[FCMQT.boxmarker]:SetMouseEnabled(false)
		end
		FCMQT.textbox[FCMQT.boxmarker]:SetHandler()
	end	
	local CurrentFocusedQuest = GetTrackedIsAssisted(1,qindex,0)
	if mytype == 2 then
		FCMQT.textbox[FCMQT.boxmarker]:SetText("*"..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextCompleteColor.r, FCMQT.SavedVars.TextCompleteColor.g, FCMQT.SavedVars.TextCompleteColor.b,FCMQT.SavedVars.TextCompleteColor.a)
	elseif mytype == 3 then
		FCMQT.textbox[FCMQT.boxmarker]:SetText(FCMQT.mylanguage.quest_optional.." : "..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextOptionalColor.r, FCMQT.SavedVars.TextOptionalColor.g, FCMQT.SavedVars.TextOptionalColor.b, FCMQT.SavedVars.TextOptionalColor.a)
	elseif mytype == 4 then
		FCMQT.textbox[FCMQT.boxmarker]:SetText(FCMQT.mylanguage.quest_optional.." : "..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextOptionalCompleteColor.r, FCMQT.SavedVars.TextOptionalCompleteColor.g, FCMQT.SavedVars.TextOptionalCompleteColor.b, FCMQT.SavedVars.TextOptionalCompleteColor.a)
	elseif mytype == 5 then
		FCMQT.textbox[FCMQT.boxmarker]:SetText("**"..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextOptionalColor.r, FCMQT.SavedVars.TextOptionalColor.g, FCMQT.SavedVars.TextOptionalColor.b, FCMQT.SavedVars.TextOptionalColor.a)
	elseif mytype == 6 then
		FCMQT.textbox[FCMQT.boxmarker]:SetText("**"..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextOptionalColor.r, FCMQT.SavedVars.TextOptionalColor.g, FCMQT.SavedVars.TextOptionalColor.b, FCMQT.SavedVars.TextOptionalColor.a)
	elseif mytype == 7 then
		FCMQT.textbox[FCMQT.boxmarker]:SetText(FCMQT.mylanguage.quest_hint.." : "..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.HintColor.r, FCMQT.SavedVars.HintColor.g, FCMQT.SavedVars.HintColor.b, FCMQT.SavedVars.HintColor.a)
	elseif mytype == 8 then
		FCMQT.textbox[FCMQT.boxmarker]:SetText(FCMQT.mylanguage.quest_hint.." : "..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.HintCompleteColor.r, FCMQT.SavedVars.HintCompleteColor.g, FCMQT.SavedVars.HintCompleteColor.b, FCMQT.SavedVars.HintCompleteColor.a)
	elseif mytype == 9 then
		FCMQT.textbox[FCMQT.boxmarker]:SetText(FCMQT.mylanguage.quest_hiddenhint.." : "..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.HintColor.r, FCMQT.SavedVars.HintColor.g, FCMQT.SavedVars.HintColor.b, FCMQT.SavedVars.HintColor.a)
	elseif mytype == 10 then
		FCMQT.textbox[FCMQT.boxmarker]:SetText(FCMQT.mylanguage.quest_hiddenhint.." : "..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.HintCompleteColor.r, FCMQT.SavedVars.HintCompleteColor.g, FCMQT.SavedVars.HintCompleteColor.b, FCMQT.SavedVars.HintCompleteColor.a)
	else
		FCMQT.textbox[FCMQT.boxmarker]:SetText("*"..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextColor.r, FCMQT.SavedVars.TextColor.g, FCMQT.SavedVars.TextColor.b, FCMQT.SavedVars.TextColor.a)
	end
	if CurrentFottcusedQuest == true then
		FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
	else
		if FCMQT.QuestsNoFocusOption == false then
			FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
		else
			if CurrentFocusedQuest == true then
				FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
			else
				if FCMQT.FocusedQuestAreaNoTrans == true and qfocusedzoneval == 1 then
					FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
				else
					FCMQT.box[FCMQT.boxmarker]:SetAlpha(FCMQT.SavedVars.QuestsNoFocusTransparency/100)
				end
			end
		end	
	end
	FCMQT.boxmarker = FCMQT.boxmarker + 1
end


--=======================================
-- Quest Timer
--=======================================
function FCMQT.HideQuestTimer()
	if FCMQT.DEBUG == 3 then d("HideQuestTimer") end

	FCMQT.boxqtimer:SetHidden(true)
	EM:UnregisterForUpdate("FCMQT_Update_Timer")
	FCMQT.isTimedQuest = false
end

function FCMQT.UpdateQuestTime(_timerEnd)
	--DebugMessage--
	--if FCMQT.DEBUG == 3 then d("FCMQT.UpdateQuestTime  idx "..i.." _timerEnd ".._timerEnd) end

	local RemainingTime = _timerEnd - GetFrameTimeSeconds()

	if RemainingTime > 0 then
		local TimeText, NextUpdate = ZO_FormatTime(RemainingTime, TIME_FORMAT_STYLE_COLONS, TIME_FORMAT_PRECISION_SECONDS, TIME_FORMAT_DIRECTION_DESCENDING)
		FCMQT.QuestTimer = "Time: "..TimeText
		FCMQT.isTimedQuest = true
		-- Should already be done at build of box
		FCMQT.boxqtimer:SetColor(FCMQT.SavedVars.TimerTitleColor.r, FCMQT.SavedVars.TimerTitleColor.g, FCMQT.SavedVars.TimerTitleColor.b, FCMQT.SavedVars.TimerTitleColor.a)
		--FCMQT.ClearQTimer(true)
		FCMQT.boxqtimer:SetColor(FCMQT.SavedVars.TimerTitleColor.r, FCMQT.SavedVars.TimerTitleColor.g, FCMQT.SavedVars.TimerTitleColor.b, FCMQT.SavedVars.TimerTitleColor.a)
		FCMQT.boxqtimer:SetText(FCMQT.QuestTimer)
		if FCMQT.DEBUG == 3 then d(FCMQT.QuestTimer) end
	else
		FCMQT.HideQuestTimer()
	end
end

function FCMQT.ShowQuestTimer(_timerEnd)
	--DebugMessage--
	if FCMQT.DEBUG == 3 then d("ShowQuestTimer") end
	EM:RegisterForUpdate("FCMQT_Update_Timer", 10, function() FCMQT.UpdateQuestTime(_timerEnd) end, 10)
	FCMQT.isTimedQuest = true
	FCMQT.boxqtimer:SetHidden(false)
	FCMQT.UpdateQuestTime(_timerEnd)
	
end


function FCMQT.GetQuestTimer(i)
	local TimerStart, _timerEnd, isVisible, isPaused = GetJournalQuestTimerInfo(i) 
	--DebugMessage QT
	if FCMQT.DEBUG == 3 then 
		d("**Timer ** QuestTimer: idx "..i.."Start "..TimerStart.." End ".._timerEnd)
	end
	if isVisible then
		local CurrentFocusedQuest = GetTrackedIsAssisted(1,i,0)
		if CurrentFocusedQuest then
			FCMQT.isTimedQuest = true
			--FCMQT.idxTimedQuest = i
			FCMQT.ShowQuestTimer(_timerEnd)
		end
	else
		FCMQT.isTimedQuest = false
	end
end	

----------------------------------
--            Refresh 
----------------------------------

function FCMQT.LoadQuestsInfo(i)
	-- ********************************************************************
	-- Builds QuestList
	-- Uses FCMQT.DEBUG == 1 for output
	-- *********************************************************************
	
	-- Grab initial quest information
	local qname, backgroundText, activeStepText, activeStepType, activeStepTrackerOverrideText, completed, tracked, qlevel, pushed, qtype = GetJournalQuestInfo(i)
		if (qname ~= nil and #qname > 0) then
		-- If valid quest grab the location information and do debug output if needed
			local qzone, qobjective, qzoneidx, poiIndex = GetJournalQuestLocationInfo(i)
			FCMQT.GetQuestTimer(i)
			if FCMQT.DEBUG == 1 then 
				d("**QUEST**********************************************************")
				d("DEBUG "..qname.."  ZoneIndex : "..qzoneidx.." / Zone : "..qzone)
				local currentmapidx = GetCurrentMapZoneIndex()
				d("Player IDX Location: "..currentmapidx)
				if tracked == true then d("Is Tracked : True")
				else d("Is Tracked : false")
				end
				d("QType : "..qtype.."  backgroundText : "..backgroundText.." / activeStepText : "..activeStepText)
			end
			-- Collect infos for table sort
			qzone = #qzone > 0 and zo_strformat(SI_QUEST_JOURNAL_ZONE_FORMAT, qzone) or zo_strformat(SI_QUEST_JOURNAL_GENERAL_CATEGORY)
			--qzone = #qzone > 0 and zo_strformat(SI_QUEST_JOURNAL_ZONE_FORMAT, qzone)
			FCMQT.MyPlayerLevel = GetUnitLevel('player')
			FCMQT.MyPlayerVLevel = GetUnitVeteranRank('player')
			-- ----------------------------------------------------------
			-- Start of FCMQT.QuestList Generation
			-- ----------------------------------------------------------
			FCMQT.QuestList[FCMQT.varnumquest] = {}
			FCMQT.QuestList[FCMQT.varnumquest].index = i
			FCMQT.QuestList[FCMQT.varnumquest].zoneidx = qzoneidx or "nil"
			FCMQT.QuestList[FCMQT.varnumquest].zone = qzone
			FCMQT.QuestList[FCMQT.varnumquest].level = GetJournalQuestLevel(i)
			-- Check to see if the current quest is current focused quest, set QuestList[x].focusquest to 1 if focused quest else zero.
			local CurrentFocusedQuest = GetTrackedIsAssisted(1,i,0)
			if CurrentFocusedQuest then 
				FCMQT.QuestList[FCMQT.varnumquest].focusquest = 1 
			else 
				FCMQT.QuestList[FCMQT.varnumquest].focusquest = 0 
			end
			FCMQT.QuestList[FCMQT.varnumquest].focusedzone = FCMQT.FocusedZone
			-- focused zone
			if FCMQT.FocusedZone == qzone then 
				FCMQT.QuestList[FCMQT.varnumquest].focusedzoneval = 1
			else
				FCMQT.QuestList[FCMQT.varnumquest].focusedzoneval = 0
			end
			-- Debug info focused quest and zone
			if FCMQT.DEBUG == 1 then 
				d("Found focused zone "..FCMQT.FocusedZone.." zone idx "..FCMQT.FocusedZoneIdx.."  zoneval "..FCMQT.QuestList[FCMQT.varnumquest].focusedzoneval)
				if FCMQT.QuestList[FCMQT.varnumquest].focusquest == 1 then d("Focused Quest") else d("Not Focused Quest") end
			end
			FCMQT.QuestList[FCMQT.varnumquest].name = qname
			FCMQT.QuestList[FCMQT.varnumquest].type = qtype
			FCMQT.QuestList[FCMQT.varnumquest].tracked = tracked
			-- MyZone is to be used for what zone name is actually displayed and for sort.
			FCMQT.QuestList[FCMQT.varnumquest].myzone = qzone
			-- MyZone determination - Only if area (zone) option is on, and Hybrid (category view) is on else myzone remains same as qzone or zone
			if FCMQT.QuestsHybridOption == true and FCMQT.QuestsAreaOption == true then
				if FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_AVA or FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_AVA_GRAND or FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_AVA_GROUP then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.QuestList[FCMQT.varnumquest].myzone.." (AvA)"
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_GUILD then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_guild
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_MAIN_STORY then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_mainstory
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_CLASS and FCMQT.SavedVars.QuestsCategoryClassOption == true then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_class.." - "..FCMQT.QuestList[FCMQT.varnumquest].myzone
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_CLASS and FCMQT.SavedVars.QuestsCategoryClassOption == false then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_class
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_CRAFTING and FCMQT.SavedVars.QuestsCategoryCraftOption == true then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_craft.." - "..FCMQT.QuestList[FCMQT.varnumquest].myzone
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_CRAFTING and FCMQT.SavedVars.QuestsCategoryCraftOption == false then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_craft
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_GROUP and FCMQT.SavedVars.QuestsCategoryGroupOption == true then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_group.." - "..FCMQT.QuestList[FCMQT.varnumquest].myzone
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_GROUP and FCMQT.SavedVars.QuestsCategoryGroupOption == false then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_group
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_DUNGEON and FCMQT.SavedVars.QuestsCategoryDungeonOption == true then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_dungeon.." - "..FCMQT.QuestList[FCMQT.varnumquest].myzone
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_DUNGEON and FCMQT.SavedVars.QuestsCategoryDungeonOption == false then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_dungeon
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_RAID and FCMQT.SavedVars.QuestsCategoryRaidOption == true then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_raid.." - "..FCMQT.QuestList[FCMQT.varnumquest].myzone
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_RAID and FCMQT.SavedVars.QuestsCategoryRaidOption == false then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_raid.." - "..FCMQT.QuestList[FCMQT.varnumquest].myzone
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_BATTLEGROUND then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_bg.." - "..FCMQT.QuestList[FCMQT.varnumquest].myzone
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_HOLIDAY_EVENT then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.mylanguage.lang_tracker_type_holiday_event.." - "..FCMQT.QuestList[FCMQT.varnumquest].myzone
				elseif FCMQT.QuestList[FCMQT.varnumquest].type == QUEST_TYPE_QA_TEST then
					FCMQT.QuestList[FCMQT.varnumquest].myzone = FCMQT.QuestList[FCMQT.varnumquest].myzone.." (TEST)"
				end
			end
			if FCMQT.DEBUG == 1 then d("Zone Name: "..FCMQT.QuestList[FCMQT.varnumquest].zone.."     MyZone Name: "..FCMQT.QuestList[FCMQT.varnumquest].myzone) end
			-- Quest Steps
			FCMQT.QuestList[FCMQT.varnumquest].step = {}
			local k = 1
			local condcheck2 = {}
			local nbStep = GetJournalQuestNumSteps(i)
			if FCMQT.DEBUG == 1 then 
				d("qtype : "..qtype.." / ActiveStepType : "..activeStepType.. " / nbStep : "..nbStep)
				d("--END QUEST INFO---Start Steps Info------------")
			end
			for idx=1, nbStep do
				if FCMQT.DEBUG == 1 then d("***STEP idx "..idx.."***************************************") end
				if activeStepType == 3 then
					local goal, dialog, confirmComplete, declineComplete, backgroundText, journalStepText = GetJournalQuestEnding(i)
					if (goal ~= nil and goal ~= "") then
						if FCMQT.DEBUG == 1 then d("Step idx "..idx.." -> Goal : "..goal.." Step Type END") end
						if not FCMQT.QuestList[FCMQT.varnumquest].step[k] then
							FCMQT.QuestList[FCMQT.varnumquest].step[k] = {}
						end
						FCMQT.QuestList[FCMQT.varnumquest].step[k].text = goal
						FCMQT.QuestList[FCMQT.varnumquest].step[k].mytype = 1
						k = k + 1
					end
				else
					local qstep, visibility, stepType, trackerOverrideText, numConditions = GetJournalQuestStepInfo(i,idx)
					if (qstep ~= nil) then
						if FCMQT.DEBUG == 1 then 
							d("Step"..idx.." type : "..stepType.." 1 AND 2 OR   over : "..trackerOverrideText.." / -> Step : "..qstep)
						end 
						if FCMQT.DEBUG == 1 then d("Visibility check and mytype assignments -----------------") end
						if visibility == nil or visibility == QUEST_STEP_VISIBILITY_HINT or visibility == QUEST_STEP_VISIBILITY_OPTIONAL or visibility == QUEST_STEP_VISIBILITY_HIDDEN then
							--**REMOVE 1.3**if ((visibility == 0 or visibility == 1 or visibility == 2) and FCMQT.HideInfoHintsOption == false) then
							if ((visibility == nil or visibility == QUEST_STEP_VISIBILITY_HIDDEN or visibility == QUEST_STEP_VISIBILITY_HINT or visibility == QUEST_STEP_VISIBILITY_OPTIONAL) and FCMQT.SavedVars.HideInfoOptionalObjOption == true) then
								-- QUEST_STEP_VISIBILITY_OPTIONAL = 1 Optional
								if visibility == QUEST_STEP_VISIBILITY_OPTIONAL then
									mytype = 3
								-- QUEST_STEP_VISIBILITY_HIDDEN 2
								elseif visibility == QUEST_STEP_VISIBILITY_HIDDEN then
									mytype = 9
								-- QUEST_STEP_VISIBILITY_HINT
								else
									mytype = 7
								end
								if not FCMQT.QuestList[FCMQT.varnumquest].step[k] then
									FCMQT.QuestList[FCMQT.varnumquest].step[k] = {}
								end
								FCMQT.QuestList[FCMQT.varnumquest].step[k].text = qstep
								FCMQT.QuestList[FCMQT.varnumquest].step[k].mytype = mytype
								-- DEBUG1 Start
								if FCMQT.DEBUG == 1 then 
									d("Step Added "..k.." Visibility: "..visibility.."  mytype "..mytype)
									d("Step text "..qstep)
								end
								-- DEBUG1 End
								k = k + 1
							else
								local checkstep = ""
								if FCMQT.DEBUG == 1 then d("Visibiliyt nil   numConditions : "..numConditions) end
								for m=1, numConditions do
									if FCMQT.DEBUG == 1 then d("Step num : "..k) end
									local mytype = 1
									local conditionText, current, max, isFailCondition, isComplete, isCreditShared = GetJournalQuestConditionInfo(i, idx, m)
									if conditionText ~= nil and conditionText ~= "" then
										if activeStepType == 2 then
											if idx >= nbStep and idx > 1 then
												break;
											end
										end
										
										if checkstep ~= qstep then
											if visibility == QUEST_STEP_VISIBILITY_OPTIONAL then
											-- Optional quests infos
												if FCMQT.DEBUG == 1 then d("Cond Added1 vis=1 -- Optional ") end
												if isComplete ~= true then mytype = 3 else mytype = 4 end
											-- quests hints infos
											elseif visibility == QUEST_STEP_VISIBILITY_HINT then
												if FCMQT.DEBUG == 1 then d("Cond Added1 vis=0 -- Hint ") end
												if isComplete ~= true then mytype = 7 else mytype = 8 end
											-- hidden quests hints infos
											elseif visibility == QUEST_STEP_VISIBILITY_HIDDEN then
												if FCMQT.DEBUG == 1 then d("Cond Added1 vis=2 -- Hidden ") end
												if isComplete ~= true then mytype = 9 else mytype = 10 end
											end
											if visibility == QUEST_STEP_VISIBILITY_OPTIONAL or visibility == QUEST_STEP_VISIBILITY_HINT or visibility == QUEST_STEP_VISIBILITY_HIDDEN then
												if not FCMQT.QuestList[FCMQT.varnumquest].step[k] then
													FCMQT.QuestList[FCMQT.varnumquest].step[k] = {}
												end
												checkstep = qstep
												table.insert(condcheck2, qstep)
												FCMQT.QuestList[FCMQT.varnumquest].step[k].text = qstep
												FCMQT.QuestList[FCMQT.varnumquest].step[k].mytype = mytype
												-- DEBUG1 Start
												if FCMQT.DEBUG == 1 then 
													d("Cond/Step Added "..k.." Visibility: "..visibility.."  mytype "..mytype)
													d("Cond/Step "..qstep)
												end
												-- DEBUG1 End
												k = k + 1
											end
											if FCMQT.DEBUG == 1 and visibility == nil then d("Cond/Step Visibility is nil") end
										end
										if isComplete ~= true then
											if FCMQT.DEBUG == 1 then d("Cond num : "..k.." -> Cond : "..conditionText.." / "..current.." / "..max) end
											if visibility == QUEST_STEP_VISIBILITY_OPTIONAL then
												mytype = 5
												if FCMQT.DEBUG == 1 then d("Cond Added vis=1 -- Optional -- myType = "..mytype) end
											elseif visibility == QUEST_STEP_VISIBILITY_HINT then
												mytype = 7
												if FCMQT.DEBUG == 1 then d("Cond Added vis=0 -- Hint -- mytype - "..mytype) end
											elseif visibility ==QUEST_STEP_VISIBILITY_HIDDEN then
												mytype = 9
												if FCMQT.DEBUG == 1 then d("Cond Added vis=2 -- Hidden -- mytype - "..mytype) end
											else
												mytype = 1
												if FCMQT.DEBUG == 1 then d("Cond Added vis=nil -- Nil -- mytype - "..mytype) end
											end
											local conditionTextClean = conditionText:match("TRACKER GOAL TEXT*")
											local condcheckmulti = true
											for key,value in pairs(condcheck2) do
												if ((value == conditionText and visibility ~= nil) or (value:find(conditionText, 1, true) and visibility ~= nil) or stepType == 2) then
													condcheckmulti = false
												end
											end
											if conditionTextClean == nil and condcheckmulti == true then
												if not FCMQT.QuestList[FCMQT.varnumquest].step[k] then
													FCMQT.QuestList[FCMQT.varnumquest].step[k] = {}
												end
												table.insert(condcheck2, conditionText)
												FCMQT.QuestList[FCMQT.varnumquest].step[k].text = conditionText
												FCMQT.QuestList[FCMQT.varnumquest].step[k].mytype = mytype
												k = k + 1
											end
										else
											if FCMQT.DEBUG == 1 then d("Cond num : "..k.." -> Cond Complete : "..conditionText) end
											if visibility == QUEST_STEP_VISIBILITY_OPTIONAL then
												mytype = 6
												if FCMQT.DEBUG == 1 then d("Cond Complete Added vis=1 -- Optional -- mytype - "..mytype) end
											elseif visibility == QUEST_STEP_VISIBILITY_HINT then
												mytype = 8
												if FCMQT.DEBUG == 1 then d("Cond Complete Added vis=0 -- Hint -- mytype - "..mytype) end
											elseif visibility == QUEST_STEP_VISIBILITY_HIDDEN then
												mytype = 10
												if FCMQT.DEBUG == 1 then d("Cond Complete Added vis=2 -- Hidden -- mytype - "..mytype) end
											else
												mytype = 2
												if FCMQT.DEBUG == 1 then d("Cond Complete Added v=nil -- Nil -- mytype - "..mytype) end
											end
											local conditionTextClean = conditionText:match("TRACKER GOAL TEXT*")
											local condcheckmulti = true
											for key,value in pairs(condcheck2) do
												if ((value == conditionText and visibility ~= nil) or (value:find(conditionText, 1, true) and visibility ~= nil) or stepType == 2) then
													condcheckmulti = false
												end
											end
											if conditionTextClean == nil and condcheckmulti == true then
												if not FCMQT.QuestList[FCMQT.varnumquest].step[k] then
													FCMQT.QuestList[FCMQT.varnumquest].step[k] = {}
												end
												table.insert(condcheck2, conditionText)
												FCMQT.QuestList[FCMQT.varnumquest].step[k].text = conditionText
												FCMQT.QuestList[FCMQT.varnumquest].step[k].mytype = mytype
												k = k + 1
											end
										end
									end
								end
							end
						else
							if FCMQT.DEBUG == 1 then
								d("!!!BAD VIS!!!!!")
								d("Vis Not Valid Step"..idx.." type : "..stepType.." 1 AND 2 OR   over : "..trackerOverrideText.." / -> Step : "..qstep.."  Vis "..visibility)
							end
						end
					end
				end
			end
		if FCMQT.DEBUG == 1 then d("---STEP END idx ----------------------------------------") end
		FCMQT.varnumquest = FCMQT.varnumquest + 1
	end
end

function FCMQT.QuestsLoop()
	
	
	FCMQT.DisplayedQuests = {}
	local userCurrentZone = zo_strformat(SI_QUEST_JOURNAL_ZONE_FORMAT, GetUnitZone('player'))
	local currentMapZoneIdx = GetCurrentMapZoneIndex()
	local limitnbquests = FCMQT.GetNbQuests()
	local nbquests = GetNumJournalQuests()
	local showquests = MAX_JOURNAL_QUESTS
	local valcheck = 0
	local i = 0
	if limitnbquests < MAX_JOURNAL_QUESTS then
		showquests = limitnbquests
	end
	
	if FCMQT.SavedVars.ShowJournalInfosOption == true then
		FCMQT.boxinfos:SetFont(("%s|%s|%s"):format(LMP:Fetch('font', FCMQT.SavedVars.ShowJournalInfosFont), FCMQT.SavedVars.ShowJournalInfosSize, FCMQT.SavedVars.ShowJournalInfosStyle))
		FCMQT.boxinfos:SetText(nbquests.."/"..MAX_JOURNAL_QUESTS)
		FCMQT.boxinfos:SetColor(FCMQT.SavedVars.ShowJournalInfosColor.r, FCMQT.SavedVars.ShowJournalInfosColor.g, FCMQT.SavedVars.ShowJournalInfosColor.b, FCMQT.SavedVars.ShowJournalInfosColor.a)
		FCMQT.boxinfos:SetHidden(false)
	else
		FCMQT.boxinfos:SetHidden(true)
	end
	-- Load qtTimerBox
	--if FCMQT.SavedVars.QuestsShowTimerOption == true then
	FCMQT.boxqtimer:SetFont(("%s|%s|%s"):format(LMP:Fetch('font', FCMQT.SavedVars.TimerTitleFont), FCMQT.SavedVars.TimerTitleSize, FCMQT.SavedVars.TimerTitleStyle))
	FCMQT.boxqtimer:SetText("Quest Time")
	FCMQT.boxqtimer:SetColor(FCMQT.SavedVars.TimerTitleColor.r, FCMQT.SavedVars.TimerTitleColor.g, FCMQT.SavedVars.TimerTitleColor.b, FCMQT.SavedVars.TimerTitleColor.a)
	if FCMQT.isTimedQuest == true and qindex == FCMQT.FocusedQIndex then
		FCMQT.boxqtimer:SetAlpha(1)
	else
		FCMQT.boxqtimer:SetAlpha(0)
	end
	--end
	FCMQT.FindFocusedQuest()
	if FCMQT.DEBUG == 2 then d("**Timer** Find Focused Quest "..FCMQT.FocusedQIndex) end
	for i=1, MAX_JOURNAL_QUESTS do
		if IsValidQuestIndex(i) then
			FCMQT.LoadQuestsInfo(i)
		end
	end

	-- Sort by zone, name & level
	local order = FCMQT.SavedVars.SortOrder
	--local order = "Name"
	if order == "Zone+Name"  and FCMQT.QuestsAreaOption == true then
		table.sort(FCMQT.QuestList, function(a,b)
			if (a.myzone < b.myzone) then
				return true
			elseif (a.myzone > b.myzone) then
				return false
			else
				if (a.name < b.name) then
					return true
				elseif (a.name > b.name) then
					return false
				end
			end
		end)
	end
	--local RecordedFocusedQuest = GetTrackedIsAssisted(1,FCMQT.currenticon,0)
	if order == "Focused+Zone+Name" and FCMQT.QuestsAreaOption == true then
		table.sort(FCMQT.QuestList, function(a,b)
			if (a.focusquest > b.focusquest) then
				return true
			elseif (a.focusquest < b.focusquest) then
				return false
			else
				if (a.focusedzoneval > b.focusedzoneval) then
					return true
				elseif (a.focusedzoneval < b.focusedzoneval) then
					return false
				else
					if (a.myzone < b.myzone) then
						return true
					elseif (a.myzone > b.myzone) then
						return false
					else
						if (a.name < b.name) then
							return true
						elseif (a.name > b.name) then
							return false
						end
					end
				end
			end
		end)
	end--
	if order == "Focused+Zone+Name"  and FCMQT.QuestsAreaOption == false then
		table.sort(FCMQT.QuestList, function(a,b)
			if (a.focusquest > b.focusquest) then
				return true
			elseif (a.focusquest < b.focusquest) then
				return false
			else
				if (a.name < b.name) then
					return true
				elseif (a.name > b.name) then
					return false
				end
			end
		end)
	end
	if order == "Zone+Name" and FCMQT.QuestsAreaOption == false then
			table.sort(FCMQT.QuestList, function(a,b)
			if (a.name < b.name) then
				return true
			elseif (a.name > b.name) then
				return false
			end
		end)
	end
	

	if showquests == 1 then
		FCMQT.filterzone = {}
		for j,v in pairs(FCMQT.QuestList) do
			local valQindex = GetTrackedIsAssisted(1,v.index,0)
			if valQindex == true then
				table.insert(FCMQT.DisplayedQuests, v)
			end
			valcheck = FCMQT.CheckQuestsToHidden(v.index, v.name, v.type, v.zoneidx, valcheck)
		end
	--elseif FCMQT.QuestsHybridOption == true and FCMQT.QuestsAreaOption == true then	
	--		-- Filters
	--	local myQuestsTypesList = { QUEST_TYPE_NONE, QUEST_TYPE_CLASS, QUEST_TYPE_CRAFTING, QUEST_TYPE_GUILD, QUEST_TYPE_MAIN_STORY, QUEST_TYPE_GROUP, QUEST_TYPE_DUNGEON, QUEST_TYPE_RAID, QUEST_TYPE_AVA, QUEST_TYPE_QA_TEST, QUEST_TYPE_AVA_GROUP, QUEST_TYPE_AVA_GRAND, QUEST_TYPE_HOLIDAY_EVENT, QUEST_TYPE_BATTLEGROUND }
	--	for i, valTypesList in pairs(myQuestsTypesList) do
	--		for j,v in pairs(FCMQT.QuestList) do
	--			if v.type == valTypesList then
	--				if FCMQT.SavedVars.QuestsZoneOption == true then
	--					if IsJournalQuestInCurrentMapZone(v.index) or currentMapZoneIdx == v.zoneidx or userCurrentZone == v.zone then
	--						if ((FCMQT.SavedVars.QuestsZoneGuildOption == true and v.type == 3) or (FCMQT.SavedVars.QuestsZoneMainOption == true and v.type == 2) or (FCMQT.SavedVars.QuestsZoneCyrodiilOption == true and v.zoneidx == FCMQT.CyrodiilNumZoneIndex)) then
	--							table.insert(FCMQT.DisplayedQuests, v)
	--						elseif (v.type ~= QUEST_TYPE_MAIN_STORY and v.type ~= QUEST_TYPE_GUILD and v.zoneidx ~= FCMQT.CyrodiilNumZoneIndex) then
	--							table.insert(FCMQT.DisplayedQuests, v)
	--						end
	--					end
	--				else
	--					if ((FCMQT.SavedVars.QuestsZoneGuildOption == true and v.type == QUEST_TYPE_GUILD) or (FCMQT.SavedVars.QuestsZoneMainOption == true and v.type == QUEST_TYPE_MAIN_STORY) or (FCMQT.SavedVars.QuestsZoneCyrodiilOption == true and v.zoneidx == FCMQT.CyrodiilNumZoneIndex)) then
	--						table.insert(FCMQT.DisplayedQuests, v)
	--					elseif (v.type ~= QUEST_TYPE_MAIN_STORY and v.type ~= QUEST_TYPE_GUILD and v.zoneidx ~= FCMQT.CyrodiilNumZoneIndex) then
	--						table.insert(FCMQT.DisplayedQuests, v)
	--					end
	--				end
	--				valcheck = FCMQT.CheckQuestsToHidden(v.index, v.name, v.type, v.zoneidx, valcheck)
	--			end
	--		end
	--	end
	else
		for j,v in pairs(FCMQT.QuestList) do
			-- it works just not sure how to use it
			--if IsJournalQuestInCurrentMapZone(v.index) == true then table.insert(FCMQT.DisplayedQuests, v) end
			local isOk = true
			if FCMQT.SavedVars.QuestsZoneOption == true then
				if IsJournalQuestInCurrentMapZone(v.index) or currentMapZoneIdx == v.zoneidx or userCurrentZone == v.zone then
					isOk = true
				else
					isOk = false
				end
			end
			if FCMQT.SavedVars.QuestsZoneMainOption == false and v.type == QUEST_TYPE_MAIN_STORY then isOk = false end
			if FCMQT.SavedVars.QuestsZoneGuildOption == false and v.type == QUEST_TYPE_GUILD then isOk = false end
			if FCMQT.SavedVars.QuestsZoneCyrodiilOption == false and v.zoneidx == FCMQT.CyrodiilNumZoneIndex then isOk = false end
			if FCMQT.SavedVars.QuestsZoneClassOption == false and v.type == QUEST_TYPE_CLASS then isOk = false end
			if FCMQT.SavedVars.QuestsZoneCrafingOption == false and v.type == QUEST_TYPE_CRAFTING then isOk = false end
			if FCMQT.SavedVars.QuestsZoneGroupOption == false and v.type == QUEST_TYPE_GROUP then isOk = false end
			if FCMQT.SavedVars.QuestsZoneCrafingOption == false and v.type == QUEST_TYPE_CRAFTING then isOk = false end
			if FCMQT.SavedVars.QuestsZoneDungeonOption == false and v.type == QUEST_TYPE_DUNGEON then isOk = false end
			if FCMQT.SavedVars.QuestsZoneAVAOption == false then
				if v.type == QUEST_TYPE_AVA then isOk = false end
				if v.type == QUEST_TYPE_AVA_GRAND then isOk = false end
				if v.type == QUEST_TYPE_AVA_GROUP then isOk = false end
			end
			if FCMQT.SavedVars.QuestsZoneEventOption == false and v.type == QUEST_TYPE_HOLIDAY_EVENT then isOk = false end
			if FCMQT.SavedVars.QuestsZoneBGOption == false and v.type == QUEST_TYPE_BATTLEGROUND then isOk = false end
			if isOk == true then table.insert(FCMQT.DisplayedQuests, v)end
			valcheck = FCMQT.CheckQuestsToHidden(v.index, v.name, v.type, v.zoneidx, valcheck)
		end
	end	
	-- Display
	FCMQT.zonename = ""
	FCMQT.zonetype = ""
	FCMQT.filterzonedyn = ""
	-- Zone for current focused quest
	for j,v in pairs(FCMQT.DisplayedQuests) do
		local valQindex = GetTrackedIsAssisted(1,v.index,0)
		if valQindex == true then
			FCMQT.filterzonedyn = v.zone
		end
	end	
	--
	for x,z in pairs(FCMQT.DisplayedQuests) do
		local myzone = z.myzone
		--[[if FCMQT.QuestsHybridOption == true and FCMQT.QuestsAreaOption == true then
			if z.type == QUEST_TYPE_AVA or z.type == QUEST_TYPE_AVA_GRAND or z.type == QUEST_TYPE_AVA_GROUP then
				myzone = myzone.." (AvA)"
			elseif z.type == QUEST_TYPE_GUILD then
				myzone = FCMQT.mylanguage.lang_tracker_type_guild
			elseif z.type == QUEST_TYPE_MAIN_STORY then
				myzone = FCMQT.mylanguage.lang_tracker_type_mainstory
			elseif z.type == QUEST_TYPE_CLASS and FCMQT.SavedVars.QuestsCategoryClassOption == true then
				myzone = FCMQT.mylanguage.lang_tracker_type_class.." - "..myzone
			elseif z.type == QUEST_TYPE_CLASS and FCMQT.SavedVars.QuestsCategoryClassOption == false then
				myzone = FCMQT.mylanguage.lang_tracker_type_class
			elseif z.type == QUEST_TYPE_CRAFTING and FCMQT.SavedVars.QuestsCategoryCraftOption == true then
				myzone = FCMQT.mylanguage.lang_tracker_type_craft.." - "..myzone
			elseif z.type == QUEST_TYPE_CRAFTING and FCMQT.SavedVars.QuestsCategoryCraftOption == false then
				myzone = FCMQT.mylanguage.lang_tracker_type_craft
			elseif z.type == QUEST_TYPE_GROUP and FCMQT.SavedVars.QuestsCategoryGroupOption == true then
				myzone = FCMQT.mylanguage.lang_tracker_type_group.." - "..myzone
			elseif z.type == QUEST_TYPE_GROUP and FCMQT.SavedVars.QuestsCategoryGroupOption == false then
				myzone = FCMQT.mylanguage.lang_tracker_type_group
			elseif z.type == QUEST_TYPE_DUNGEON and FCMQT.SavedVars.QuestsCategoryDungeonOption == true then
				myzone = FCMQT.mylanguage.lang_tracker_type_dungeon.." - "..myzone
			elseif z.type == QUEST_TYPE_DUNGEON and FCMQT.SavedVars.QuestsCategoryDungeonOption == false then
				myzone = FCMQT.mylanguage.lang_tracker_type_dungeon
			elseif z.type == QUEST_TYPE_RAID and FCMQT.SavedVars.QuestsCategoryRaidOption == true then
				myzone = FCMQT.mylanguage.lang_tracker_type_raid.." - "..myzone
			elseif z.type == QUEST_TYPE_RAID and FCMQT.SavedVars.QuestsCategoryRaidOption == false then
				myzone = FCMQT.mylanguage.lang_tracker_type_raid.." - "..myzone
			elseif z.type == QUEST_TYPE_BATTLEGROUND then
				myzone = FCMQT.mylanguage.lang_tracker_type_bg.." - "..myzone
			elseif z.type == QUEST_TYPE_HOLIDAY_EVENT then
				myzone = FCMQT.mylanguage.lang_tracker_type_holiday_event.." - "..myzone
			elseif z.type == QUEST_TYPE_QA_TEST then
				myzone = myzone.." (TEST)"
			end
		end]]
		
		--if (FCMQT.QuestsAreaOption == true and (FCMQT.zonename ~= z.myzone or FCMQT.zonetype ~= z.type)) then		
		--if FCMQT.DEBUG == 2 then d("quest "..z.name.."   myzone "..myzone) end
		if FCMQT.QuestsAreaOption == true and FCMQT.zonename ~= z.myzone then		
		--if FCMQT.QuestsAreaOption == true then
			FCMQT.AddNewUIBox()
			FCMQT.box[FCMQT.boxmarker]:SetDimensionConstraints(FCMQT.SavedVars.BgWidth,-1,FCMQT.SavedVars.BgWidth,-1)
			FCMQT.icon[FCMQT.boxmarker]:SetHidden(true)
			FCMQT.textbox[FCMQT.boxmarker]:SetDimensionConstraints(FCMQT.SavedVars.BgWidth-FCMQT.SavedVars.QuestsAreaPadding,-1,FCMQT.SavedVars.BgWidth-FCMQT.SavedVars.QuestsAreaPadding,-1)
			FCMQT.textbox[FCMQT.boxmarker]:SetFont(("%s|%s|%s"):format(LMP:Fetch('font', FCMQT.SavedVars.QuestsAreaFont), FCMQT.SavedVars.QuestsAreaSize, FCMQT.SavedVars.QuestsAreaStyle))
			--
			--
			FCMQT.textbox[FCMQT.boxmarker]:SetText(z.myzone)
			FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.QuestsAreaColor.r, FCMQT.SavedVars.QuestsAreaColor.g, FCMQT.SavedVars.QuestsAreaColor.b, FCMQT.SavedVars.QuestsAreaColor.a)
			FCMQT.currentAreaBox = FCMQT.boxmarker
			if FCMQT.QuestsNoFocusOption == false then
				FCMQT.box[FCMQT.currentAreaBox]:SetAlpha(1)
			else
				if FCMQT.FocusedQuestAreaNoTrans == true and myzone == FCMQT.FocusedZone then
					FCMQT.box[FCMQT.currentAreaBox]:SetAlpha(1)
				else
					FCMQT.box[FCMQT.currentAreaBox]:SetAlpha(FCMQT.SavedVars.QuestsNoFocusTransparency/100)
				end
			end	
			if FCMQT.SavedVars.PositionLockOption == true then
				if not FCMQT.textbox[FCMQT.boxmarker]:IsMouseEnabled() then
					FCMQT.textbox[FCMQT.boxmarker]:SetMouseEnabled(true)
				end
				FCMQT.textbox[FCMQT.boxmarker]:SetHandler("OnMouseDown", function(self, click)
					FCMQT.MouseTitleController(click, myzone)
				end)
			else
				if FCMQT.textbox[FCMQT.boxmarker]:IsMouseEnabled() then
					FCMQT.textbox[FCMQT.boxmarker]:SetMouseEnabled(false)
				end
				FCMQT.textbox[FCMQT.boxmarker]:SetHandler()
			end
			FCMQT.boxmarker = FCMQT.boxmarker + 1
			FCMQT.zonename = z.myzone
			--FCMQT.zonetype = z.type
		end
		if  FCMQT.limitnumquest <= showquests then
			local checkfilter = 1
			
			if FCMQT.QuestsHideZoneOption == true then
				if FCMQT.filterzonedyn == z.zone then
					FCMQT.AddNewTitle(z.index, z.level, z.name, z.type, z.zone, z.focusedzoneval)
					--- hidobj
					local FocusedQuest = GetTrackedIsAssisted(1,z.index,0)
					if FCMQT.HideObjHintsNotFocused == false or FocusedQuest == true then
						local k=1
						while z.step[k] do
							if z.step[k].text ~= "" then
								FCMQT.CheckContent(z.index, k, z.step[k].text, z.step[k].mytype, z.zone, z.focusedzoneval)
							end
							k=k+1
						end
					end
					FCMQT.limitnumquest = FCMQT.limitnumquest + 1
				end
			elseif FCMQT.filterzone[checkfilter] then
				local checkzone = 0
				while FCMQT.filterzone[checkfilter] do
					if FCMQT.filterzone[checkfilter] == myzone then
						checkzone = 1
					end
					checkfilter = checkfilter + 1
				end
				if checkzone ~= 1 then
					FCMQT.AddNewTitle(z.index, z.level, z.name, z.type, z.zone, z.focusedzoneval)
					-- hidobj
					local FocusedQuest = GetTrackedIsAssisted(1,z.index,0)
					if FCMQT.HideObjHintsNotFocused == false or FocusedQuest == true then
						local k=1
						while z.step[k] do
							if z.step[k].text ~= "" then
								FCMQT.CheckContent(z.index, k, z.step[k].text, z.step[k].mytype, z.zone, z.focusedzoneval)
							end
							k=k+1
						end
					end
					FCMQT.limitnumquest = FCMQT.limitnumquest + 1
				end
			else
				FCMQT.AddNewTitle(z.index, z.level, z.name, z.type, z.zone, z.focusedzoneval)
				-- hidobj
				local FocusedQuest = GetTrackedIsAssisted(1,z.index,0)
				if FCMQT.HideObjHintsNotFocused == false or FocusedQuest == true  then
					local k=1
					while z.step[k] do
						if z.step[k].text ~= "" then
							FCMQT.CheckContent(z.index, k, z.step[k].text, z.step[k].mytype, z.zone, z.focusedzoneval)
						end
						k=k+1
					end
				end
				FCMQT.limitnumquest = FCMQT.limitnumquest + 1			
			end
		end
	end
	
	if FCMQT.box[FCMQT.currentAssistedArea] then
		FCMQT.box[FCMQT.currentAssistedArea]:SetAlpha(1)
	end
	
	-- Update Journal and tracker
	if valcheck == 1 then
		-- Compass Update For 10023
		FOCUSED_QUEST_TRACKER:InitialTrackingUpdate()
		local noUpdate = false
		if BUI then noUpdate = true end
		if noUpdate == false then
			--WorldMap / Minimap Update)
			ZO_WorldMap_UpdateMap()
		end

	end
end


function FCMQT.QuestsListUpdate(eventCode)
	if (FCMQT.SavedVars and FCMQT.SavedVars.BgOption ~= nil and eventCode ~= nil) then
		-- TESTS --
		if FCMQT.DEBUG == 1 then
			local userCurrentZone = GetUnitZone('player')
			local currentMapIdx = GetCurrentMapIndex()
			local currentMapZoneIdx = GetCurrentMapZoneIndex()
			local qzone, qobjective, qzoneidx, poiIndex = GetJournalQuestLocationInfo(i)
			local qsubzoneidx, qsubzonepoi = GetCurrentSubZonePOIIndices()
			qsubzoneidx = tostring(qsubzoneidx)
			qsubzonepoi = tostring(qsubzonepoi)
			currentMapIdx = tostring(currentMapIdx)
			currentMapZoneIdx = tostring(currentMapZoneIdx)
			d("--MAP INFOS--")
			d("userCurrentZone : "..userCurrentZone)
			d("currentMapIdx : "..currentMapIdx.." currentMapZoneIdx : "..currentMapZoneIdx)
			d("qsubzoneidx : "..qsubzoneidx.." qsubzonepoi : "..qsubzonepoi)
			d("-------------")
		end
		--d(eventCode)
		FCMQT.QuestList = {}
		FCMQT.currentAreaBox = 0
		FCMQT.currentAssistedArea = 0
		FCMQT.varnumquest = 1
		FCMQT.limitnumquest = 1
		FCMQT.boxmarker = 1
		if FCMQT.SavedVars.QuestsFilter then
			FCMQT.filterzone = FCMQT.SavedVars.QuestsFilter
		elseif not FCMQT.filterzone then
			FCMQT.filterzone = {}
		end		
		-- List All Quests		
		FCMQT.QuestsLoop()
		
		-- Clear the other created boxes
		FCMQT.ClearBoxs(FCMQT.boxmarker)
	end
end


----------------------------------
--          Start & Menu
----------------------------------
function FCMQT.Init(eventCode, addOnName)

	if addOnName == "FCMQT" then
		-- Create & load defaults vars
		FCMQT.box = {}
		FCMQT.icon = {}
		FCMQT.textbox = {}
		FCMQT.currenticon = nil
		if not FCMQT.SavedVars then
			FCMQT.SavedVars = ZO_SavedVars:NewAccountWide("FCMQTSavedVars", 5, nil, FCMQT.defaults) or FCMQT.defaults
		end
		
		-- Create the UI boxes
		-- Main Box
		FCMQT.main = WM:CreateTopLevelWindow(nil)
		FCMQT.main:ClearAnchors()
		FCMQT.main:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 200, 200)
		FCMQT.main:SetDimensions(300,40)
		FCMQT.main:SetDrawLayer(1)
		FCMQT.main:SetResizeToFitDescendents(true)
		FCMQT.main:SetAlpha(FCMQT.SavedVars.BgAlpha/100)
		
		-- Load User Main Box position
		if FCMQT.SavedVars.position ~= nil then
			FCMQT.main:ClearAnchors()
			FCMQT.main:SetAnchor(FCMQT.SavedVars.position.point, GuiRoot, FCMQT.SavedVars.position.relativePoint, FCMQT.SavedVars.position.offsetX, FCMQT.SavedVars.position.offsetY)
		end
		
		if FCMQT.SavedVars.PositionLockOption == true then
			FCMQT.main:SetMouseEnabled(false)
			FCMQT.main:SetMovable(false)
		else
			FCMQT.main:SetMouseEnabled(true)
			FCMQT.main:SetMovable(true)
		end

		-- Trigger to Backup Main Box position & refresh main anchor
		FCMQT.main:SetHandler("OnMouseUp", function(self) 
			FCMQT.SavedVars.position.offsetX = FCMQT.main:GetLeft()
			FCMQT.SavedVars.position.offsetY = FCMQT.main:GetTop()
			FCMQT.main:ClearAnchors()
			FCMQT.main:SetAnchor(FCMQT.SavedVars.position.point, GuiRoot, FCMQT.SavedVars.position.relativePoint, FCMQT.SavedVars.position.offsetX, FCMQT.SavedVars.position.offsetY)
		end)

		-- Main Background
		FCMQT.bg = WM:CreateControl(nil, FCMQT.main, CT_STATUSBAR)
		FCMQT.bg:ClearAnchors()
		FCMQT.bg:SetAnchor(TOPLEFT, FCMQT.main, TOPLEFT, 0, 0)
		FCMQT.bg:SetDimensions(300,40)
		FCMQT.bg:SetDrawLayer(1)
		FCMQT.bg:SetResizeToFitDescendents(true)
		FCMQT.bg:SetDimensionConstraints(FCMQT.SavedVars.BgWidth,-1,FCMQT.SavedVars.BgWidth,-1)
		-- Journal Infos
		FCMQT.boxinfos = WM:CreateControl(nil, FCMQT.bg , CT_LABEL)
		FCMQT.boxinfos:ClearAnchors()
		FCMQT.boxinfos:SetAnchor(TOPRIGHT,FCMQT.bg,TOPRIGHT,-5,0)
		FCMQT.boxinfos:SetDimensions(40,40)
		FCMQT.boxinfos:SetDrawLayer(4)
		FCMQT.boxinfos:SetResizeToFitDescendents(true)
		FCMQT.boxinfos:SetMouseEnabled(true)
		FCMQT.boxinfos:SetHandler("OnMouseDown", function(self, button)
			if  button == 1 or button == 2 or button == 3 then
				FCMQT.SwitchDisplayMode()
			end
		end)
		-- Quest Timer Box
		FCMQT.boxqtimer = WM:CreateControl(nil, FCMQT.bg , CT_LABEL)
		FCMQT.boxqtimer:ClearAnchors()
		FCMQT.boxqtimer:SetAnchor(TOPLEFT,FCMQT.bg,TOPLEFT,0,0)
		FCMQT.boxqtimer:SetDimensions(100,40)
		FCMQT.boxqtimer:SetDimensionConstraints(FCMQT.SavedVars.BgWidth,-1,FCMQT.SavedVars.BgWidth,-1)
		FCMQT.boxqtimer:SetDrawLayer(1)
		FCMQT.boxqtimer:SetResizeToFitDescendents(true)
		--FCMQT.boxqtimer:SetMouseEnabled(true)
		--FCMQT.boxqtimer:SetHandler("OnMouseDown", function(self, button)
		--	if  button == 1 or button == 2 or button == 3 then
		--		FCMQT.SwitchDisplayMode()
		--	end
		--end)

		

		if FCMQT.SavedVars.BgOption == true then
			FCMQT.bg:SetColor(FCMQT.SavedVars.BgColor.r,FCMQT.SavedVars.BgColor.g,FCMQT.SavedVars.BgColor.b,FCMQT.SavedVars.BgColor.a)
		--elseif FCMQT.SavedVars.BgGradientOption == true then
			-- FCMQT.bg:SetGradientColors(FCMQT.SavedVars.BgColor.r,FCMQT.SavedVars.BgColor.g,FCMQT.SavedVars.BgColor.b,FCMQT.SavedVars.BgColor.a,0,0,0,0)
		else
			FCMQT.bg:SetColor(0,0,0,0)
		end

		FCMQT.mylanguage = {}

		if FCMQT.SavedVars.Language == "Français" then
			FCMQT.mylanguage = FCMQT.language.fr
		elseif FCMQT.SavedVars.Language == "Deutsch" then
			FCMQT.mylanguage = FCMQT.language.de
		else
			FCMQT.mylanguage = FCMQT.language.us
		end
		--actionList = FCMQT.mylanguage.actionList
		
		CreateSettings()
		if FCMQT.SavedVars.ShowQuestTimer == true then FCMQT.HideQuestTimer() end
		
		-- First Init
		FCMQT.QuestsListUpdate(1)
		
		-- Set vars for keybinds
		FCMQT.LoadKeybindInfo()
		
		-- UPDATES with EVENTS				
		EM:RegisterForEvent("FCMQT", EVENT_PLAYER_ACTIVATED, FCMQT.QuestsListUpdate) --> EC:131072 Update after zoning
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_REMOVED, FCMQT.QuestsListUpdate) --> EC:131091 delete quest
		EM:RegisterForEvent("FCMQT", EVENT_LEVEL_UPDATE, FCMQT.QuestsListUpdate) --> Update when level up
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_ADVANCED, FCMQT.QuestsListUpdate) --> EC:131090
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_OPTIONAL_STEP_ADVANCED, FCMQT.QuestsListUpdate)		
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_ADDED, function(eventCode, qindex, qname, qstep)
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_TIMER_UPDATED, FCMQT.QuestsListUpdate)
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_TIMER_PAUSED, FCMQT.QuestsListUpdate)
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_LIST_UPDATED, FCMQT.QuestsListUpdate)
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_CONDITION_COUNTER_CHANGED, FCMQT.QuestsListUpdate)
			-- Auto Share Quests
			local PlayerIsGrouped = IsUnitGrouped('player')
			if PlayerIsGrouped and FCMQT.SavedVars.AutoShare == true and qindex ~= nil then
				if GetIsQuestSharable(qindex) then
					ShareQuest(qindex)
					d(FCMQT.mylanguage.lang_console_autoshare.." : "..qname)
				end
			end			
			-- Auto Focus
			FCMQT.SetFocusedQuest(qindex)
		end) --> EC:131078 add quest
		
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_CONDITION_COUNTER_CHANGED, function(eventCode, qindex) FCMQT.SetFocusedQuest(qindex) end)
		


		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_POSITION_REQUEST_COMPLETE, CheckEventFCMQT) -- EC:131100
		--EM:RegisterForEvent("FCMQT", EVENT_TRACKING_UPDATE, CheckEventFCMQT)

		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_LIST_UPDATED, FCMQT.QuestsListUpdate)
		--EM:RegisterForEvent("FCMQT", EVENT_OBJECTIVES_UPDATED, FCMQT.QuestsListUpdate) --> why EC:131208 ???
		--EM:RegisterForEvent("FCMQT", EVENT_OBJECTIVE_COMPLETED, FCMQT.QuestsListUpdate)

		--EM:RegisterForEvent("FCMQT", EVENT_ACTIVE_QUEST_TOOL_CHANGED, FCMQT.QuestsListUpdate)
		--EM:RegisterForEvent("FCMQT", EVENT_ACTIVE_QUEST_TOOL_CLEARED, FCMQT.QuestsListUpdate)
		
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_TOOL_UPDATED, FCMQT.QuestsListUpdate) 
		
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_SHARE_UPDATE, FCMQT.QuestsListUpdate)
		
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_SHOW_JOURNAL_ENTRY, FCMQT.QuestsListUpdate)
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_TIMER_PAUSED, FCMQT.QuestsListUpdate)
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_TIMER_UPDATED, FCMQT.QuestsListUpdate)
		--EM:RegisterForEvent("FCMQT", EVENT_MOUSE_REQUEST_ABANDON_QUEST, FCMQT.QuestsListUpdate)
		
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_COMPLETE_DIALOG, FCMQT.QuestsListUpdate) --> API:131091
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_COMPLETE_EXPERIENCE, FCMQT.QuestsListUpdate)		
		
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_OFFERED, FCMQT.QuestsListUpdate)
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_SHARED, FCMQT.QuestsListUpdate)
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_SHARE_REMOVED, FCMQT.QuestsListUpdate)
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_LOG_IS_FULL, FCMQT.QuestsListUpdate)
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_COMPLETE_ATTEMPT_FAILED_INVENTORY_FULL, FCMQT.QuestsListUpdate)
		--EM:RegisterForEvent("FCMQT", EVENT_QUEST_CONDITION_COUNTER_CHANGED, FCMQT.QuestsListUpdate)
		--EVENT_QUEST_ADDED = 131079
		--EVENT_QUEST_ADVANCED = 131090
		--EVENT_QUEST_COMPLETE = 131093
		--EVENT_QUEST_COMPLETE_ATTEMPT_FAILED_INVENTORY_FULL = 131094
		--EVENT_QUEST_COMPLETE_DIALOG = 131089
		--EVENT_QUEST_CONDITION_COUNTER_CHANGED = 131085
		--EVENT_QUEST_LIST_UPDATED = 131083
		--EVENT_QUEST_LOG_IS_FULL = 131084
		--EVENT_QUEST_OFFERED = 131080
		--EVENT_QUEST_OPTIONAL_STEP_ADVANCED = 131091
		--EVENT_QUEST_POSITION_REQUEST_COMPLETE = 131100
		--EVENT_QUEST_REMOVED = 131092
		--EVENT_QUEST_SHARED = 131081
		--EVENT_QUEST_SHARE_REMOVED = 131082
		--EVENT_QUEST_SHOW_JOURNAL_ENTRY = 131097
		--EVENT_QUEST_TIMER_PAUSED = 131087
		--EVENT_QUEST_TIMER_UPDATED = 131088
		--EVENT_QUEST_TOOL_UPDATED = 131086
		
		
		
		
	else
		return;
	end
	--EVENT_MANAGER:UnregisterForEvent("FCMQT", EVENT_ADD_ON_LOADED)
end

-- Load only when game start or /reloadui
EM:RegisterForEvent("FCMQT", EVENT_ADD_ON_LOADED, FCMQT.Init)

EM:RegisterForUpdate("FCMQT", 25, function()
	FCMQT.CheckMode()
	FCMQT.CheckFocusedQuest()
	--FCMQT.LoadKeybindInfo()
end)



