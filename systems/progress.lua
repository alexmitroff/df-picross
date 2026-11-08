-- Global progress. Track of all solved puzzels.
local puzzles = require "levels.puzzles"

local M = {}

local SAVE_PATH = sys.get_save_file("harbour_picross", "progress")


local function is_integer(input)
	-- Because Lua does not have integer number as the data type
	-- https://www.lua.org/pil/2.3.html
	return type(input) == "number" and input % 1 == 0
end


local function get_progress_key(category_index, level_index)
	return category_index .. "_" .. level_index
end


local function default_data()
	return {
		completed = {}
	}
end


local function load_data()
	local ok, data = pcall(sys.load, SAVE_PATH)

	if not ok or type(data) ~= "table" then
		print("Unable to load progress:", tostring(data))
		return default_data()
	end

	if type(data.completed) ~= "table" then
		return default_data()
	end

	return data
end


local function save_data(data)
	local ok, err = pcall(sys.save, SAVE_PATH, data)
	if not ok then
		print("Unable to save progress:", tostring(err))
		return false
	end
	return true
end


local function level_exists(category_index, level_index)
	if not is_integer(category_index) or not is_integer(level_index) then return false end
	return puzzles.get(category_index, level_index) ~= nil
end


function M.is_completed(category_index, level_index)
	if not level_exists(category_index, level_index) then return false end

	local data = load_data()
	return data.completed[get_progress_key(category_index, level_index)] == true
end


function M.complete(category_index, level_index)
	if not level_exists(category_index, level_index) then
		print("Unknown puzzle:", tostring(category_index), tostring(level_index))
		return false
	end

	local data = load_data()
	local key = get_progress_key(category_index, level_index)
	if data.completed[key] then return true	end
	data.completed[key] = true

	if save_data(data) then
		print( "Progress saved:", category_index, level_index)
		return true
	end

	return false
end



function M.category_progress(category_index)
	local category = puzzles.categories[category_index]
	if not category then return 0, 0 end

	local data = load_data()
	local completed = 0

	for level_index = 1, #category.levels do
		if data.completed[get_progress_key(category_index, level_index)] == true then completed = completed + 1 end
	end

	return completed, #category.levels
end


function M.is_category_completed(category_index)
	local completed, total = M.category_progress(category_index)
	return total > 0 and completed == total
end



function M.is_category_unlocked(category_index)
	if not is_integer(category_index) then	return false end
	if not puzzles.categories[category_index] then return false	end

	-- First category is always available.
	if category_index == 1 then	return true	end

	-- All puzzles in the preceding category
	-- must be completed.
	return M.is_category_completed(category_index - 1)
end


function M.reset()
	return save_data(default_data())
end


return M
