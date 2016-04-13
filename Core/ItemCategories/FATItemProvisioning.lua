--[[-----------------------------------------------------------------------------------------------
--  Item Provisioning Class (FriendAutoTrade.ItemType.Provisionging) --
 	- Class contains information about Provisioning Items.
-- Public Methods --
	is.Food()
	is.Beverage()
	is.Fish()
	is.Recipes()
	is.["Known Recipes"]()
	is.Rank()
-- Static Methods --
	FriendAutoTrade.ItemType.Provisioning.Make(slot) constructs a provisioning item

--]]-----------------------------------------------------------------------------------------------
--Holds basic information about Provisiong Class
FriendAutoTrade.ItemCategory["provisioning"] = {
	name = "Provisioning",
	settings = {
		length = 6,
		"Food",
		"Beverages",
		"Fish",
		"Recipes",
		"Known Recipes",
		"Rank",
		Rank = {
			length = 6,
			"Rank 1", 
			"Rank 2", 
			"Rank 3", 
			"Rank 4", 
			"Rank 5", 
			"Rank 6", 
		},
	},
	neededFriendItems = {
		"New Recipes",
	}
}
------------------------------------------------------
--- Class ---
------------------------------------------------------
function FriendAutoTrade.ItemCategory.provisioning.Make(item)
	local public = {};
	local private = {};
	local self = {["item"] = item};
	-- Public Methods --
		public.is = {}; -- This allows use to just use settings to call the correctFunction.
		-- Adding methods to the is table
		public.is.Food = function ()
			local flavorText = self.item.GetPropWithFunction("flavorText", GetItemLinkFlavorText);
			return flavorText:find("food") and true or false;
		end
		public.is.Beverages = function ()
			local flavorText = self.item.GetPropWithFunction("flavorText", GetItemLinkFlavorText);
			return flavorText:find("beverages") and true or false;
		end
		public.is.Fish = function ()
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			return (itemType == ITEMTYPE_FISH);
		end
		public.is.Recipes = function ()
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			return (itemType == ITEMTYPE_RECIPE);
		end
		public.is["Known Recipes"] = function ()
			return IsItemLinkRecipeKnown(self.item.GetLink());
		end
		public.is.Rank = function()
			return false; --Makes sure that the other properties are satisfied. This is checked on creation.
		end	
		public.is["New Recipes"] = function ()
			return not public.is["Known Recipes"]();
		end
	-- Public Constructor --
		private.Initialize = function()
			if not private.isProvisioning() then
				return false;
			end
			return public;
		end
		
	-- PRIVATE Methods --
		--Checks to see if item is a provisioning item
		private.isProvisioning = function()
			local craftingSkillType = self.item.GetPropWithFunction("craftingSkillType", GetItemLinkCraftingSkillType);
			local itemType = self.item.GetPropWithFunction("itemType", GetItemLinkItemType);
			local isRankTradable = private.isRankTradable();
			
			local result = craftingSkillType == CRAFTING_TYPE_PROVISIONING;
			result = result or public.is.Recipes();
			result = result or public.is.Fish();
			result = result and isRankTradable;
			
			return result;
		end
		--Gets craftingRank
		private.isRankTradable = function()
			local craftingRank = self.item.GetPropWithFunction("craftingRank", GetItemLinkRequiredCraftingSkillRank);
			if craftingRank == 0 then 
				craftingRank = GetItemLinkRecipeRankRequirement(self.item.GetLink());
			end
			
			return self.item.isRankTradable("provisioning", craftingRank);
		end
	-- Initializer Call --
		return private.Initialize();
end
------------------------------------------------------
--- Static ---
------------------------------------------------------