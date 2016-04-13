-------------------------------------------------------------------------------------------------
--  OnAddOnLoaded  -- 
-------------------------------------------------------------------------------------------------
function FriendAutoTrade.OnAddOnLoaded(event, addonName)
	if addonName ~= FriendAutoTrade.var.appName then 
		return 
	end
		FriendAutoTrade:Initialize();
end

--  Initialize Function --
function FriendAutoTrade:Initialize()
	--Unregister Load event
	EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_ADD_ON_LOADED)
	
	--Load Saved values
	FriendAutoTrade.Item.LoadDefaultValues();
	FriendAutoTrade.savedVar = ZO_SavedVars:New("FriendAutoTradeVars", FriendAutoTrade.var.version, nil, FriendAutoTrade.var.default);
	
	--Make Setting Window:
	FriendAutoTrade:CreateSettingsWindow();
	
	--Load the Main Events
	FriendAutoTrade.Toggle(FriendAutoTrade.savedVar.on);
	
	--Slash Commands
	SLASH_COMMANDS["/fatreset"] = function () FriendAutoTrade.savedVar =FriendAutoTrade.var.default; end;
	SLASH_COMMANDS["/fatflush"] = function () FriendAutoTrade.TradeCleanUp(); end;
	SLASH_COMMANDS["/fattrade"] = function () TradeInviteByName(FriendAutoTrade.savedVar.partnerToTrade); end;
	SLASH_COMMANDS["/fattest"] = function () FriendAutoTrade.test () end;
end
function FriendAutoTrade.test ()
	
end
-------------------------------------------------------------------------------------------------
--  Methods that toggle Auto trade  --
-------------------------------------------------------------------------------------------------
function FriendAutoTrade.Toggle(enable)
	FriendAutoTrade.savedVar.on = enable;
	if enable then 
		--Load the Main Events
		--Invite events
		EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_CONSIDERING, FriendAutoTrade.InviteConsidering);
		EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_WAITING, FriendAutoTrade.InviteWaiting);
		EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_ACCEPTED, FriendAutoTrade.InviteAccepted);
		EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_FAILED, FriendAutoTrade.InviteFailed);
		--EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_CANCELED, FriendAutoTrade.InviteFailed);
		EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_DECLINED, FriendAutoTrade.InviteFailed);
		--EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_REMOVED, FriendAutoTrade.InviteFailed);
		--Item Events
		EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_ITEM_ADDED, FriendAutoTrade.ItemAdded);
		EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_ITEM_ADD_FAILED, FriendAutoTrade.ItemAddFailed);
		EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_ITEM_REMOVED, FriendAutoTrade.ItemRemoved);
		--Trade Events
		EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_CANCELED, FriendAutoTrade.TradeFailed);
		EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_CONFIRMATION_CHANGED, FriendAutoTrade.ConfirmationChanged);
		EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_FAILED, FriendAutoTrade.TradeFailed);
		EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_SUCCEEDED,FriendAutoTrade.Succeeded);
		
	else
		--Unload the Main Events
		--Invite Events
		EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_CONSIDERING);
		EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_WAITING);
		EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_ACCEPTED);
		EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_FAILED);
		--EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_CANCELED);
		EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_DECLINED);
		--EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_INVITE_REMOVED);
		--Item Events
		EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_ITEM_ADDED);
		EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_ITEM_ADD_FAILED);
		EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_ITEM_REMOVED);
		--Trade Events
		EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_CANCELED);
		EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_CONFIRMATION_CHANGED);
		EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_FAILED);
		EVENT_MANAGER:UnregisterForEvent(FriendAutoTrade.var.appName, EVENT_TRADE_SUCCEEDED);
	end
end
-------------------------------------------------------------------------------------------------
--  Register Events --
-------------------------------------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(FriendAutoTrade.var.appName, EVENT_ADD_ON_LOADED, FriendAutoTrade.OnAddOnLoaded);
