FCMQT = FCMQT or {}
-- Defaults Vars
-- Version : 0.95.b15

function CreateSettings()

    --Load LibAddonMenu
    local LAM  = LibStub("LibAddonMenu-2.0")
    --Load LibMediaProvider
    local LMP   = LibStub("LibMediaProvider-1.0")
	
	local QTAuthor = "DesertDwellers original coding by BlackStorm"
	local QTVersion = "0.95.b15"
	local fontList = LMP:List('font')
	local langList = {"English", "Français", "Deutsch"}
	local fontStyles = {"normal", "outline", "shadow", "soft-shadow-thick", "soft-shadow-thin", "thick-outline"}
	local iconList = {"Arrow ESO (Default)", "Icon Dragonknight", "Icon Nightblade", "Icon Sorcerer", "Icon Templar"}
	local actionList = {"None", "Change Assisted Quest", "Filter by Current Zone", "Share a Quest", "Show on Map", "Remove a Quest"}
	local sortList = {"Zone+Name", "Focused+Zone+Name"}
	local DirectionList = {"TOP", "BOTTOM"}
	local presetList = {"Custom", "Default", "Preset1"}
	local optionsData = {}
	

    	-- Create new menu
	local panelData = {
		type = "panel",
		name = FCMQT.mylanguage.lang_fcmqt_settings,
		displayName = ZO_HIGHLIGHT_TEXT:Colorize(FCMQT.mylanguage.lang_fcmqt_settings),	author = QTAuthor,
		version = QTVersion,
		slashCommand = "/fcmqt",
		registerForRefresh = true,
		--registerForDefaults = true,
		}
	LAM:RegisterAddonPanel("FCMQT_Settings", panelData)
	-- **setup info**
	--Box Settings
	
	--local optionsData {}
	
	--Global Settings
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = FCMQT.mylanguage.lang_global_settings,
		controls = {
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_language_settings,
				tooltip = FCMQT.mylanguage.lang_language_settings_tip,
				choices = langList,
				getFunc = FCMQT.GetLanguage,
				setFunc = FCMQT.SetLanguage,
				warning = FCMQT.mylanguage.lang_menu_warn_1,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_preset_settings,
				tooltip = FCMQT.mylanguage.lang_preset_settings_tip,
				choices = presetList,
				getFunc = FCMQT.GetPreset,
				setFunc = FCMQT.SetPreset,
				warning = FCMQT.mylanguage.lang_menu_warn_2,
			},
			{
				type = "slider",
				name = FCMQT.mylanguage.lang_overall_transparency,
				tooltip = FCMQT.mylanguage.lang_overall_transparency_tip,
				min = 1,
				max = 100,
				getFunc = FCMQT.GetBgAlpha,
				setFunc = FCMQT.SetBgAlpha,
			},
			{
				type = "slider",
				name = FCMQT.mylanguage.lang_overall_width,
				tooltip = FCMQT.mylanguage.lang_overall_width_tip,
				min = 100,
				max = 600,
				getFunc = FCMQT.GetBgWidth,
				setFunc = FCMQT.SetBgWidth,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_position_lock,
				tooltip = FCMQT.mylanguage.lang_position_lock_tip,
				getFunc = FCMQT.GetPositionLockOption,
				setFunc = FCMQT.SetPositionLockOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_backgroundcolor_opt,
				tooltip = FCMQT.mylanguage.lang_backgroundcolor_opt_tip,
				getFunc = FCMQT.GetBgOption,
				setFunc = FCMQT.SetBgOption,
			},
			{
				type = "colorpicker",
				name = FCMQT.mylanguage.lang_backgroundcolor_value,
				tooltip = FCMQT.mylanguage.lang_backgroundcolor_value_tip,
				getFunc = FCMQT.GetBgColor,
				setFunc = FCMQT.SetBgColor,
			},
		},
	} -- Mouse
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = FCMQT.mylanguage.lang_mouse_settings,
		controls = {
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_mouse_1,
				tooltip = FCMQT.mylanguage.lang_mouse_1_tip,
				choices = actionList,
				getFunc = FCMQT.GetButton1,
				setFunc = FCMQT.SetButton1,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_mouse_2,
				tooltip = FCMQT.mylanguage.lang_mouse_2_tip,
				choices = actionList,
				getFunc = FCMQT.GetButton3,
				setFunc = FCMQT.SetButton3,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_mouse_3,
				tooltip = FCMQT.mylanguage.lang_mouse_3_tip,
				choices = actionList,
				getFunc = FCMQT.GetButton2,
				setFunc = FCMQT.SetButton2,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_mouse_4,
				tooltip = FCMQT.mylanguage.lang_mouse_4_tip,
				choices = actionList,
				getFunc = FCMQT.GetButton4,
				setFunc = FCMQT.SetButton4,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_mouse_5,
				tooltip = FCMQT.mylanguage.lang_mouse_5_tip,
				choices = actionList,
				getFunc = FCMQT.GetButton5,
				setFunc = FCMQT.SetButton5,
			},
		},
	}--zone
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = FCMQT.mylanguage.lang_area_settings,
		controls = {
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_area_name,
				tooltip = FCMQT.mylanguage.lang_area_name_tip,
				getFunc = FCMQT.GetQuestsAreaOption,
				setFunc = FCMQT.SetQuestsAreaOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_area_hybrid,
				tooltip = FCMQT.mylanguage.lang_area_hybrid_tip,
				getFunc = FCMQT.GetQuestsHybridOption,
				setFunc = FCMQT.SetQuestsHybridOption,
				disabled = function() return not FCMQT.SavedVars.QuestsAreaOption end,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_area_font,
				tooltip = FCMQT.mylanguage.lang_area_font_tip,
				choices = fontList,
				getFunc = FCMQT.GetQuestsAreaFont,
				setFunc = FCMQT.SetQuestsAreaFont,
				disabled = function() return not FCMQT.SavedVars.QuestsAreaOption end,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_area_style,
				tooltip = FCMQT.mylanguage.lang_area_style_tip,
				choices = fontStyles,
				getFunc = FCMQT.GetQuestsAreaStyle,
				setFunc = FCMQT.SetQuestsAreaStyle,
				disabled = function() return not FCMQT.SavedVars.QuestsAreaOption end,
			},
			{
				type = "slider",
				name = FCMQT.mylanguage.lang_area_size,
				tooltip = FCMQT.mylanguage.lang_area_size_tip,
				min = 8,
				max = 45,
				getFunc = FCMQT.GetQuestsAreaSize,
				setFunc = FCMQT.SetQuestsAreaSize,
				disabled = function() return not FCMQT.SavedVars.QuestsAreaOption end,
			},
			{
				type = "slider",
				name = FCMQT.mylanguage.lang_area_padding,
				tooltip = FCMQT.mylanguage.lang_area_padding_tip,
				min = 1,
				max = 60,
				getFunc = FCMQT.GetQuestsAreaPadding,
				setFunc = FCMQT.SetQuestsAreaPadding,
				disabled = function() return not FCMQT.SavedVars.QuestsAreaOption end,
			},
			{
				type = "colorpicker",
				name = FCMQT.mylanguage.lang_area_color,
				tooltip = FCMQT.mylanguage.lang_area_color_tip,
				getFunc = FCMQT.GetQuestsAreaColor,
				setFunc = FCMQT.SetQuestsAreaColor,
				disabled = function() return not FCMQT.SavedVars.QuestsAreaOption end,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_autohidequestzone_option,
				tooltip = FCMQT.mylanguage.lang_autohidequestzone_option_tip,
				getFunc = FCMQT.GetQuestsHideZoneOption,
				setFunc = FCMQT.SetQuestsHideZoneOption,
				disabled = function() return not FCMQT.SavedVars.QuestsAreaOption end,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_questzone_option,
				tooltip = FCMQT.mylanguage.lang_questzone_option_tip,
				getFunc = FCMQT.GetQuestsZoneOption,
				setFunc = FCMQT.SetQuestsZoneOption,
				disabled = function() return not FCMQT.SavedVars.QuestsAreaOption end, 
			},
		},
	}--show quest types
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = FCMQT.mylanguage.lang_quests_filtered_settings,
		controls = {
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_guild,
				tooltip = FCMQT.mylanguage.lang_quests_guild_tip,
				getFunc = FCMQT.GetQuestsZoneGuildOption,
				setFunc = FCMQT.SetQuestsZoneGuildOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_mainstory,
				tooltip = FCMQT.mylanguage.lang_quests_mainstory_tip,
				getFunc = FCMQT.GetQuestsZoneMainOption,
				setFunc = FCMQT.SetQuestsZoneMainOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_cyrodiil,
				tooltip = FCMQT.mylanguage.lang_quests_cyrodiil_tip,
				getFunc = FCMQT.GetQuestsZoneCyrodiilOption,
				setFunc = FCMQT.SetQuestsZoneCyrodiilOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_class,
				tooltip = FCMQT.mylanguage.lang_quests_class_tip,
				getFunc = FCMQT.GetQuestsZoneClassOption,
				setFunc = FCMQT.SetQuestsZoneClassOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_crafting,
				tooltip = FCMQT.mylanguage.lang_quests_crafting_tip,
				getFunc = FCMQT.GetQuestsZoneCraftingOption,
				setFunc = FCMQT.SetQuestsZoneCraftingOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_group,
				tooltip = FCMQT.mylanguage.lang_quests_group_tip,
				getFunc = FCMQT.GetQuestsZoneGroupOption,
				setFunc = FCMQT.SetQuestsZoneGroupOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_dungeon,
				tooltip = FCMQT.mylanguage.lang_quests_dungeon_tip,
				getFunc = FCMQT.GetQuestsZoneDungeonOption,
				setFunc = FCMQT.SetQuestsZoneDungeonOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_raid,
				tooltip = FCMQT.mylanguage.lang_quests_raid_tip,
				getFunc = FCMQT.GetQuestsZoneRaidOption,
				setFunc = FCMQT.SetQuestsZoneRaidOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_AVA,
				tooltip = FCMQT.mylanguage.lang_quests_AVA_tip,
				getFunc = FCMQT.GetQuestsZoneAVAOption,
				setFunc = FCMQT.SetQuestsZoneAVAOption,
			},{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_event,
				tooltip = FCMQT.mylanguage.lang_quests_event_tip,
				getFunc = FCMQT.GetQuestsZoneEventOption,
				setFunc = FCMQT.SetQuestsZoneEventOption,
			},{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_BG,
				tooltip = FCMQT.mylanguage.lang_quests_BG_tip,
				getFunc = FCMQT.GetQuestsZoneBGOption,
				setFunc = FCMQT.SetQuestsZoneBGOption,
			},
		},
	}--quest settings
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = FCMQT.mylanguage.lang_quests_settings,
		controls = {
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_quests_sort,
				tooltip = FCMQT.mylanguage.lang_quests_sort_tip,
				choices = sortList,
				getFunc = FCMQT.GetSortQuests,
				setFunc = FCMQT.SetSortQuests,
			},
			{
				type = "slider",
				name = FCMQT.mylanguage.lang_quests_nb,
				tooltip = FCMQT.mylanguage.lang_quests_nb_tip,
				min = 1,
				max = MAX_JOURNAL_QUESTS,
				getFunc = FCMQT.GetNbQuests,
				setFunc = FCMQT.SetNbQuests,
			},
			{	type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_show_timer,
				tooltip = FCMQT.mylanguage.lang_quests_show_timer_tip,
				getFunc = FCMQT.GetQuestsShowTimerOption,
				setFunc = FCMQT.SetQuestsShowTimerOption,
			},
			{	type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_hide_obj,
				tooltip = FCMQT.mylanguage.lang_quests_hide_obj_tip,
				getFunc = FCMQT.GetQuestHideObjOption,
				setFunc = FCMQT.SetQuestHideObjOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_optinfos,
				tooltip = FCMQT.mylanguage.lang_quests_optinfos_tip,
				getFunc = FCMQT.GetQuestsOptionalOption,
				setFunc = FCMQT.SetQuestsOptionalOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_autoshare,
				tooltip = FCMQT.mylanguage.lang_quests_autoshare_tip,
				getFunc = FCMQT.GetAutoShareOption,
				setFunc = FCMQT.SetAutoShareOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_autountrack,
				tooltip = FCMQT.mylanguage.lang_quests_autountrack_tip,
				getFunc = FCMQT.GetQuestsUntrackHiddenOption,
				setFunc = FCMQT.SetQuestsUntrackHiddenOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_icon_opt,
				tooltip = FCMQT.mylanguage.lang_icon_opt_tip,
				getFunc = FCMQT.GetQuestIconOption,
				setFunc = FCMQT.SetQuestIconOption,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_icon_texture,
				tooltip = FCMQT.mylanguage.lang_icon_texture_tip,
				choices = iconList,
				getFunc = FCMQT.GetQuestIcon,
				setFunc = FCMQT.SetQuestIcon,
			},
			{
				type = "slider",
				name = FCMQT.mylanguage.lang_icon_size,
				tooltip = FCMQT.mylanguage.lang_icon_size_tip,
				min = 18,
				max = 40,
				getFunc = FCMQT.GetQuestIconSize,
				setFunc = FCMQT.SetQuestIconSize,
			},
			{
				type = "colorpicker",
				name = FCMQT.mylanguage.lang_icon_color,
				tooltip = FCMQT.mylanguage.lang_icon_color_tip,
				getFunc = FCMQT.GetQuestIconColor,
				setFunc = FCMQT.SetQuestIconColor,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_transparency_opt,
				tooltip = FCMQT.mylanguage.lang_quests_transparency_opt_tip,
				getFunc = FCMQT.GetQuestsNoFocusOption,
				setFunc = FCMQT.SetQuestsNoFocusOption,
			},
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_no_trans_focused_zone,
				tooltip = FCMQT.mylanguage.lang_no_trans_focused_zone_tip,
				getFunc = FCMQT.GetFocusedQuestAreaNoTrans,
				setFunc = FCMQT.SetFocusedQuestAreaNoTrans,
				disable = function() return not FCMQT.SavedVars.QuestsNoFocusOption end,
			},			
			{
				type = "slider",
				name = FCMQT.mylanguage.lang_quests_transparency,
				tooltip = FCMQT.mylanguage.lang_quests_transparency_tip,
				min = 1,
				max = 100,
				getFunc = FCMQT.GetQuestsNoFocusTransparency,
				setFunc = FCMQT.SetQuestsNoFocusTransparency,
				disable = function() return not FCMQT.SavedVars.QuestsNoFocusOption end,
			},
		},
	}--Guest Name Settings
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = FCMQT.mylanguage.lang_titles_settings,
		controls = {
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_titles_font,
				tooltip = FCMQT.mylanguage.lang_titles_font_tip,
				choices = fontList,
				getFunc = FCMQT.GetTitleFont,
				setFunc = FCMQT.SetTitleFont,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_titles_style,
				tooltip = FCMQT.mylanguage.lang_titles_style_tip,
				choices = fontStyles,
				getFunc = FCMQT.GetTitleStyle,
				setFunc = FCMQT.SetTitleStyle,
			},
			{
				type = "slider",
				name = FCMQT.mylanguage.lang_titles_size,
				tooltip = FCMQT.mylanguage.lang_titles_size_tip,
				min = 8,
				max = 45,
				getFunc = FCMQT.GetTitleSize,
				setFunc = FCMQT.SetTitleSize,
			},
			{
				type = "slider",
				name = FCMQT.mylanguage.lang_titles_padding,
				tooltip = FCMQT.mylanguage.lang_titles_padding_tip,
				min = 1,
				max = 60,
				getFunc = FCMQT.GetTitlePadding,
				setFunc = FCMQT.SetTitlePadding,
			},
			{
				type = "colorpicker",
				name = FCMQT.mylanguage.lang_titles_default,
				tooltip = FCMQT.mylanguage.lang_titles_default_tip,
				getFunc = FCMQT.GetTitleColor,
				setFunc = FCMQT.SetTitleColor,
			},
			-- Text Settings
			{
				type = "header",
				name = FCMQT.mylanguage.lang_obj_settings,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_obj_font,
				tooltip = FCMQT.mylanguage.lang_obj_font_tip,
				choices = fontList,
				getFunc = FCMQT.GetTextFont,
				setFunc = FCMQT.SetTextFont,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_obj_style,
				tooltip = FCMQT.mylanguage.lang_obj_style_tip,
				choices = fontStyles,
				getFunc = FCMQT.GetTextStyle,
				setFunc = FCMQT.SetTextStyle,
			},
			{
				type = "slider",
				name = FCMQT.mylanguage.lang_obj_size,
				tooltip = FCMQT.mylanguage.lang_obj_size_tip,
				min = 8,
				max = 45,
				getFunc = FCMQT.GetTextSize,
				setFunc = FCMQT.SetTextSize,
			},
			{
				type = "slider",
				name = FCMQT.mylanguage.lang_obj_padding,
				tooltip = FCMQT.mylanguage.lang_obj_padding_tip,
				min = 1,
				max = 60,
				getFunc = FCMQT.GetTextPadding,
				setFunc = FCMQT.SetTextPadding,
			},
			{
				type = "colorpicker",
				name = FCMQT.mylanguage.lang_obj_color,
				tooltip = FCMQT.mylanguage.lang_obj_color_tip,
				getFunc = FCMQT.GetTextColor,
				setFunc = FCMQT.SetTextColor,
			},
			{
				type = "colorpicker",
				name = FCMQT.mylanguage.lang_obj_ccolor,
				tooltip = FCMQT.mylanguage.lang_obj_ccolor_tip,
				getFunc = FCMQT.GetTextCompleteColor,
				setFunc = FCMQT.SetTextCompleteColor,
			},
			
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_quests_hide_obj_optional,
				tooltip = FCMQT.mylanguage.lang_quests_hide_obj_optional_tip,
				getFunc = FCMQT.GetQuestsHideObjOptional,
				setFunc = FCMQT.SetQuestsHideObjOptional,
			},
			{
				type = "colorpicker",
				name = FCMQT.mylanguage.lang_obj_optcolor,
				tooltip = FCMQT.mylanguage.lang_obj_optcolor_tip,
				getFunc = FCMQT.GetTextOptionalColor,
				setFunc = FCMQT.SetTextOptionalColor,
			},
			{
				type = "colorpicker",
				name = FCMQT.mylanguage.lang_obj_optccolor,
				tooltip = FCMQT.mylanguage.lang_obj_optccolor_tip,
				getFunc = FCMQT.GetTextOptionalCompleteColor,
				setFunc = FCMQT.SetTextOptionalCompleteColor,
			},
		},
	}
	optionsData[#optionsData + 1] = {
		type = "submenu",
		name = FCMQT.mylanguage.lang_infos_settings,
		controls = {
			{
				type = "checkbox",
				name = FCMQT.mylanguage.lang_infos_opt,
				tooltip = FCMQT.mylanguage.lang_infos_opt_tip,
				getFunc = FCMQT.GetShowJournalInfosOption,
				setFunc = FCMQT.SetShowJournalInfosOption,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_infos_font,
				tooltip = FCMQT.mylanguage.lang_infos_font_tip,
				choices = fontList,
				getFunc = FCMQT.GetShowJournalInfosFont,
				setFunc = FCMQT.SetShowJournalInfosFont,
			},
			{
				type = "dropdown",
				name = FCMQT.mylanguage.lang_infos_style,
				tooltip = FCMQT.mylanguage.lang_infos_style_tip,
				choices = fontStyles,
				getFunc = FCMQT.GetShowJournalInfosStyle,
				setFunc = FCMQT.SetShowJournalInfosStyle,
			},
			{
				type = "slider",
				name = FCMQT.mylanguage.lang_infos_size,
				tooltip = FCMQT.mylanguage.lang_infos_size_tip,
				min = 8,
				max = 45,
				getFunc = FCMQT.GetShowJournalInfosSize,
				setFunc = FCMQT.SetShowJournalInfosSize,
			},
			{
				type = "colorpicker",
				name = FCMQT.mylanguage.lang_infos_color,
				tooltip = FCMQT.mylanguage.lang_infos_color_tip,
				getFunc = FCMQT.GetShowJournalInfosColor,
				setFunc = FCMQT.SetShowJournalInfosColor,
			},
		},
	}
	--LAM:RegisterAddonPanel("FCMQT_Settings", panelData)
	LAM:RegisterOptionControls("FCMQT_Settings", optionsData)
	
	--    LAM2:RegisterAddonPanel('LUIEAddonOptions', panelData)
    --LAM2:RegisterOptionControls('LUIEAddonOptions', optionsData)
end