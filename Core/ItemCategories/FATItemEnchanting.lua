--[[-----------------------------------------------------------------------------------------------
--  Item Enchanting Class (FriendAutoTrade.ItemType.enchanting) --
 	- Class contains information about enchanting Items.
-- Public Methods --
	
-- Static Methods --
	FriendAutoTrade.ItemType.enchanting.Make(slot) constructs a enchanting item

--]]-----------------------------------------------------------------------------------------------
--Holds basic information about enchanting Class
FriendAutoTrade.ItemCategory["enchanting"] = {
	name = "Enchanting",
	settings = {
		length = 1,
		"All Enchanting Items",
	},
}
------------------------------------------------------
--- Class ---
------------------------------------------------------
function FriendAutoTrade.ItemCategory.enchanting.Make(item)
	local public = {};
	local private = {};
	local self = {
		["item"] = item,
		itemCategory = "enchanting"
	};
	-- Public Methods --
		public.is = {}; -- This allows use to just use settings to call the correctFunction.
		-- Adding methods to the is table
		public.is["All Enchanting Items"] = function ()
			return true;
		end
	-- Public Constructor --
		private.Initialize = function()
			if not private.isEnchanting() then
				return false;
			end
			return public;
		end
		
	-- PRIVATE Methods --
		--Checks to see if item is a enchanting item
		private.isEnchanting = function()
			local craftingSkillType = self.item.GetPropWithFunction("craftingSkillType", GetItemLinkCraftingSkillType);
			
			local result = craftingSkillType == CRAFTING_TYPE_ENCHANTING;
			return result;
		end
		
	-- Initializer Call --
		return private.Initialize();
end
------------------------------------------------------
--- Static ---
------------------------------------------------------