-- Name    : Fully Customizable MultiQuests Tracker (FCMQT)
-- Author  : DesertDwellers Original Coding by Black Storm
-- Version : 0.95.b15
-- Date    : 2017/09/01
FCMQT = FCMQT or {}

-- Load libraries
local LAM = LibStub("LibAddonMenu-2.0")
local LMP = LibStub("LibMediaProvider-1.0")
local WM = WINDOW_MANAGER
local EM = EVENT_MANAGER
local QUEST_TIMER_TEXT_COLOR = "#ffaf61"
local QUEST_TIMER_TEXT = ""

LMP:Register("font", "ESO Standard Font", "EsoUI/Common/Fonts/univers57.otf")
LMP:Register("font", "ESO Book Font", "EsoUI/Common/Fonts/ProseAntiquePSMT.otf")
-- LMP:Register("font", "ESO Handwritten Font"] = "EsoUI/Common/Fonts/Handwritten_Bold.otf" -- Too hard to read.
LMP:Register("font", "ESO Tablet Font", "EsoUI/Common/Fonts/TrajanPro-Regular.otf")
-- LMP:Register("font", "ESO Gamepad Font"] = "EsoUI/Common/Fonts/FuturaStd-Condensed.otf"  -- Too hard to read.


----------------------------------
--  Save & Load User Variables
----------------------------------
-- Init defaults vars
FCMQT.DEBUG = 0
FCMQT.DEBUGUI = 0
SLASH_COMMANDS["/fcmqt_debug"] = FCMQT.CMD_DEBUG
SLASH_COMMANDS["/fcmqt_debugui"] = FCMQT.CMD_DEBUGUI
--local fontList = LMP:List('font')
--local langList = {"English", "Français", "Deutsch"}
--local fontStyles = {"normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline"}
--local iconList = {"Arrow ESO (Default)", "Icon Dragonknight", "Icon Nightblade", "Icon Sorcerer", "Icon Templar"}
--local actionList = {"None", "Change Assisted Quest", "Filter by Current Zone", "Share a Quest", "Show on Map", "Remove a Quest"}
--local sortList = {"Zone+Name"}
--local DirectionList = {"TOP", "BOTTOM"}
--local presetList = {"Custom", "Default", "Preset1"}
FCMQT.CyrodiilNumZoneIndex = 37
--FCMQT.FocusedZone = nil

