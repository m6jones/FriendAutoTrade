--[[-----------------------------------------------------------------------------------------------
--  Item Blacksmithing Class (FriendAutoTrade.ItemType.blacksmithing) --
 	- Class contains information about blacksmithing Items.
-- Public Methods --
	
-- Static Methods --
	FriendAutoTrade.ItemType.blacksmithing.Make(slot) constructs a blacksmithing item

--]]-----------------------------------------------------------------------------------------------
--Holds basic information about blacksmithing Class
FriendAutoTrade.ItemCategory["blacksmithing"] = {
	name = "Blacksmithing",
	settings = {
		length = 6,
		"Armor",
		"Weapons",
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
function FriendAutoTrade.ItemCategory.blacksmithing.Make(item)
	local public = {};
	local private = {};
	local self = {
		["item"] = item,
		itemCategory = "blacksmithing",
		weaponTypes = {
			WEAPONTYPE_AXE,
			WEAPONTYPE_DAGGER,
			WEAPONTYPE_HAMMER,
			WEAPONTYPE_SWORD,
			WEAPONTYPE_TWO_HANDED_AXE,
			WEAPONTYPE_TWO_HANDED_HAMMER,
			WEAPONTYPE_TWO_HANDED_SWORD,
		},
	};
	-- Public Methods --
		public.is = {}; -- This allows use to just use settings to call the correctFunction.
		-- Adding methods to the is table
		public.is["Armor"] = function ()
			local armorType = self.item.GetPropWithFunction("itemArmorType", GetItemLinkArmorType);
			return (armorType == ARMORTYPE_HEAVY);
		end
		public.is["Weapons"] = function ()
			local itemWT = self.item.GetPropWithFunction("itemWeaponType", GetItemLinkWeaponType);
			local isWeapon = false;
			for i, weaponType in ipairs(self.weaponTypes) do
				isWeapon = isWeapon or (weaponType == itemWT);
			end
			
			return isWeapon;
		end
		public.is["Raw Material"] = function ()
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			return (itemType == ITEMTYPE_BLACKSMITHING_RAW_MATERIAL);
		end
		public.is.Material = function ()
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			return (itemType == ITEMTYPE_BLACKSMITHING_MATERIAL);
		end
		public.is.Boosters = function ()
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			return (itemType == ITEMTYPE_BLACKSMITHING_BOOSTER);
		end
		public.is.Rank = function()
			return false; --Makes sure that the other properties are satisfied. This is checked on creation.
		end
	-- Public Constructor --
		private.Initialize = function()
			if not private.isBlacksmithing() then
				return false;
			end
			return public;
		end
		
	-- PRIVATE Methods --
		--Checks to see if item is a blacksmithing item
		private.isBlacksmithing = function()
			local craftingSkillType = self.item.GetPropWithFunction("craftingSkillType", GetItemLinkCraftingSkillType);
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			local isRankTradable = self.item.isRankTradable(self.itemCategory);
			
			local result = craftingSkillType == CRAFTING_TYPE_BLACKSMITHING;
			result = result or (ITEMTYPE_ARMOR == itemType);
			result = result or (ITEMTYPE_WEAPON == itemType);
			result = result and isRankTradable;
			
			return result;
		end
		
	-- Initializer Call --
		return private.Initialize();
end
------------------------------------------------------
--- Static ---
------------------------------------------------------