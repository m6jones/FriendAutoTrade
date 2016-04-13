--Add Item to trade slot 
function FriendAutoTrade.AddItem()
	local size = GetBagSize(BAG_BACKPACK);
	while FriendAutoTrade.var.slot <= size do
		local item = FriendAutoTrade.Item.MakeBySlot(FriendAutoTrade.var.slot)
		if item and item.doAddToTrade(item) and not FriendAutoTrade.hasBeenTraded(item, FriendAutoTrade.var.slot) then
			TradeAddItem(BAG_BACKPACK, FriendAutoTrade.var.slot, nil);
			FriendAutoTrade.addToTraded(FriendAutoTrade.var.slot);
			FriendAutoTrade.var.slot = FriendAutoTrade.var.slot + 1;
			return;
		end
		FriendAutoTrade.var.slot = FriendAutoTrade.var.slot + 1;
	end
	if FriendAutoTrade.savedVar.AutoAccept then
		TradeAccept();
	end
end
----------------------------------------------------------------------
--- Helpers ---
----------------------------------------------------------------------
-- Checks to see if and item has been traded.
function FriendAutoTrade.hasBeenTraded(item, slot)
	local uniqueID = GetItemUniqueId(BAG_BACKPACK, slot);
	return FriendAutoTrade.var.tradedItems[uniqueID] or FriendAutoTrade.var.newNeededItems[item.GetLink()];
end

function FriendAutoTrade.addToTraded(slot)
	local uniqueID = GetItemUniqueId(BAG_BACKPACK, slot);
	FriendAutoTrade.var.tradedItems[uniqueID] = true;
end

function FriendAutoTrade.isTradeRight()
	-- so if both are nil nothing happens too.
	return FriendAutoTrade.var.tradingWith == FriendAutoTrade.savedVar.partnerToTrade;
end
function FriendAutoTrade.addToNewItems(itemLink)
	local item = FriendAutoTrade.Item.Make(itemLink)
	if item and item.doAddToNeededItems(item) then 
		FriendAutoTrade.var.newNeededItems[itemLink] = true;
	end
end
function FriendAutoTrade.removeFromNewItems(itemLink)
	FriendAutoTrade.var.newNeededItems[itemLink] = nil;
end
function FriendAutoTrade.TradeCleanUp()
	FriendAutoTrade.var.slot = 0;
	FriendAutoTrade.var.tradeSlots = 0;
	FriendAutoTrade.CleanUpTable(FriendAutoTrade.var.tradedItems);
	FriendAutoTrade.CleanUpTable(FriendAutoTrade.var.newNeededItems);
	FriendAutoTrade.var.tradedItems = {};
	FriendAutoTrade.var.newNeededItems = {};
	FriendAutoTrade.var.tradingWith = nil;
	FriendAutoTrade.var.tradeSlotsFriend = 0;
end
function FriendAutoTrade.CleanUpTable(aTable)
	for key, value in pairs(aTable) do
		aTable[key] = nil;
	end
end
----------------------------------------------------------------------
--- INVITE EVENT CODE ---
----------------------------------------------------------------------
--EVENT_TRADE_INVITE_CONSIDERING --Happens to the person being invited
function FriendAutoTrade.InviteConsidering(eventcode, inviter, displayName)
	local autoAccept = FriendAutoTrade.savedVar.autoAcceptInvite;
	FriendAutoTrade.var.tradingWith = inviter;
	FriendAutoTrade.var.invitee = false;
	
	if FriendAutoTrade.isTradeRight() and autoAccept then
		TradeInviteAccept();
	end
end

--EVENT_TRADE_INVITE_WAITING --Happens to the person who invites
function FriendAutoTrade.InviteWaiting(eventCode, invitee, displayName)
	FriendAutoTrade.var.tradingWith = invitee;
	FriendAutoTrade.var.invitee = true;
end

