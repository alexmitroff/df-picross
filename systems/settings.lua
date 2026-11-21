
local M = {}

local SAVE_PATH = sys.get_save_file("harbour_picross", "settings")

local NEXT_CLUE_SIZE = {
	[100] = 125,
	[125] = 150,
	[150] = 100
}

local data = nil

local function defaults()
	return {
		version = 1,
		animations = true,
		clue_size = 150,
	}
end

local function load()
	if data then
		return data
	end

	local ok, saved = pcall(sys.load, SAVE_PATH)

	if not ok or type(saved) ~= "table" then
		saved = {}
	end

	data = defaults()

	if type(saved.animations) == "boolean" then
		data.animations = saved.animations
	end

	if NEXT_CLUE_SIZE[saved.clue_size] then
		data.clue_size = saved.clue_size
	end

	return data
end


local function save()
	local ok, result = pcall(sys.save, SAVE_PATH, data)

	if not ok or result == false then
		print("Failed to save settings:", tostring(result))
		return false
	end

	return true
end


function M.init()
	load()
	print("Settings are loaded")
end


function M.get_animations_enabled()
	return load().animations
end


function M.set_animations_enabled(enabled)
	assert(type(enabled) == "boolean")

	local settings = load()
	local previous = settings.animations
	settings.animations = enabled
	if not save() then
		settings.animations = previous
		return false
	end

	return true
end


function M.get_clue_size()
	return load().clue_size
end


function M.cycle_clue_size()
	local current = load()
	local previous = current.clue_size
	current.clue_size = NEXT_CLUE_SIZE[previous]

	if not save() then
		current.clue_size = previous
		return false
	end

	return true
end

return M
