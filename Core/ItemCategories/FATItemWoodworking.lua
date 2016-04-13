--[[-----------------------------------------------------------------------------------------------
--  Item Woodworking Class (FriendAutoTrade.ItemType.woodworking) --
 	- Class contains information about woodworkingItems.
-- Public Methods --
	
-- Static Methods --
	FriendAutoTrade.ItemType.woodworking.Make(slot) constructs a woodworking item

--]]-----------------------------------------------------------------------------------------------
--Holds basic information about woodworking Class
FriendAutoTrade.ItemCategory["woodworking"] = {
	name = "Woodworking",
	settings = {
		length = 6,
		"Shields",
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
function FriendAutoTrade.ItemCategory.woodworking.Make(item)
	local public = {};
	local private = {};
	local self = {
		["item"] = item,
		itemCategory = "woodworking",
		weaponTypes = {
			WEAPONTYPE_BOW,
			WEAPONTYPE_FIRE_STAFF,
			WEAPONTYPE_FROST_STAFF,
			WEAPONTYPE_HEALING_STAFF,
			WEAPONTYPE_LIGHTNING_STAFF,
		},
	};
	-- Public Methods --
		public.is = {}; -- This allows use to just use settings to call the correctFunction.
		-- Adding methods to the is table
		public.is["Shields"] = function ()
			local itemWT = self.item.GetPropWithFunction("itemWeaponType", GetItemLinkWeaponType);
			return (itemWT == WEAPONTYPE_SHIELD);
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
			return (itemType == ITEMTYPE_WOODWORKING_RAW_MATERIAL);
		end
		public.is.Material = function ()
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			return (itemType == ITEMTYPE_WOODWORKING_MATERIAL);
		end
		public.is.Boosters = function ()
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			return (itemType == ITEMTYPE_WOODWORKING_BOOSTER);
		end
		public.is.Rank = function()
			return false; --Makes sure that the other properties are satisfied. This is checked on creation.
		end
	-- Public Constructor --
		private.Initialize = function()
			if not private.isWoodworking() then
				return false;
			end
			return public;
		end
		
	-- PRIVATE Methods --
		--Checks to see if item is a woodworking item
		private.isWoodworking = function()
			local craftingSkillType = self.item.GetPropWithFunction("craftingSkillType", GetItemLinkCraftingSkillType);
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			local isRankTradable = self.item.isRankTradable(self.itemCategory);
			
			local result = craftingSkillType == CRAFTING_TYPE_WOODWORKING;
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