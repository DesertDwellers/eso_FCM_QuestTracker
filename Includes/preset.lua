FCMQT = FCMQT or {}
-- Defaults Vars
-- Version : 1.4.5.23
FCMQT.defaults = {
					["position"] = { ["point"]=TOPLEFT, ["relativePoint"]=TOPLEFT, ["offsetX"]=1000, ["offsetY"]=300 },
					["Language"] = "English",
					["Preset"] = "Custom",
					["BgAlpha"] = 70,
					["BgWidth"] = 275,
					["BgOption"] = true,
					["BgColor"] = { ["r"]=0.062745, ["g"]=0.113725, ["b"]=0.152941, ["a"]=0.155738 },
					["PositionLockOption"] = false,
					["ShowJournalInfosOption"] = true,
					["ShowJournalInfosFont"] = "Trajan Pro",
					["ShowJournalInfosSize"] = 14,
					["ShowJournalInfosStyle"] = "soft-shadow-thin",
					["ShowJournalInfosColor"] = { ["r"] = 0.800000, ["g"] = 0.670588, ["b"] = 0.219608, ["a"] = 1 },
					["DirectionBox"] = "BOTTOM",
					["TitleSize"] = 17,
					["TitlePadding"] = 5,
					["TitleFont"] = "Univers 67",
					["TitleStyle"] = "shadow",
					["TitleColor"] = { ["r"]=0.800000, ["g"]=0.513726, ["b"]=0.196078, ["a"]=1 },
					["TextSize"] = 14,
					["TextPadding"] = 24,
					["TextFont"] = "Univers 57",
					["TextStyle"] = "soft-shadow-thin",
					["HideCompleteObjHints"] = false,
					["TextColor"] = { ["r"]=1, ["g"]=1, ["b"]=1, ["a"]=0.950820 },
					["TextCompleteColor"] = { ["r"]=0.603922, ["g"]=0.603922, ["b"]=0.603922, ["a"]=0.950820 },
					["TextOptionalColor"] = { ["r"]=0.945098, ["g"]=1, ["b"]=0.796078, ["a"]=0.950820 },
					["TextOptionalCompleteColor"] = { ["r"]=0.603922, ["g"]=0.603922, ["b"]=0.603922, ["a"]=0.950820 },
					["SortOrder"] = "Zone+Name",
					["NbQuests"] = 12,
					["AutoShare"] = false,
					["AutoAcceptSharedQuests"] = false,
					["AutoRefuseSharedQuests"] = false,
					["QuestIconOption"] = true,
					["QuestIcon"] = "Arrow ESO (Default)",
					["QuestIconSize"] = 22,
					["QuestIconColor"] = { ["r"]=1, ["g"]=1, ["b"]=1, ["a"]=1 },
					["QuestsAreaOption"] = true,
					["QuestsHybridOption"] = true,
					["QuestsAreaSize"] = 21,
					["QuestsAreaFont"] = "Trajan Pro",
					["QuestsAreaStyle"] = "shadow",
					["QuestsAreaPadding"] = 5,
					["QuestsAreaColor"] = { ["r"] = 0.800000, ["g"] = 0.670588, ["b"] = 0.219608, ["a"] = 1 },
					["QuestsShowTimerOption"] = false,
					["TimerTitleSize"] = 17,
					["TimerTitleFont"] = "Univers 67",
					["TimerTitleStyle"] = "shadow",
					["TimerTitleColor"] = { ["r"]=0.800000, ["g"]=0.513726, ["b"]=0.196078, ["a"]=1 },
					["HideObjHintsNotFocused"] = false,
					["QuestsLevelOption"] = true,
					["QuestsHideZoneOption"] = false,
					["QuestsZoneOption"] = false,
					["QuestsZoneGuildOption"] = true,
					["QuestsZoneMainOption"] = true,
					["QuestsZoneCyrodiilOption"] = true,
					["QuestsZoneClassOption"] = true,
					["QuestsZoneCraftingOption"] = true,
					["QuestsZoneGroupOption"] = true,
					["QuestsZoneDungeonOption"] = true,
					["QuestsCategoryCraftOption"] = true,
					["QuestsCategoryGroupOption"] = true,
					["QuestsCategoryDungeonOption"] = true,
					["QuestsCategoryRaidOption"] = true,
					["QuestsZoneRaidOption"] = true,
					["QuestsZoneAVAOption"] = true,
					["QuestsZoneEventOption"] = true,
					["QuestsZoneBGOption"] = true,
					["QuestsCategoryClassOption"] = true,
					["QuestsUntrackHiddenOption"] = false,
					["QuestsNoFocusOption"] = false,
					["FocusedQuestAreaNoTrans"] = false,
					["QuestsNoFocusTransparency"] = 55,
					["Button1"] = "Change Assisted Quest",
					["Button2"] = "Share a Quest",
					["Button3"] = "Filter by Current Zone",
					["Button4"] = "Show on Map",
					["Button5"] = "Remove a Quest",
					["BufferRefreshTime"] = "10",
					["QuestsFilter"] = {},
					["HideInfoHintsOption"] = false,
					["HideOptObjective"] = false,
					["HideOptionalInfo"] = false,
					["HideHintsOption"] = true,
					["HideHiddenOptions"] = true,
					["HintColor"] = { ["r"]=0.945098, ["g"]=1, ["b"]=0.796078, ["a"]=0.950820 },
					["HintCompleteColor"] = { ["r"]=0.603922, ["g"]=0.603922, ["b"]=0.603922, ["a"]=0.950820 },
					["HideInCombatOption"] =false,
					
					
}

