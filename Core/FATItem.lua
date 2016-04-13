--[[-----------------------------------------------------------------------------------------------
--  Item Class (FriendAutoTrade.Item) --
- 	Class will determine if an item from your bag should be traded holding on to important
	information as required.
-- Public Methods --
	GetLink() 	
		- Returns the items link string.
	CreateProperty(key, value)
		- Adds property to item with key and value.
		- If property already exists then nothing happens, property keeps old value.
	GetProperty(key)
		- Returns the value of property at key, if it doesn't exists returns nil.
	GetPropWithFunction(key, func = function(link))
		- Get property with key.
		- If property doesn't exists then property is created with function value
		- returns value
	doAddToTrade(item)
		- Checks to see if item is to be traded
	determineRank()
		- Returns the craftingRank of an item. 
		- Currently, works for any crafting item, as well as, armor and weapons.
	isRankTradable(itemCategory, (optional) rank)
		- Takes in itemCategory and checks if item rank is tradable.
		- if crafting rank is 0, it will return true.
	public.doAddToNeededItems(item)
-- Static Methods --
	SettingMenuTable(itemCategory)
		- Makes a SubMenu Setting based on the saved variables of item type
		- itemCategory is a string of the type of item defined in FriendAutoTrade.FilterTable
		- returns a sub menu for LAM controls.
--]]-----------------------------------------------------------------------------------------------

------------------------------------------------------
--- Class ---
------------------------------------------------------
FriendAutoTrade.Item = {};
FriendAutoTrade.ItemCategory = {};
function FriendAutoTrade.Item.Make(link, slot)
	local public = {};
	local private = {};
	local self = {
		["link"] = link, --keeping track of what is in self for easy reference.
		["slot"] = slot,
	};
	-- Public Methods --
		--Gets the link Value for the item
		public.GetLink = function () 
			return self.link;
		end
		--Creates a read only property. 
		-- If the property already exists it doesn't change.
		-- On the other hand if it doesn't exists then it creates 
		-- it with the value
		public.CreateProperty = function(key,value)
			self[key] = self[key] or value;
		end
		--Returns the value of property at key, if it doesn't exists returns nil.
		public.GetProperty = function(key)
			return self[key];
		end
		-- Get property with key.
		-- If property doesn't exists then property is created with function value
		public.GetPropWithFunction = function(key, func)
			--Grabs the value from either property table or function
			value = public.GetProperty(key) or func(self.link);
			--Make sure the property is then added to the table
			public.CreateProperty(key,value);
			return value;
		end
		
		public.doAddToTrade = function(item)
			for itemCategory, value in pairs(FriendAutoTrade.ItemCategory) do
				if private.isTradableItemType(item, itemCategory) then
					return true;
				end
			end
			
			return false;
		end
		
		public.doAddToNeededItems = function(item)
			for itemCategory, value in pairs(FriendAutoTrade.ItemCategory) do
				if private.isNeededItem(item, itemCategory) then
					return true;
				end
			end
			
			return false;
		end
		--Determines the crafting rank of an item and "craftingRank", GetItemLinkRequiredCraftingSkillRank
		public.determineRank = function ()
			local craftingRank = public.GetPropWithFunction("craftingRank", GetItemLinkRequiredCraftingSkillRank);
			if craftingRank == 0 then
				local level = GetItemLinkRequiredLevel(public.GetLink());
				-- Check to see if item has a level, if not then return 0 as crafting rank;
				if level or level == 0 then 
					-- Note I don't need to set craftingRank property to 0 since it is already 0
					return 0;
				end
				local craftingRank = math.floor((level - 5) / 10) + 1;
				
				if craftingRank < 1 then
					craftingRank = 1;
				elseif craftingRank == 5 then
					craftingRank =  math.ceil(GetItemLinkRequiredVeteranRank(public.GetLink())/3) + 5;
				end
				
				self["craftingRank"] = craftingRank; --Update the craftingRank property.
			end
			
			return craftingRank;
		end
		--Checks to see if item meets rank requirements:
		public.isRankTradable = function(itemCategory, rank)
			local rank = rank or public.determineRank();
			if rank == 0 then return true; end --Incase an item doesn't have a rank. So bypass this check.
			
			local rankName = FriendAutoTrade.ItemCategory[itemCategory].settings["Rank"][rank];
			
			return FriendAutoTrade.savedVar[itemCategory]["Rank"][rankName];
		end
	-- Public Constructor --
		-- What is returned after calling FriendAutoTrade.Item
		private.Initialize = function()
			-- Returns Public Table or false
			if private.isNotTradable() then 
				return false;
			else
				return public;
			end
		end

	-- PRIVATE Methods --
		-- Checks to see if item is tradable and sets up item link.
		private.isNotTradable = function()
			local result = IsItemLinkBound(self.link);
			result = result or IsItemLinkStolen(self.link);
			
			return result;
		end
		
		-- Will see if item is good for to add to trade
		-- takes an itemCategory
		-- return true if item is to be traded, false if item is not to be trading 
		-- with the information from the current itemCategory.
		private.isTradableItemType = function(item, itemCategory)
			if FriendAutoTrade.savedVar[itemCategory].numTruths ~= 0 then
				local extItem = FriendAutoTrade.ItemCategory[itemCategory].Make(item);
				if extItem then
					local settings = FriendAutoTrade.ItemCategory[itemCategory].settings;
					local savedVar = FriendAutoTrade.savedVar[itemCategory];
					
					for i=1, settings.length do 
						if savedVar[settings[i]] and extItem.is[settings[i]]() then
								return true;
						end
					end
				end
			end
			return false;
		end
		--Checks to see if item is needed after being traded the item
		private.isNeededItem = function(item, itemCategory)
			local neededFriendItems = FriendAutoTrade.ItemCategory[itemCategory].neededFriendItems;
			if neededFriendItems then
				local extItem = FriendAutoTrade.ItemCategory[itemCategory].Make(item);
				if extItem then
					for key, nFI in pairs(neededFriendItems) do 
						if extItem.is[nFI]() then
							return true;
						end
					end
				end
			end
			return false;
		end
	-- Initializer Call --
		return private.Initialize();
