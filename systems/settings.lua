
local M = {}

local SAVE_PATH = sys.get_save_file("harbour_picross", "settings")

local data = nil

local function defaults()
	return {
		version = 1,
		animations = true
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

return M