FCMQT.PresetDefaults = {
					["position"] = { ["point"]=TOPLEFT, ["relativePoint"]=TOPLEFT, ["offsetX"]=1000, ["offsetY"]=300 },
					["Language"] = "English",
					["Preset"] = "Custom",
					["BgAlpha"] = 70,
					["BgWidth"] = 275,
					["BgOption"] = true,
					["BgColor"] = { ["r"]=0.062745, ["g"]=0.113725, ["b"]=0.152941, ["a"]=0.155738 },
					["PositionLockOption"] = false,
					["ShowJournalInfosOption"] = true,
					["ShowJournalInfosFont"] = "Trajan Pro",
					["ShowJournalInfosSize"] = 14,
					["ShowJournalInfosStyle"] = "soft-shadow-thin",
					["ShowJournalInfosColor"] = { ["r"] = 0.800000, ["g"] = 0.670588, ["b"] = 0.219608, ["a"] = 1 },
					["DirectionBox"] = "BOTTOM",
					["TitleSize"] = 17,
					["TitlePadding"] = 5,
					["TitleFont"] = "Univers 67",
					["TitleStyle"] = "shadow",
					["TitleColor"] = { ["r"]=0.800000, ["g"]=0.513726, ["b"]=0.196078, ["a"]=1 },
					["TextSize"] = 14,
					["TextPadding"] = 24,
					["TextFont"] = "Univers 57",
					["TextStyle"] = "soft-shadow-thin",
					["HideCompleteObjHints"] = false,
					["TextColor"] = { ["r"]=1, ["g"]=1, ["b"]=1, ["a"]=0.950820 },
					["TextCompleteColor"] = { ["r"]=0.603922, ["g"]=0.603922, ["b"]=0.603922, ["a"]=0.950820 },
					["TextOptionalColor"] = { ["r"]=0.945098, ["g"]=1, ["b"]=0.796078, ["a"]=0.950820 },
					["TextOptionalCompleteColor"] = { ["r"]=0.603922, ["g"]=0.603922, ["b"]=0.603922, ["a"]=0.950820 },
					["SortOrder"] = "Zone+Name",
					["NbQuests"] = 12,
					["AutoShare"] = false,
					["AutoAcceptSharedQuests"] = false,
					["AutoRefuseSharedQuests"] = false,
					["QuestIconOption"] = true,
					["QuestIcon"] = "Arrow ESO (Default)",
					["QuestIconSize"] = 22,
					["QuestIconColor"] = { ["r"]=1, ["g"]=1, ["b"]=1, ["a"]=1 },
					["QuestsAreaOption"] = true,
					["QuestsHybridOption"] = true,
					["QuestsAreaSize"] = 21,
					["QuestsAreaFont"] = "Trajan Pro",
					["QuestsAreaStyle"] = "shadow",
					["QuestsAreaPadding"] = 5,
					["QuestsAreaColor"] = { ["r"] = 0.800000, ["g"] = 0.670588, ["b"] = 0.219608, ["a"] = 1 },
					["QuestsShowTimerOption"] = false,
					["TimerTitleSize"] = 17,
					["TimerTitleFont"] = "Univers 67",
					["TimerTitleStyle"] = "shadow",
					["TimerTitleColor"] = { ["r"]=0.800000, ["g"]=0.513726, ["b"]=0.196078, ["a"]=1 },
					["HideObjHintsNotFocused"] = false,
					["QuestsLevelOption"] = true,
					["QuestsHideZoneOption"] = false,
					["QuestsZoneOption"] = false,
					["QuestsZoneGuildOption"] = true,
					["QuestsZoneMainOption"] = true,
					["QuestsZoneCyrodiilOption"] = true,
					["QuestsZoneClassOption"] = true,
					["QuestsZoneCraftingOption"] = true,
					["QuestsZoneGroupOption"] = true,
					["QuestsZoneDungeonOption"] = true,
					["QuestsCategoryCraftOption"] = true,
					["QuestsCategoryGroupOption"] = true,
					["QuestsCategoryDungeonOption"] = true,
					["QuestsCategoryRaidOption"] = true,
					["QuestsZoneRaidOption"] = true,
					["QuestsZoneAVAOption"] = true,
					["QuestsZoneEventOption"] = true,
					["QuestsZoneBGOption"] = true,
					["QuestsCategoryClassOption"] = true,
					["QuestsUntrackHiddenOption"] = false,
					["QuestsNoFocusOption"] = false,
					["FocusedQuestAreaNoTrans"] = false,
					["QuestsNoFocusTransparency"] = 55,
					["Button1"] = "Change Assisted Quest",
					["Button2"] = "Share a Quest",
					["Button3"] = "Filter by Current Zone",
					["Button4"] = "Show on Map",
					["Button5"] = "Remove a Quest",
					["BufferRefreshTime"] = "10",
					["QuestsFilter"] = {},
					["HideInfoHintsOption"] = false,
					["HideOptObjective"] = false,
					["HideOptionalInfo"] = false,
					["HideHintsOption"] = true,
					["HideHiddenOptions"] = true,
					["HintColor"] = { ["r"]=0.945098, ["g"]=1, ["b"]=0.796078, ["a"]=0.950820 },
					["HintCompleteColor"] = { ["r"]=0.603922, ["g"]=0.603922, ["b"]=0.603922, ["a"]=0.950820 },
					["HideInCombatOption"] =false,
}

