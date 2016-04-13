--[[-----------------------------------------------------------------------------------------------
--  Item Misc Class (FriendAutoTrade.ItemType.misc) --
 	- Class contains information about misc Items.
-- Public Methods --
	
-- Static Methods --
	FriendAutoTrade.ItemType.misc.Make(slot) constructs a misc item

--]]-----------------------------------------------------------------------------------------------
--Holds basic information about misc Class
FriendAutoTrade.ItemCategory["misc"] = {
	name = "Misc",
	settings = {
		length = 2,
		"All Soulgems",
		"Empty Soulgems",
	},
}
------------------------------------------------------
--- Class ---
------------------------------------------------------
function FriendAutoTrade.ItemCategory.misc.Make(item)
	local public = {};
	local private = {};
	local self = {
		["item"] = item,
		itemCategory = "misc"
	};
	-- Public Methods --
		public.is = {}; -- This allows use to just use settings to call the correctFunction.
		-- Adding methods to the is table
		public.is["All Soulgems"] = function ()
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			return itemType == ITEMTYPE_SOUL_GEM;
		end
		-- Need to find a better way to tell if it is an empty soulgem
		public.is["Empty Soulgems"] = function ()
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			local slot = self.item.GetProperty('slot');
			if slot and itemType == ITEMTYPE_SOUL_GEM then
				local level, isEmpty = GetSoulGemItemInfo(BAG_BACKPACK, slot);
				if isEmpty == SOUL_GEM_TYPE_EMPTY then
					return true;
				end
			end
			return false;
		end
	-- Public Constructor --
		private.Initialize = function()
			return public;
		end
		
	-- PRIVATE Methods --
		
	-- Initializer Call --
		return private.Initialize();
end
------------------------------------------------------
--- Static ---
------------------------------------------------------