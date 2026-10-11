
local catalog = require "levels.catalog"

local M = {}

local SAVE_PATH = sys.get_save_file("harbour_picross", "progress")


local function default_data()
	return {
		version = 1,
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


local function level_exists(level_id)
	for _, category in ipairs(catalog.categories) do
		for _, level in ipairs(category.levels) do
			if level.id == level_id then
				return true
			end
		end
	end
	return false
end


function M.is_completed(level_id)
	local data = load_data()
	return data.completed[level_id] == true
end


function M.complete(level_id)
	if not level_exists(level_id) then
		print("Unknown level:", tostring(level_id))
		return false
	end

	local data = load_data()
	if data.completed[level_id] then
		return true
	end

	data.completed[level_id] = true

	if save_data(data) then
		print("Progress saved:", level_id)
		return true
	end

	return false
end


function M.category_progress(category)
	local data = load_data()
	local completed = 0

	for _, level in ipairs(category.levels) do
		if data.completed[level.id] then
			completed = completed + 1
		end
	end

	return completed, #category.levels
end


function M.category_completed(category)
	local completed, total = M.category_progress(category)
	return total > 0 and completed == total
end


function M.category_unlocked(category_id)
	for index, category in ipairs(catalog.categories) do
		if category.id == category_id then
			if index == 1 then
				return true
			end
			local previous = catalog.categories[index - 1]
			return M.category_completed(previous)
		end
	end
	return false
end


function M.reset()
	return save_data(default_data())
end


return M
