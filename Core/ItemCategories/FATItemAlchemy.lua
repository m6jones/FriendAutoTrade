--[[-----------------------------------------------------------------------------------------------
--  Item Alchemy Class (FriendAutoTrade.ItemType.alchemy) --
 	- Class contains information about alchemy Items.
-- Public Methods --
	
-- Static Methods --
	FriendAutoTrade.ItemType.alchemy.Make(slot) constructs a alchemy item

--]]-----------------------------------------------------------------------------------------------
--Holds basic information about alchemy Class
FriendAutoTrade.ItemCategory["alchemy"] = {
	name = "Alchemy",
	settings = {
		length = 1,
		"All Alchemy Items",
	},
}
------------------------------------------------------
--- Class ---
------------------------------------------------------
function FriendAutoTrade.ItemCategory.alchemy.Make(item)
	local public = {};
	local private = {};
	local self = {
		["item"] = item,
		itemCategory = "alchemy"
	};
	-- Public Methods --
		public.is = {}; -- This allows use to just use settings to call the correctFunction.
		-- Adding methods to the is table
		public.is["All Alchemy Items"] = function ()
			return true;
		end
	-- Public Constructor --
		private.Initialize = function()
			if not private.isAlchemy() then
				return false;
			end
			return public;
		end
		
	-- PRIVATE Methods --
		--Checks to see if item is a alchemy item
		private.isAlchemy = function()
			local craftingSkillType = self.item.GetPropWithFunction("craftingSkillType", GetItemLinkCraftingSkillType);
			
			local result = craftingSkillType == CRAFTING_TYPE_ALCHEMY;
			return result;
		end
		
	-- Initializer Call --
		return private.Initialize();
end
------------------------------------------------------
--- Static ---
------------------------------------------------------