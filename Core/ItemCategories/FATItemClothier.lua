--[[-----------------------------------------------------------------------------------------------
--  Item clothier Class (FriendAutoTrade.ItemType.clothier) --
 	- Class contains information about clothier Items.
-- Public Methods --
	
-- Static Methods --
	FriendAutoTrade.ItemType.clothier.Make(slot) constructs a clothier item

--]]-----------------------------------------------------------------------------------------------
--Holds basic information about clothier Class
FriendAutoTrade.ItemCategory["clothier"] = {
	name = "Clothier",
	settings = {
		length = 6,
		"Light Armor",
		"Medium Armor",
		"Raw Material",
		"Material",
		"Boosters",
		"Rank",
		Rank = {
			length = 9,
			"Rank 1", 
			"Rank 2", 
			"Rank 3", 
			"Rank 4", 
			"Rank 5", 
			"Rank 6",
			"Rank 7",
			"Rank 8",
			"Rank 9",
		},
	},
}
------------------------------------------------------
--- Class ---
------------------------------------------------------
function FriendAutoTrade.ItemCategory.clothier.Make(item)
	local public = {};
	local private = {};
	local self = {
		["item"] = item,
		itemCategory = "clothier",
	};
	-- Public Methods --
		public.is = {}; -- This allows use to just use settings to call the correctFunction.
		-- Adding methods to the is table
		public.is["Light Armor"] = function ()
			local armorType = self.item.GetPropWithFunction("itemArmorType", GetItemLinkArmorType);
			return (armorType == ARMORTYPE_LIGHT);
		end
		public.is["Medium Armor"] = function ()
			local armorType = self.item.GetPropWithFunction("itemArmorType", GetItemLinkArmorType);
			return (armorType == ARMORTYPE_MEDIUM);
		end
		public.is["Raw Material"] = function ()
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			return (itemType == ITEMTYPE_CLOTHIER_RAW_MATERIAL);
		end
		public.is.Material = function ()
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			return (itemType == ITEMTYPE_CLOTHIER_MATERIAL);
		end
		public.is.Boosters = function ()
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			return (itemType == ITEMTYPE_CLOTHIER_BOOSTER);
		end
		public.is.Rank = function()
			return false; --Makes sure that the other properties are satisfied. This is checked on creation.
		end
	-- Public Constructor --
		private.Initialize = function()
			if not private.isClothier() then
				return false;
			end
			return public;
		end
		
	-- PRIVATE Methods --
		--Checks to see if item is a clothier item
		private.isClothier = function()
			local craftingSkillType = self.item.GetPropWithFunction("craftingSkillType", GetItemLinkCraftingSkillType);
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			local isRankTradable = self.item.isRankTradable(self.itemCategory);
			
			local result = craftingSkillType == CRAFTING_TYPE_CLOTHIER;
			result = result or (ITEMTYPE_ARMOR == itemType);
			result = result and isRankTradable;
			
			return result;
		end
		
	-- Initializer Call --
		return private.Initialize();
end
------------------------------------------------------
--- Static ---
------------------------------------------------------