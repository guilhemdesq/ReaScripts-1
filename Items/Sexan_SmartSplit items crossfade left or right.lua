--[[
 * ReaScript Name: SmartSplit items crossfade left or right
 * About: This is two action split script, normal split and time selection split.If time selection split already
 *              exists then you can freely split anywhere while time selection is still active.
 *              Normal split creates crossfade on the side where the mouse cursor is depending on edit cursor
 * Author: SeXan
 * Licence: GPL v3
 * REAPER: 5.0
 * Extensions: SWS
 * Version: 1.01
--]]
 
--[[
 * Changelog:
 * v1.01 (2017-07-13)
--]]

local edit_cursor_pos = reaper.GetCursorPosition()
local _, _, mouse_pos = reaper.BR_TrackAtMouseCursor()

local function cross_fade_pos()
  if edit_cursor_pos > mouse_pos then 
    reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_AWSPLITXFADELEFT"), 0)
  else
    reaper.Main_OnCommand(40759,0)
  end
end

local function Main()
  local count_sel_items = reaper.CountSelectedMediaItems(0)
    if count_sel_items > 0 then
      SmartSplit()
    end  
end

function SmartSplit()
  local item = reaper.GetSelectedMediaItem(0, 0)
  local item_start = reaper.GetMediaItemInfo_Value(item,"D_POSITION")
  local item_len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH")
  local item_end = item_start + item_len
  local Tstart, Tend = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)   
        
    --is item in TS
  if Tstart <= item_start and Tend >= item_end then cross_fade_pos()
    
    --is item outside TS (left side)
  elseif Tstart > item_start and Tstart >= item_end then cross_fade_pos()
     
    --is item outside TS (left side but end in TS)
  elseif Tstart > item_start and Tend > item_end then cross_fade_pos()
    
    --is item outside TS (right side)
  elseif Tend <= item_start and Tend < item_end then cross_fade_pos()
     
    --is item outside TS (right side but start in TS)
  elseif Tstart < item_start and Tend < item_end then cross_fade_pos()
           
           
  elseif Tstart == Tend then cross_fade_pos()
    
    --is item over TS
  elseif Tstart >= item_start and Tend <= item_end then
    reaper.Main_OnCommand(40061, 0)
  end
  
end

Main()
