local alreadychecked = {}
local Looted_EventFrame = CreateFrame("Frame")
Looted_EventFrame:RegisterEvent("LOOT_CLOSED")
Looted_EventFrame:SetScript("OnEvent", function(self, event, ...)
        local arg1 = ...
        local lootInfo = GetLootInfo()
        print('Congratulations on looting.')
        for i = 0, 4
            do
                --lootIcon, lootName, lootQuantity, lootQuality, locked, isQuestItem, questID, isActive = GetLootSlotInfo(i)
                --itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(lootName)
            	numSlots = GetContainerNumSlots(i)
            	for j = 1, numSlots
            		do
            			texture, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID = GetContainerItemInfo(i, j)
            			if itemLink then
            				itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(itemLink)
        					if (bindType == 2) then
        						checkedItem = isAlreadyChecked(itemLink)
        						if not checkedItem then
        							scanTooltip(itemLink)
        							table.insert(alreadychecked, itemLink)
        						end
        					end
        				end
            		end
            end
    end)

function isAlreadyChecked(itemLink)
	for _, items in pairs(alreadychecked) do
		if items == itemLink then
			return true
		end
	end
	return false
end

local function scanTooltip_helper(...)
  for i = 1, select("#", ...) do
    local region = select(i, ...)
      if region and region:GetObjectType() == "FontString" then
      local text = region:GetText()
        if (text == TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) then -- If a line in the tooltip matches this string, it means it is a new appearance.
          return true
        end
      end
    end
  return false
end

function scanTooltip (itemLink)
  local tip = myTooltip or CreateFrame("GAMETOOLTIP", "myTooltip")
  local L = L or tip:CreateFontString()
  local R = R or tip:CreateFontString()
  L:SetFontObject(GameFontNormal)
  R:SetFontObject(GameFontNormal)
  tip:AddFontStrings(L,R)
  tip:SetOwner(WorldFrame, "ANCHOR_NONE")
  local link = select(2, GetItemInfo(itemLink))
  tip:SetHyperlink(link)
  isNewAppearance = scanTooltip_helper(myTooltip:GetRegions())
  if isNewAppearance == true then
  	print("|cffff0000 The BoE item " .. itemLink .. "|cffff0000 is in your bags and you still need the appearance")
  end
end
