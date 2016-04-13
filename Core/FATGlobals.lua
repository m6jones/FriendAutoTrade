-------------------------------------------------------------------------------------------------
--  NameSpace -- 
-------------------------------------------------------------------------------------------------
FriendAutoTrade = {};

-------------------------------------------------------------------------------------------------
--  Global Variables --
-------------------------------------------------------------------------------------------------
FriendAutoTrade.var = {
	appName = "FriendAutoTrade",
	version = "0.1",
	slot = nil,
	tradeSlots = nil,
	tradedItems = {},
	newNeededItems = {},
	tradingWith = nil,
	["time"] = 0,
	tradeSlotsFriend = 0,
	default = {
		--Settings
		on = false;
		autoAcceptInvite = false,
		autoAccept = false,
		AutoInvite = false,
		partnerToTrade = "^Mx",
	}
}
--Filter Table
--This table allows for easy addition of new items to be tradable within the mod.
FriendAutoTrade.FilterTable = {}

--For the saved table
FriendAutoTrade.savedVar = {}