-- Build and structure the box
function FCMQT.AddNewTitle(qindex, qlevel, qname, qtype, qzone, qfocusedzoneval)
	if FCMQT.DEBUG == 1 then d("*** ADD NEW TITLE qzone "..qzone.." qfocusedzoneval  "..qfocusedzoneval) end
	-- Generate a new box if not exist one
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
			FCMQT.box[FCMQT.boxmarker]:SetAnchor(TOPLEFT, FCMQT.bg, TOPLEFT, 0, 0)
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
--b15		if FCMQT.SavedVars.QuestsNoFocusOption == true then
--b15			FCMQT.box[FCMQT.boxmarker]:SetAlpha(FCMQT.SavedVars.QuestsNoFocusTransparency/100)
--b15		else
--b15			FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
--b15		end
		if FCMQT.SavedVars.QuestsNoFocusOption == false then
			FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
		else
			if FCMQT.SavedVars.FocusedQuestAreaNoTrans == true and qfocusedzoneval == 1 then
				FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
			else
				FCMQT.box[FCMQT.boxmarker]:SetAlpha(FCMQT.SavedVars.QuestsNoFocusTransparency/100)
			end
		end	
	end
	-- Set qname to add in quest type if selected
	-- sub first two lines with saved vars item
	if FCMQT.SavedVars.QuestsHybridOption == false or FCMQT.SavedVars.QuestsAreaOption == false then
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


	if FCMQT.SavedVars.QuestsShowTimerOption == true then
		-- With QUEST_TIMER
		FCMQT.textbox[FCMQT.boxmarker]:SetText(qname.."     "..QUEST_TIMER_TEXT.."")
		--FCMQT.textbox[FCMQT.boxmarker]:SetText("["..qlevel.."] - "..qname)
	else
		-- With QUEST_TIMER
		-- FCMQT.textbox[FCMQT.boxmarker]:SetText(qname.."     ["..QUEST_TIMER_TEXT.."]")
		FCMQT.textbox[FCMQT.boxmarker]:SetText(qname)
	end

	if FCMQT.DEBUGUI == 1 then d("Default Title") end
	FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TitleColor.r, FCMQT.SavedVars.TitleColor.g, FCMQT.SavedVars.TitleColor.b, FCMQT.SavedVars.TitleColor.a)
	--*ZL*-end`
	FCMQT.boxmarker = FCMQT.boxmarker + 1
end

function FCMQT.AddNewContent(qindex, qstep, qtext, mytype, qzone, qfocusedzoneval)
	local mytype = mytype
	-- Generate a new box if not exist one
	if not FCMQT.box[FCMQT.boxmarker] then
		local dir = FCMQT.SavedVars.DirectionBox
		local myboxdirection = BOTTOMLEFT
		if dir == "BOTTOM" then
			myboxdirection = BOTTOMLEFT
		elseif dir == "TOP" then
			myboxdirection = TOPLEFT
		end
		-- Create Contener Box
		FCMQT.box[FCMQT.boxmarker] = WM:CreateControl(nil, FCMQT.bg, CT_LABEL)
		FCMQT.box[FCMQT.boxmarker]:ClearAnchors()
		FCMQT.box[FCMQT.boxmarker]:SetAnchor(TOPLEFT,FCMQT.box[FCMQT.boxmarker-1],myboxdirection,0,0)
		FCMQT.box[FCMQT.boxmarker]:SetResizeToFitDescendents(true)
		-- Create Icon
		FCMQT.icon[FCMQT.boxmarker] = WM:CreateControl(nil, FCMQT.bg, CT_TEXTURE)
		FCMQT.icon[FCMQT.boxmarker]:ClearAnchors()
		FCMQT.icon[FCMQT.boxmarker]:SetAnchor(TOPRIGHT,FCMQT.box[FCMQT.boxmarker],TOPLEFT,0,0)
		FCMQT.icon[FCMQT.boxmarker]:SetDimensions(22,22)
		-- Create Text Box
		FCMQT.textbox[FCMQT.boxmarker] = WM:CreateControl(nil, FCMQT.box[FCMQT.boxmarker], CT_LABEL)
		FCMQT.textbox[FCMQT.boxmarker]:ClearAnchors()
		FCMQT.textbox[FCMQT.boxmarker]:SetAnchor(CENTER,FCMQT.box[FCMQT.boxmarker],CENTER,0,0)
	end
	
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
	
	if mytype == 2 then
		FCMQT.textbox[FCMQT.boxmarker]:SetText("*"..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextCompleteColor.r, FCMQT.SavedVars.TextCompleteColor.g, FCMQT.SavedVars.TextCompleteColor.b,FCMQT.SavedVars.TextCompleteColor.a)
	elseif mytype == 3 then
		if FCMQT.SavedVars.QuestsOptionalOption == false then
			FCMQT.textbox[FCMQT.boxmarker]:SetText(FCMQT.mylanguage.quest_optional.." : "..qtext)
			FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextOptionalColor.r, FCMQT.SavedVars.TextOptionalColor.g, FCMQT.SavedVars.TextOptionalColor.b, FCMQT.SavedVars.TextOptionalColor.a)
		end
	elseif mytype == 4 then
		if FCMQT.SavedVars.QuestsOptionalOption == false then
			FCMQT.textbox[FCMQT.boxmarker]:SetText(FCMQT.mylanguage.quest_optional.." : "..qtext)
			FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextOptionalCompleteColor.r, FCMQT.SavedVars.TextOptionalCompleteColor.g, FCMQT.SavedVars.TextOptionalCompleteColor.b, FCMQT.SavedVars.TextOptionalCompleteColor.a)
		end
	elseif mytype == 5 then
		FCMQT.textbox[FCMQT.boxmarker]:SetText("*"..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextOptionalColor.r, FCMQT.SavedVars.TextOptionalColor.g, FCMQT.SavedVars.TextOptionalColor.b, FCMQT.SavedVars.TextOptionalColor.a)
	elseif mytype == 6 then
		FCMQT.textbox[FCMQT.boxmarker]:SetText("*"..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextOptionalColor.r, FCMQT.SavedVars.TextOptionalColor.g, FCMQT.SavedVars.TextOptionalColor.b, FCMQT.SavedVars.TextOptionalColor.a)
	elseif mytype == 7 then
		if FCMQT.SavedVars.QuestsOptionalOption == false then
			FCMQT.textbox[FCMQT.boxmarker]:SetText(FCMQT.mylanguage.quest_hint.." : "..qtext)
			FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextOptionalColor.r, FCMQT.SavedVars.TextOptionalColor.g, FCMQT.SavedVars.TextOptionalColor.b, FCMQT.SavedVars.TextOptionalColor.a)
		end
	elseif mytype == 8 then
			--hideopt
		if FCMQT.SavedVars.QuestsHideObjOptional == false or FCMQT.SavedVars.QuestsOptionalOption == false then
			FCMQT.textbox[FCMQT.boxmarker]:SetText(FCMQT.mylanguage.quest_hint.." : "..qtext)
			FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextOptionalCompleteColor.r, FCMQT.SavedVars.TextOptionalCompleteColor.g, FCMQT.SavedVars.TextOptionalCompleteColor.b, FCMQT.SavedVars.TextOptionalCompleteColor.a)
		end
	elseif mytype == 9 then
		if FCMQT.SavedVars.QuestsOptionalOption == false then
			FCMQT.textbox[FCMQT.boxmarker]:SetText(FCMQT.mylanguage.quest_hiddenhint.." : "..qtext)
			FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextOptionalColor.r, FCMQT.SavedVars.TextOptionalColor.g, FCMQT.SavedVars.TextOptionalColor.b, FCMQT.SavedVars.TextOptionalColor.a)
		end
	elseif mytype == 10 then
		--hideopt
		if FCMQT.SavedVars.QuestsHideObjOptional == False or FCMQT.SavedVars.QuestsOptionalOption == false then
			FCMQT.textbox[FCMQT.boxmarker]:SetText(FCMQT.mylanguage.quest_hiddenhint.." : "..qtext)
			FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextOptionalCompleteColor.r, FCMQT.SavedVars.TextOptionalCompleteColor.g, FCMQT.SavedVars.TextOptionalCompleteColor.b, FCMQT.SavedVars.TextOptionalCompleteColor.a)
		end
	else
		FCMQT.textbox[FCMQT.boxmarker]:SetText("*"..qtext)
		FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.TextColor.r, FCMQT.SavedVars.TextColor.g, FCMQT.SavedVars.TextColor.b, FCMQT.SavedVars.TextColor.a)
	end
	
	local CurrentFocusedQuest = GetTrackedIsAssisted(1,qindex,0)
	if CurrentFocusedQuest == true then
		FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
	else
		if FCMQT.SavedVars.QuestsNoFocusOption == false then
			FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
		else
			if CurrentFocusedQuest == true then
				FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
			else
				if FCMQT.SavedVars.FocusedQuestAreaNoTrans == true and qfocusedzoneval == 1 then
					FCMQT.box[FCMQT.boxmarker]:SetAlpha(1)
				else
					FCMQT.box[FCMQT.boxmarker]:SetAlpha(FCMQT.SavedVars.QuestsNoFocusTransparency/100)
				end
			end
		end	
	end
	FCMQT.boxmarker = FCMQT.boxmarker + 1
end

----------------------------------
--            Refresh 
----------------------------------

function FCMQT.LoadQuestsInfo(i)
	local qname, backgroundText, activeStepText, activeStepType, activeStepTrackerOverrideText, completed, tracked, qlevel, pushed, qtype = GetJournalQuestInfo(i)
	if (qname ~= nil and #qname > 0) then
		local qzone, qobjective, qzoneidx, poiIndex = GetJournalQuestLocationInfo(i)
		--**de1** if FCMQT.DEBUG == 1 then d("|FF000000E########### "..qname) end
		--**de1** if FCMQT.DEBUG == 1 then d("ZoneIndex : "..qzoneidx.." / Zone : "..qzone) end
		-- if FCMQT.DEBUG == 1 then 
			--local currentmapidx = GetCurrentMapZoneIndex()
			--d("Player IDX Location: "..currentmapidx)
		--end		
		--**de1** if FCMQT.DEBUG == 1 and tracked == true then d("Is Tracked : True") end
		--**de1** if FCMQT.DEBUG == 1 then d("QType : "..qtype) end 
		
		
		--**de1** if FCMQT.DEBUG == 1 then d("backgroundText : "..backgroundText.." / activeStepText : "..activeStepText) end
		FCMQT.MyPlayerLevel = GetUnitLevel('player')
		FCMQT.MyPlayerVLevel = GetUnitVeteranRank('player')
		
		FCMQT.QuestList[FCMQT.varnumquest] = {}

		-- Collect infos for table sort
		qzone = #qzone > 0 and zo_strformat(SI_QUEST_JOURNAL_ZONE_FORMAT, qzone) or zo_strformat(SI_QUEST_JOURNAL_GENERAL_CATEGORY)
		--qzone = #qzone > 0 and zo_strformat(SI_QUEST_JOURNAL_ZONE_FORMAT, qzone)
		
		FCMQT.QuestList[FCMQT.varnumquest].index = i
		FCMQT.QuestList[FCMQT.varnumquest].zoneidx = qzoneidx or "nil"
		FCMQT.QuestList[FCMQT.varnumquest].zone = qzone
		FCMQT.QuestList[FCMQT.varnumquest].level = GetJournalQuestLevel(i)local CurrentFocusedQuest = GetTrackedIsAssisted(1,i,0)
		local qfocusquest = 0
		if CurrentFocusedQuest then qfocusquest = 1 end
		
		--**de1** if FCMQT.DEBUG == 1 then d("Focused Quest : "..qfocusquest) end
		FCMQT.QuestList[FCMQT.varnumquest].focusquest = qfocusquest
		FCMQT.QuestList[FCMQT.varnumquest].focusedzone = FCMQT.FocusedZone
		local qfocusedzoneval = 0
		if FCMQT.FocusedZone == qzone then qfocusedzoneval = 1 end
		FCMQT.QuestList[FCMQT.varnumquest].focusedzoneval = qfocusedzoneval
		if FCMQT.DEBUG == 1 then d("|*load info* found focused zone "..FCMQT.FocusedZone.." zone idx "..FCMQT.FocusedZoneIdx.."  zoneval "..qfocusedzoneval) end
		FCMQT.QuestList[FCMQT.varnumquest].name = qname
		FCMQT.QuestList[FCMQT.varnumquest].type = qtype
		FCMQT.QuestList[FCMQT.varnumquest].tracked = tracked
		FCMQT.QuestList[FCMQT.varnumquest].step = {}
		
		local k = 1
		local condcheck2 = {}
		local nbStep = GetJournalQuestNumSteps(i)
		--**de1** if FCMQT.DEBUG == 1 then d("qtype : "..qtype.." / ActiveStepType : "..activeStepType.. " / nbStep : "..nbStep) end
			for idx=1, nbStep do
				if activeStepType == 3 then
					local goal, dialog, confirmComplete, declineComplete, backgroundText, journalStepText = GetJournalQuestEnding(i)
					if (goal ~= nil and goal ~= "") then
						--**de1** if FCMQT.DEBUG == 1 then d("Step"..idx) end
						--**de1** if FCMQT.DEBUG == 1 then d(" -> Goal : "..goal) end
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
						--**de1** if FCMQT.DEBUG == 1 then d("Step"..idx.." type : "..stepType) end
						--**de1** if FCMQT.DEBUG == 1 then d("over : "..trackerOverrideText.." / -> Step : "..qstep) end
						if visibility == nil or visibility == QUEST_STEP_VISIBILITY_HINT or visibility == QUEST_STEP_VISIBILITY_OPTIONAL or visibility == QUEST_STEP_VISIBILITY_HIDDEN then
							if ((visibility == 0 or visibility == 1 or visibility == 2) and FCMQT.SavedVars.QuestsOptionalOption == false) then
								if visibility == nil or visibility == 1 then
									mytype = 3
								elseif visibility == 2 then
									mytype = 9
								else
									mytype = 7
								end
								if not FCMQT.QuestList[FCMQT.varnumquest].step[k] then
									FCMQT.QuestList[FCMQT.varnumquest].step[k] = {}
								end
								--**de1** if FCMQT.DEBUG == 1 then d("Step Added") end
								FCMQT.QuestList[FCMQT.varnumquest].step[k].text = qstep
								FCMQT.QuestList[FCMQT.varnumquest].step[k].mytype = mytype
								k = k + 1
							else
								local checkstep = ""
								--**de1** if FCMQT.DEBUG == 1 then d("numConditions : "..numConditions) end
								for m=1, numConditions do
									----**de1** if FCMQT.DEBUG == 1 then d("Step num : "..k) end
									local mytype = 1
									local conditionText, current, max, isFailCondition, isComplete, isCreditShared = GetJournalQuestConditionInfo(i, idx, m)
									if conditionText ~= nil and conditionText ~= "" then
										if activeStepType == 2 then
											if idx >= nbStep and idx > 1 then
												break;
											end
										end
										
										if checkstep ~= qstep then
											if visibility == 1 then
											-- Optional quests infos
												--**de1** if FCMQT.DEBUG == 1 then d("Cond Added1 v=1") end
												if isComplete ~= true then mytype = 3 else mytype = 4 end
											-- quests hints infos
											elseif visibility == 0 then
												--**de1** if FCMQT.DEBUG == 1 then d("Cond Added1 v=0") end
												if isComplete ~= true then mytype = 7 else mytype = 8 end
											-- hidden quests hints infos
											elseif visibility == 2 then
												--**de1** if FCMQT.DEBUG == 1 then d("Cond Added1 v=2") end
												if isComplete ~= true then mytype = 9 else mytype = 10 end
											end
											if visibility == 0 or visibility == 1 or visibility == 2 then
												if not FCMQT.QuestList[FCMQT.varnumquest].step[k] then
													FCMQT.QuestList[FCMQT.varnumquest].step[k] = {}
												end
												checkstep = qstep
												table.insert(condcheck2, qstep)
												FCMQT.QuestList[FCMQT.varnumquest].step[k].text = qstep
												FCMQT.QuestList[FCMQT.varnumquest].step[k].mytype = mytype
												k = k + 1
											end
										end
										if isComplete ~= true then
											--**de1** if FCMQT.DEBUG == 1 then d("Cond num : "..k) end
											--**de1** if FCMQT.DEBUG == 1 then d(" -> Cond : "..conditionText.." / "..current.." / "..max) end
											if visibility == 1 then
												--**de1** if FCMQT.DEBUG == 1 then d("Cond Added v=1") end
												mytype = 5
											elseif visibility == 0 then
												--**de1** if FCMQT.DEBUG == 1 then d("Cond Added v=0") end
												mytype = 7
											elseif visibility == 2 then
												--**de1** if FCMQT.DEBUG == 1 then d("Cond Added v=2") end
												mytype = 9
											else
												--**de1** if FCMQT.DEBUG == 1 then d("Cond Added v=nil") end
												mytype = 1
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
											--**de1** if FCMQT.DEBUG == 1 then d("Cond num : "..k) end
											--**de1** if FCMQT.DEBUG == 1 then d(" -> Cond Complete : "..conditionText) end
											if visibility == 1 then
												--**de1** if FCMQT.DEBUG == 1 then d("Cond Complete Added v=1") end
												mytype = 6
											elseif visibility == 0 then
												--**de1** if FCMQT.DEBUG == 1 then d("Cond Complete Added v=0") end
												mytype = 8
											elseif visibility == 2 then
												--**de1** if FCMQT.DEBUG == 1 then d("Cond Complete Added v=2") end
												mytype = 10
											else
												--**de1** if FCMQT.DEBUG == 1 then d("Cond Complete Added v=nil") end
												mytype = 2
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
						end
						
					end
				end
			end
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
	
	--local fzone, fobjective, fzoneidx, fpoiIndex = FCMQT.FindFocusedQuest()

	for i=1,MAX_JOURNAL_QUESTS do
		if FCMQT.DEBUG == 1 then d("|########### i"..i) end
		local valQindex = GetTrackedIsAssisted(1,i,0)
		if valQindex == true then
			local fzone, fobjective, fzoneidx, fpoiIndex = GetJournalQuestLocationInfo(i)
			FCMQT.FocusedZone = fzone
			FCMQT.FocusedZoneIdx = fzoneidx
			FCMQT.FoocusedZonePoiIndx = fpoiIndex
			break;
		end
	end
	if FCMQT.DEBUG == 1 then d("|########### found focused zone"..FCMQT.FocusedZone.." zone idx "..FCMQT.FocusedZoneIdx) end
	
	for i=1, MAX_JOURNAL_QUESTS do
		if IsValidQuestIndex(i) then
			FCMQT.LoadQuestsInfo(i)
		end
	end

	-- Sort by zone, name & level
	local order = FCMQT.SavedVars.SortOrder
	--local order = "Name"
	if order == "Zone+Name"  and FCMQT.SavedVars.QuestsAreaOption == true then
		table.sort(FCMQT.QuestList, function(a,b)
			if (a.zone < b.zone) then
				return true
			elseif (a.zone > b.zone) then
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
	if order == "Focused+Zone+Name" and FCMQT.SavedVars.QuestsAreaOption == true then
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
					if (a.zone < b.zone) then
						return true
					elseif (a.zone > b.zone) then
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
	if order == "Focused+Zone+Name"  and FCMQT.SavedVars.QuestsAreaOption == false then
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
	if order == "Zone+Name" and FCMQT.SavedVars.QuestsAreaOption == false then
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
	elseif FCMQT.SavedVars.QuestsHybridOption == true and FCMQT.SavedVars.QuestsAreaOption == true then	
			-- Filters
		local myQuestsTypesList = { QUEST_TYPE_NONE, QUEST_TYPE_CLASS, QUEST_TYPE_CRAFTING, QUEST_TYPE_GUILD, QUEST_TYPE_MAIN_STORY, QUEST_TYPE_GROUP, QUEST_TYPE_DUNGEON, QUEST_TYPE_RAID, QUEST_TYPE_AVA, QUEST_TYPE_QA_TEST, QUEST_TYPE_AVA_GROUP, QUEST_TYPE_AVA_GRAND, QUEST_TYPE_HOLIDAY_EVENT, QUEST_TYPE_BATTLEGROUND }
		for i, valTypesList in pairs(myQuestsTypesList) do
			for j,v in pairs(FCMQT.QuestList) do
				if v.type == valTypesList then
					if FCMQT.SavedVars.QuestsZoneOption == true then
						if IsJournalQuestInCurrentMapZone(v.index) or currentMapZoneIdx == v.zoneidx or userCurrentZone == v.zone then
							if ((FCMQT.SavedVars.QuestsZoneGuildOption == true and v.type == 3) or (FCMQT.SavedVars.QuestsZoneMainOption == true and v.type == 2) or (FCMQT.SavedVars.QuestsZoneCyrodiilOption == true and v.zoneidx == FCMQT.CyrodiilNumZoneIndex)) then
								table.insert(FCMQT.DisplayedQuests, v)
							elseif (v.type ~= QUEST_TYPE_MAIN_STORY and v.type ~= QUEST_TYPE_GUILD and v.zoneidx ~= FCMQT.CyrodiilNumZoneIndex) then
								table.insert(FCMQT.DisplayedQuests, v)
							end
						end
					else
						if ((FCMQT.SavedVars.QuestsZoneGuildOption == true and v.type == QUEST_TYPE_GUILD) or (FCMQT.SavedVars.QuestsZoneMainOption == true and v.type == QUEST_TYPE_MAIN_STORY) or (FCMQT.SavedVars.QuestsZoneCyrodiilOption == true and v.zoneidx == FCMQT.CyrodiilNumZoneIndex)) then
							table.insert(FCMQT.DisplayedQuests, v)
						elseif (v.type ~= QUEST_TYPE_MAIN_STORY and v.type ~= QUEST_TYPE_GUILD and v.zoneidx ~= FCMQT.CyrodiilNumZoneIndex) then
							table.insert(FCMQT.DisplayedQuests, v)
						end
					end
					valcheck = FCMQT.CheckQuestsToHidden(v.index, v.name, v.type, v.zoneidx, valcheck)
				end
			end
		end
	else
		for j,v in pairs(FCMQT.QuestList) do
			-- it works just not sure how to use it
			--if IsJournalQuestInCurrentMapZone(v.index) == true then table.insert(FCMQT.DisplayedQuests, v) end
			local isOk = true
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
		local myzone = z.zone
		if FCMQT.SavedVars.QuestsHybridOption == true and FCMQT.SavedVars.QuestsAreaOption == true then
			if z.type == QUEST_TYPE_AVA or z.type == QUEST_TYPE_AVA_GRAND or z.type == QUEST_TYPE_AVA_GROUP then
				myzone = myzone.." (AvA)"
			elseif z.type == QUEST_TYPE_GUILD then
				myzone = FCMQT.mylanguage.lang_tracker_type_guild
			elseif z.type == QUEST_TYPE_MAIN_STORY then
				myzone = FCMQT.mylanguage.lang_tracker_type_mainstory
			elseif z.type == QUEST_TYPE_CLASS then
				myzone = FCMQT.mylanguage.lang_tracker_type_class.." - "..myzone
			elseif z.type == QUEST_TYPE_CRAFTING then
				myzone = FCMQT.mylanguage.lang_tracker_type_craft.." - "..myzone
			elseif z.type == QUEST_TYPE_GROUP then
				myzone = FCMQT.mylanguage.lang_tracker_type_group.." - "..myzone
			elseif z.type == QUEST_TYPE_DUNGEON then
				myzone = FCMQT.mylanguage.lang_tracker_type_dungeon.." - "..myzone
			elseif z.type == QUEST_TYPE_RAID then
				myzone = FCMQT.mylanguage.lang_tracker_type_raid.." - "..myzone
			elseif z.type == QUEST_TYPE_BATTLEGROUND then
				myzone = FCMQT.mylanguage.lang_tracker_type_bg.." - "..myzone
			elseif z.type == QUEST_TYPE_HOLIDAY_EVENT then
				myzone = FCMQT.mylanguage.lang_tracker_type_holiday_event.." - "..myzone
			elseif z.type == QUEST_TYPE_QA_TEST then
				myzone = myzone.." (TEST)"
			end
		end
	--

		--if (FCMQT.SavedVars.QuestsAreaOption == true and (FCMQT.zonename ~= myzone or FCMQT.zonetype ~= z.type)) then		
		
		if FCMQT.SavedVars.QuestsAreaOption == true and FCMQT.zonename ~= myzone then		
			if not FCMQT.box[FCMQT.boxmarker] then
				local dir = FCMQT.SavedVars.DirectionBox
				local myboxdirection = BOTTOMLEFT
				if dir == "BOTTOM" then
					myboxdirection = BOTTOMLEFT
				elseif dir == "TOP" then
					myboxdirection = TOPLEFT
				end
				-- Create Container box for Title Zone
				FCMQT.box[FCMQT.boxmarker] = WM:CreateControl(nil, FCMQT.bg, CT_LABEL)
				FCMQT.box[FCMQT.boxmarker]:ClearAnchors()
				if FCMQT.boxmarker == 1 then
					FCMQT.box[FCMQT.boxmarker]:SetAnchor(TOPLEFT,FCMQT.bg,TOPLEFT,0,0)
				else
					FCMQT.box[FCMQT.boxmarker]:SetAnchor(TOPLEFT,FCMQT.box[FCMQT.boxmarker-1],myboxdirection,0,0)
				end
				FCMQT.box[FCMQT.boxmarker]:SetResizeToFitDescendents(true)
				-- Create default Icon Box
				FCMQT.icon[FCMQT.boxmarker] = WM:CreateControl(nil, FCMQT.bg, CT_TEXTURE)
				FCMQT.icon[FCMQT.boxmarker]:ClearAnchors()
				FCMQT.icon[FCMQT.boxmarker]:SetAnchor(TOPRIGHT,FCMQT.box[FCMQT.boxmarker],TOPLEFT,0,0)
				FCMQT.icon[FCMQT.boxmarker]:SetTexture( "/esoui/art/compass/quest_icon_assisted.dds" )
				FCMQT.icon[FCMQT.boxmarker]:SetDimensions(FCMQT.SavedVars.QuestIconSize, FCMQT.SavedVars.QuestIconSize)
				-- Create Title Box
				FCMQT.textbox[FCMQT.boxmarker] = WM:CreateControl(nil, FCMQT.box[FCMQT.boxmarker] , CT_LABEL)
				FCMQT.textbox[FCMQT.boxmarker]:ClearAnchors()
				FCMQT.textbox[FCMQT.boxmarker]:SetAnchor(CENTER,FCMQT.box[FCMQT.boxmarker],CENTER,0,0)
				FCMQT.textbox[FCMQT.boxmarker]:SetDrawLayer(1)
			end
			FCMQT.box[FCMQT.boxmarker]:SetDimensionConstraints(FCMQT.SavedVars.BgWidth,-1,FCMQT.SavedVars.BgWidth,-1)
			FCMQT.icon[FCMQT.boxmarker]:SetHidden(true)
			FCMQT.textbox[FCMQT.boxmarker]:SetDimensionConstraints(FCMQT.SavedVars.BgWidth-FCMQT.SavedVars.QuestsAreaPadding,-1,FCMQT.SavedVars.BgWidth-FCMQT.SavedVars.QuestsAreaPadding,-1)
			FCMQT.textbox[FCMQT.boxmarker]:SetFont(("%s|%s|%s"):format(LMP:Fetch('font', FCMQT.SavedVars.QuestsAreaFont), FCMQT.SavedVars.QuestsAreaSize, FCMQT.SavedVars.QuestsAreaStyle))
			FCMQT.textbox[FCMQT.boxmarker]:SetText(myzone)
			FCMQT.textbox[FCMQT.boxmarker]:SetColor(FCMQT.SavedVars.QuestsAreaColor.r, FCMQT.SavedVars.QuestsAreaColor.g, FCMQT.SavedVars.QuestsAreaColor.b, FCMQT.SavedVars.QuestsAreaColor.a)
			FCMQT.currentAreaBox = FCMQT.boxmarker
--b15			if FCMQT.SavedVars.QuestsNoFocusOption == true then
--b15				FCMQT.box[FCMQT.currentAreaBox]:SetAlpha(FCMQT.SavedVars.QuestsNoFocusTransparency/100)
--b15			else
--b15				FCMQT.box[FCMQT.currentAreaBox]:SetAlpha(1)
--b15			end
			if FCMQT.SavedVars.QuestsNoFocusOption == false then
				FCMQT.box[FCMQT.currentAreaBox]:SetAlpha(1)
			else
				if FCMQT.SavedVars.FocusedQuestAreaNoTrans == true and myzone == FCMQT.FocusedZone then
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
			FCMQT.zonename = myzone
			--FCMQT.zonetype = z.type
		end
		if  FCMQT.limitnumquest <= showquests then
			local checkfilter = 1
			
			if FCMQT.SavedVars.QuestsHideZoneOption == true then
				if FCMQT.filterzonedyn == z.zone then
					FCMQT.AddNewTitle(z.index, z.level, z.name, z.type, z.zone, z.focusedzoneval)
					--- hidobj
					local FocusedQuest = GetTrackedIsAssisted(1,z.index,0)
					if FCMQT.SavedVars.QuestHideObjOption == false or FocusedQuest == true then
						local k=1
						while z.step[k] do
							if z.step[k].text ~= "" then
								FCMQT.AddNewContent(z.index, k, z.step[k].text, z.step[k].mytype, z.zone, z.focusedzoneval)
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
					if FCMQT.SavedVars.QuestHideObjOption == false or FocusedQuest == true then
						local k=1
						while z.step[k] do
							if z.step[k].text ~= "" then
								FCMQT.AddNewContent(z.index, k, z.step[k].text, z.step[k].mytype, z.zone, z.focusedzoneval)
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
				if FCMQT.SavedVars.QuestHideObjOption == false or FocusedQuest == true  then
					local k=1
					while z.step[k] do
						if z.step[k].text ~= "" then
							FCMQT.AddNewContent(z.index, k, z.step[k].text, z.step[k].mytype, z.zone, z.focusedzoneval)
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
		-- Compass Update
		--QUEST_TRACKER.InitialTrackingUpdate()
		ZO_QuestTracker["tracker"]:InitialTrackingUpdate()
		--ZO_QuestTracker:InitialTrackingUpdate()
		--ZO_Tracker["tracker"]:InitialTrackingUpdate()
		-- WorldMap / Minimap Update
		ZO_WorldMap_UpdateMap()
	end
end

function FCMQT.QuestsListUpdate(eventCode)
	if (FCMQT.SavedVars and FCMQT.SavedVars.BgOption ~= nil and eventCode ~= nil) then
		-- TESTS --
		--**de1** if FCMQT.DEBUG == 1 then
		--**de1** 	local userCurrentZone = GetUnitZone('player')
		--**de1** 	local currentMapIdx = GetCurrentMapIndex()
		--**de1** 	local currentMapZoneIdx = GetCurrentMapZoneIndex()
		--**de1** 	local qzone, qobjective, qzoneidx, poiIndex = GetJournalQuestLocationInfo(i)
		--**de1** 	local qsubzoneidx, qsubzonepoi = GetCurrentSubZonePOIIndices()
		--**de1** 	qsubzoneidx = tostring(qsubzoneidx)
		--**de1** 	qsubzonepoi = tostring(qsubzonepoi)
		--**de1** 	currentMapIdx = tostring(currentMapIdx)
		--**de1** 	currentMapZoneIdx = tostring(currentMapZoneIdx)
		--**de1** 	d("--MAP INFOS--")
		--**de1** 	d("userCurrentZone : "..userCurrentZone)
		--**de1** 	d("currentMapIdx : "..currentMapIdx.." currentMapZoneIdx : "..currentMapZoneIdx)
		--**de1** 	d("qsubzoneidx : "..qsubzoneidx.." qsubzonepoi : "..qsubzonepoi)
		--**de1** 	d("-------------")
		--**de1** end
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
		-- First Init
		FCMQT.QuestsListUpdate(1)
		
		-- UPDATES with EVENTS				
		EM:RegisterForEvent("FCMQT", EVENT_PLAYER_ACTIVATED, FCMQT.QuestsListUpdate) --> EC:131072 Update after zoning
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_REMOVED, FCMQT.QuestsListUpdate) --> EC:131091 delete quest
		EM:RegisterForEvent("FCMQT", EVENT_LEVEL_UPDATE, FCMQT.QuestsListUpdate) --> Update when level up
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_ADVANCED, FCMQT.QuestsListUpdate) --> EC:131090
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_OPTIONAL_STEP_ADVANCED, FCMQT.QuestsListUpdate)		
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_ADDED, function(eventCode, qindex, qname, qstep)
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_TIMER_UPDATED, FCMQT.QuestsListUpdate)
		EM:RegisterForEvent("FCMQT", EVENT_QUEST_TIMER_PAUSED, FCMQT.QuestsListUpdate)
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
end)


--*******************************************************************
--*******************************************************************
--**********************New Code for Timer **************************
--*******************************************************************
--*******************************************************************
local function HideQuestTimer()

	
	FCMQT_Questtracker_LabelQuestRemainTime:SetHidden(true)
	EVENT_MANAGER:UnregisterForUpdate("Questtracker_Update_QuestTimer")
	isQuestTimeActive = false
end

local function UpdateQuestTime(_timerEnd)


	local remainingTime = _timerEnd - GetFrameTimeSeconds()

	if remainingTime > 0 then
		local timeText, nextUpdateDelta = ZO_FormatTime(remainingTime, TIME_FORMAT_STYLE_COLONS, TIME_FORMAT_PRECISION_SECONDS, TIME_FORMAT_DIRECTION_DESCENDING)		
		FCMQT_Questtracker_LabelQuestRemainTime:SetText("time_remaining" .. ":    " .. timeText)
		isQuestTimeActive = true
	else
		HideQuestTimer()
	end
end

local function ShowQuestTimer(_timerEnd)


	EVENT_MANAGER:RegisterForUpdate("Questtracker_Update_QuestTimer", 10, function() UpdateQuestTime(_timerEnd) end, 10)		
	FCMQT_Questtracker_LabelTime:SetHidden(true)		
	FCMQT_Questtracker_LabelQuestRemainTime:SetHidden(false)
end

function FCMQT.UpdateQuestTimer(_questIndex)

	local timerStart, timerEnd, isVisible, isPaused = GetJournalQuestTimerInfo(_questIndex) 
	if isVisible then
		local assisted = GetTrackedIsAssisted(TRACK_TYPE_QUEST, _questIndex)
		if assisted then
			ShowQuestTimer(timerEnd)
		end
	end
end

function FCMQT.UpdateTime()

	local timePrecision = TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR
	
	
	local timeString = FCMQT.GetFormatedTime(timePrecision)
	
	FCMQT_Questtracker_LabelTime:SetText(timeString)
end