end
------------------------------------------------------
--- Static ---
------------------------------------------------------
function FriendAutoTrade.Item.MakeBySlot(slot)
	--Lets not doing anything if there is no item
	if not HasItemInSlot(BAG_BACKPACK, slot) then 
		return false; 
	end
	--Lets make sure the item isn't locked
	local icon, stack, sellPrice, meetsUsageRquirement, locked = GetItemInfo(BAG_BACKPACK, slot);
	if locked then 
		return false; 
	end
	--Adds support for FCO ItemSaver
	if FCOIsMarked ~= nil and FCOIsMarked(GetItemInstanceId(BAG_BACKPACK, slot), -1) then
		return false;
	end
	return  FriendAutoTrade.Item.Make(GetItemLink(BAG_BACKPACK, slot), slot);
end
--Makes a SubMenu Setting based on the saved variables of item type
	-- itemCategory is a string of the type of item defined in FriendAutoTrade.ItemCategory
function FriendAutoTrade.Item.SettingMenuTable(itemCategory)
	local subOptions = {};
	local nameOfType = FriendAutoTrade.ItemCategory[itemCategory].name;
	local settings = FriendAutoTrade.ItemCategory[itemCategory].settings;
	
	for i=1, settings.length do
		local k = settings[i];
		if settings[k] then
			--Make a submenu for when there a table
			subOptions[i] = FriendAutoTrade.Item.PRI_SubSettingMenu(itemCategory, k, settings[k]);
		else 
			--The default checkbox
			subOptions[i] = {
				type = "checkbox",
				name = k,
				tooltip = "Sets ".. string.lower(k) .." to be traded in " .. string.lower(nameOfType) .. " items.",
				getFunc = function ()
						return FriendAutoTrade.savedVar[itemCategory][k];
					end,
				setFunc = function(value)
						FriendAutoTrade.Item.PRI_AddToCounter(itemCategory, value)
						FriendAutoTrade.savedVar[itemCategory][k] = value;
					end,
				default = false,
				disabled = function () return not FriendAutoTrade.savedVar.on end,
			};
		end
	end
	subOptions[settings.length+1] = {
		type = "button",
		name = "Select/Disable All",
		tooltip = "Select or disable all in " .. string.lower(nameOfType) .. ".",
		func = function ()
				 FriendAutoTrade.Item.PRI_ToggleAllSavedVarsIn(itemCategory);
			end,
		disabled = function () return not FriendAutoTrade.savedVar.on end,
	};
	return {
		type = "submenu",
		name = nameOfType,
		tooltip = "Select which type of items to trade form ".. string.lower(nameOfType) ..".",
		controls = subOptions,
	};
