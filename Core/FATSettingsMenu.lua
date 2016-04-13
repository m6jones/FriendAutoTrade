-------------------------------------------------------------------------------------------------
--  Libraries --
-------------------------------------------------------------------------------------------------
local LAM = LibStub:GetLibrary("LibAddonMenu-2.0");
-------------------------------------------------------------------------------------------------
--  Menu Functions --
-------------------------------------------------------------------------------------------------
function FriendAutoTrade:CreateSettingsWindow()
	local panelData = {
		type = "panel",
		name = "Friend Auto Trader",
		displayName = "Friend Auto Trader",
		author = "Matthew Jones",
		version = FriendAutoTrade.var.version,
		slashCommand = "/fatsettings",
		registerForRefresh = true,
		registerForDefaults = true,
	};
	local cntrlOptionsPanel = LAM:RegisterAddonPanel("Friend_Auto_Trader", panelData);
	local optionsData = {
		[1] = {
			type = "header",
			name = "Base Settings",
		},
		[2] = {
			type = "description",
			text = "Here is where you adjust the basic options for auto trading.",
		},
		[3] = {
			type = "checkbox",
			name = "Enable Auto Trading",
			tooltip = "When ON the auto trade will be enabled.",
			default = false,
			getFunc = function() 
				return FriendAutoTrade.savedVar.on;
			end,
			setFunc = function(newValue) 
				FriendAutoTrade.Toggle(newValue);
				FriendAutoTrade.savedVar.on = newValue;
			end,
		},
		[4] = {
			type = "editbox",
			name = "Trading Partner",
			tooltip = "Character name who you will auto trade.",
			getFunc = function()
					return string.sub(FriendAutoTrade.savedVar.partnerToTrade,0, -4);
				end,
			setFunc = function(name)
					FriendAutoTrade.savedVar.partnerToTrade = name.."^Mx";
				end,
			isMultiline = false,
			width = "half",
			disabled = function () return not FriendAutoTrade.savedVar.on end,
			default = "",
		},
		[5] = {
			type = "checkbox",
			name = "Enable Auto Accept",
			tooltip = "When ON you will automatically accept trades invites from trade partner",
			default = false,
			getFunc = function() 
				return FriendAutoTrade.savedVar.autoAcceptInvite;
			end,
			setFunc = function(newValue) 
				 FriendAutoTrade.savedVar.autoAcceptInvite = newValue;
			end,
			reference = "FriendAutoTrade4",
			disabled = function () return not FriendAutoTrade.savedVar.on end,
		},
		[6] = {
			type = "checkbox",
			name = "Enable Auto Accept Trade Confirmation",
			tooltip = "When ON you will automatically accept trades confirmation",
			default = false,
			getFunc = function() 
				return FriendAutoTrade.savedVar.AutoAccept;
			end,
			setFunc = function(newValue) 
				 FriendAutoTrade.savedVar.AutoAccept = newValue;
			end,
			disabled = function () return not FriendAutoTrade.savedVar.on end,
		},
		[7] = {
			type = "checkbox",
			name = "Enable Auto Trade Invite",
			tooltip = "Auto invite after a trade until all items have been traded.",
			default = false,
			getFunc = function() 
				return FriendAutoTrade.savedVar.AutoInvite;
			end,
			setFunc = function(newValue) 
				 FriendAutoTrade.savedVar.AutoInvite = newValue;
			end,
			disabled = function () return not FriendAutoTrade.savedVar.on end,
		},
		[8] = {
			type = "header",
			name = "Trade Items",
		},
		[9] = {
			type = "description",
			text = "Pick the items to auto trade. Ranks and levels are applied the the items in that field ",
		},
		
	};
	local i = 10;
	for k,v in pairs(FriendAutoTrade.ItemCategory) do
		optionsData[i] = FriendAutoTrade.Item.SettingMenuTable(k);
		i=i+1;
	end
	LAM:RegisterOptionControls("Friend_Auto_Trader", optionsData);
end