--EVENT_TRADE_INVITE_ACCEPTED --Happens to both players
function FriendAutoTrade.InviteAccepted(eventCode)
	
	if FriendAutoTrade.isTradeRight() then
		FriendAutoTrade.var.slot = 0;
		FriendAutoTrade.var.tradeSlots = 0;
		FriendAutoTrade.var.tradeSlotsFriend = 0;
		if GetDiffBetweenTimeStamps(GetTimeStamp(), FriendAutoTrade.var.time) > 3000 then
			FriendAutoTrade.CleanUpTable(FriendAutoTrade.var.tradedItems);
			FriendAutoTrade.CleanUpTable(FriendAutoTrade.var.newNeededItems);
		end
		FriendAutoTrade.var.time = 0;
		FriendAutoTrade.AddItem();
	end
end

--EVENT_TRADE_INVITE_FAILED --EVENT_TRADE_INVITE_CANCELED --EVENT_TRADE_INVITE_REMOVED --EVENT_TRADE_INVITE_DECLINED
function FriendAutoTrade.InviteFailed(eventCode, reason, name)
	FriendAutoTrade.var.tradingWith = nil;
end

----------------------------------------------------------------------
--- ITEM EVENT CODE ---
----------------------------------------------------------------------
-- EVENT_TRADE_ITEM_ADDED
function FriendAutoTrade.ItemAdded(eventCode, who, tradeIndex, itemSoundCategory)
	if FriendAutoTrade.isTradeRight() then
		if who == 0 then
			FriendAutoTrade.var.tradeSlots = FriendAutoTrade.var.tradeSlots + 1;
			if FriendAutoTrade.var.tradeSlots < 5 then
				FriendAutoTrade.AddItem();
			elseif FriendAutoTrade.savedVar.AutoAccept and FriendAutoTrade.var.tradeSlotsFriend >= 5 then
				TradeAccept();
			end
		else
			FriendAutoTrade.var.tradeSlotsFriend = FriendAutoTrade.var.tradeSlotsFriend + 1;
			FriendAutoTrade.addToNewItems(GetTradeItemLink(who, tradeIndex, LINK_STYLE_DEFAULT));
		end
	end
end
-- EVENT_TRADE_ITEM_ADD_FAILED
function FriendAutoTrade.ItemAddFailed(eventCode, reason, itemName)
	if FriendAutoTrade.isTradeRight() then
		FriendAutoTrade.AddItem();
	end
end
-- EVENT_TRADE_ITEM_REMOVED
function FriendAutoTrade.ItemRemoved(eventCode, who, tradeIndex, itemSoundCategory)
	if FriendAutoTrade.isTradeRight() then
		if who == 0 then
			FriendAutoTrade.var.tradeSlots = FriendAutoTrade.var.tradeSlots - 1;
			FriendAutoTrade.AddItem();
		else
			FriendAutoTrade.var.tradeSlotsFriend = FriendAutoTrade.var.tradeSlotsFriend - 1;
			FriendAutoTrade.removeFromNewItems(GetTradeItemLink(who, tradeIndex, LINK_STYLE_DEFAULT));
		end
	end
end

----------------------------------------------------------------------
--- Trade EVENT CODE ---
----------------------------------------------------------------------
-- EVENT_TRADE_CANCELED -- EVENT_TRADE_FAILED
function FriendAutoTrade.TradeFailed(eventCode, reason)
	--if FriendAutoTrade.isTradeRight() then
		FriendAutoTrade.TradeCleanUp();
	--end
end
-- EVENT_TRADE_CONFIRMATION_CHANGED
function FriendAutoTrade.ConfirmationChanged(eventCode, who, level)
	if FriendAutoTrade.isTradeRight() and FriendAutoTrade.savedVar.AutoAccept and 1 == who then
		zo_callLater(function() TradeAccept() end, 3000);
	end
end
-- EVENT_TRADE_SUCCEEDED
function FriendAutoTrade.Succeeded(eventCode)
	if FriendAutoTrade.isTradeRight() then
		FriendAutoTrade.var.time = GetTimeStamp();
		--The extra trade is so recipes can be traded around until they land in right spot
		if FriendAutoTrade.var.tradeSlots == 0 and FriendAutoTrade.var.tradeSlotsFriend == 0 then
			FriendAutoTrade.TradeCleanUp();
		elseif FriendAutoTrade.var.invitee then
			TradeInviteByName(FriendAutoTrade.savedVar.partnerToTrade);
		end
	end
end