end

--Loads the save values into default
function FriendAutoTrade.Item.LoadDefaultValues()
	for itemCategory,itemTable in pairs(FriendAutoTrade.ItemCategory) do
		FriendAutoTrade.var.default[itemCategory] = FriendAutoTrade.Item.PRI_BuildTableFromArray(itemTable.settings);
		FriendAutoTrade.var.default[itemCategory]["numTruths"] = 0;
	end
end
------------------------------------------------------
--- PRIVATE Static ---
------------------------------------------------------
--RankSettingMenu( string itemCategory,table subTable)
		-- Creates a control table for sub tables in saveVar  for LAM2
		-- itemCategory is a string of the type of item defined in FriendAutoTrade.FilterTable
		-- key is the key of the subtable in the main table
		-- subTable is a table from the saved variable table where they Keys are used as the name.
		-- returns a control table for selecting different ranks for LAM2.
function FriendAutoTrade.Item.PRI_SubSettingMenu(itemCategory, key, order)
	local nameOfType = string.lower(FriendAutoTrade.ItemCategory[itemCategory].name);
	local subOptions = { };
	
	for i=1, order.length do
		local k = order[i];
		subOptions[i] = {
			type = "checkbox",
			name = tostring(k),
			tooltip = "Sets ".. string.lower(k) .." to be traded in " .. nameOfType .. " items.",
			getFunc = function ()
					return FriendAutoTrade.savedVar[itemCategory][key][k];
				end,
			setFunc = function(value)
					--LAM doesn't support 3 nested submenus
					--FriendAutoTrade.Item.PRI_AddToCounter(itemCategory, value)
					FriendAutoTrade.savedVar[itemCategory][key][k] = value;
				end,
			default = false,
			--disabled = function () return not FriendAutoTrade.savedVar.on end,
		}
	end
	return {
		type = "submenu",
		name = key,
		tooltip = "Select which " .. string.lower(key) .. " to trade for " .. nameOfType .. " items.",
		controls = subOptions,
	};
end
--Flips all the variables in saved variables for items. 
--Currently works because all of them are true or false...
--Needs to be cleaned
function FriendAutoTrade.Item.PRI_ToggleAllSavedVarsIn(itemCategory, subTable)
	subTable = subTable or FriendAutoTrade.savedVar[itemCategory];
	
	--Set the value, if no value is on then turn them on otherwise turn them all off
	local value = false;
	if FriendAutoTrade.savedVar[itemCategory].numTruths == 0 then 
		value = true;
	end
	--Now go through the save variables and set them to value
	for k, v in pairs(subTable) do
		if k == "numTruths" or FriendAutoTrade.savedVar[itemCategory][k] == value then
			-- Don't do anything in this case
		--This case is commented out since lib doesn't update within subtables.
		elseif type(v) == "table" then
			--Make a submenu for when there a table
			--FriendAutoTrade.Item.ToggleAllSavedVarsIn(itemCategory, v);
		else 
			FriendAutoTrade.savedVar[itemCategory][k] = value;
			FriendAutoTrade.Item.PRI_AddToCounter(itemCategory, value);
		end
	end
end
--Helper function FriendAutoTrade.Item.LoadDefaultValues()
function FriendAutoTrade.Item.PRI_BuildTableFromArray(array)
	local t = {};
	for i=1, array.length do
		local key = array[i];
		if array[key] then
			t[key] = FriendAutoTrade.Item.PRI_BuildTableFromArray(array[key]);	
		else
			t[key] = false;
		end
	end
	return t;
end

function FriendAutoTrade.Item.PRI_AddToCounter(itemCategory, value)
	local n = FriendAutoTrade.savedVar[itemCategory].numTruths;
	if value then 
		FriendAutoTrade.savedVar[itemCategory].numTruths = 1 + n 
	else 
		FriendAutoTrade.savedVar[itemCategory].numTruths = n-1
	end
end