FCMQT.preset1 = {
					["position"] = { ["point"]=TOPLEFT, ["relativePoint"]=TOPLEFT, ["offsetX"]=1000, ["offsetY"]=300 },
					["Language"] = "English",
					["Preset"] = "Custom",
					["BgAlpha"] = 70,
					["BgWidth"] = 275,
					["BgOption"] = true,
					["BgColor"] = { ["r"]=0.062745, ["g"]=0.113725, ["b"]=0.152941, ["a"]=0.155738 },
					["PositionLockOption"] = false,
					["ShowJournalInfosOption"] = true,
					["ShowJournalInfosFont"] = "Trajan Pro",
					["ShowJournalInfosSize"] = 14,
					["ShowJournalInfosStyle"] = "soft-shadow-thin",
					["ShowJournalInfosColor"] = { ["r"] = 0.800000, ["g"] = 0.670588, ["b"] = 0.219608, ["a"] = 1 },
					["DirectionBox"] = "BOTTOM",
					["TitleSize"] = 17,
					["TitlePadding"] = 5,
					["TitleFont"] = "Univers 67",
					["TitleStyle"] = "shadow",
					["TitleColor"] = { ["r"]=0.800000, ["g"]=0.513726, ["b"]=0.196078, ["a"]=1 },
					["TextSize"] = 14,
					["TextPadding"] = 24,
					["TextFont"] = "Univers 57",
					["TextStyle"] = "soft-shadow-thin",
					["HideCompleteObjHints"] = false,
					["TextColor"] = { ["r"]=1, ["g"]=1, ["b"]=1, ["a"]=0.950820 },
					["TextCompleteColor"] = { ["r"]=0.603922, ["g"]=0.603922, ["b"]=0.603922, ["a"]=0.950820 },
					["TextOptionalColor"] = { ["r"]=0.945098, ["g"]=1, ["b"]=0.796078, ["a"]=0.950820 },
					["TextOptionalCompleteColor"] = { ["r"]=0.603922, ["g"]=0.603922, ["b"]=0.603922, ["a"]=0.950820 },
					["SortOrder"] = "Zone+Name",
					["NbQuests"] = 12,
					["AutoShare"] = false,
					["AutoAcceptSharedQuests"] = false,
					["AutoRefuseSharedQuests"] = false,
					["QuestIconOption"] = true,
					["QuestIcon"] = "Arrow ESO (Default)",
					["QuestIconSize"] = 22,
					["QuestIconColor"] = { ["r"]=1, ["g"]=1, ["b"]=1, ["a"]=1 },
					["QuestsAreaOption"] = true,
					["QuestsHybridOption"] = true,
					["QuestsAreaSize"] = 21,
					["QuestsAreaFont"] = "Trajan Pro",
					["QuestsAreaStyle"] = "shadow",
					["QuestsAreaPadding"] = 5,
					["QuestsAreaColor"] = { ["r"] = 0.800000, ["g"] = 0.670588, ["b"] = 0.219608, ["a"] = 1 },
					["QuestsShowTimerOption"] = false,
					["TimerTitleSize"] = 17,
					["TimerTitleFont"] = "Univers 67",
					["TimerTitleStyle"] = "shadow",
					["TimerTitleColor"] = { ["r"]=0.800000, ["g"]=0.513726, ["b"]=0.196078, ["a"]=1 },
					["HideObjHintsNotFocused"] = false,
					["QuestsLevelOption"] = true,
					["QuestsHideZoneOption"] = false,
					["QuestsZoneOption"] = false,
					["QuestsZoneGuildOption"] = true,
					["QuestsZoneMainOption"] = true,
					["QuestsZoneCyrodiilOption"] = true,
					["QuestsZoneClassOption"] = true,
					["QuestsZoneCraftingOption"] = true,
					["QuestsZoneGroupOption"] = true,
					["QuestsZoneDungeonOption"] = true,
					["QuestsCategoryCraftOption"] = true,
					["QuestsCategoryGroupOption"] = true,
					["QuestsCategoryDungeonOption"] = true,
					["QuestsCategoryRaidOption"] = true,
					["QuestsZoneRaidOption"] = true,
					["QuestsZoneAVAOption"] = true,
					["QuestsZoneEventOption"] = true,
					["QuestsZoneBGOption"] = true,
					["QuestsCategoryClassOption"] = true,
					["QuestsUntrackHiddenOption"] = false,
					["QuestsNoFocusOption"] = false,
					["FocusedQuestAreaNoTrans"] = false,
					["QuestsNoFocusTransparency"] = 55,
					["Button1"] = "Change Assisted Quest",
					["Button2"] = "Share a Quest",
					["Button3"] = "Filter by Current Zone",
					["Button4"] = "Show on Map",
					["Button5"] = "Remove a Quest",
					["BufferRefreshTime"] = "10",
					["QuestsFilter"] = {},
					["HideInfoHintsOption"] = false,
					["HideOptObjective"] = false,
					["HideOptionalInfo"] = false,
					["HideHintsOption"] = true,
					["HideHiddenOptions"] = true,
					["HintColor"] = { ["r"]=0.945098, ["g"]=1, ["b"]=0.796078, ["a"]=0.950820 },
					["HintCompleteColor"] = { ["r"]=0.603922, ["g"]=0.603922, ["b"]=0.603922, ["a"]=0.950820 },
					["HideInCombatOption"] =false,
}