-- Wrapper for reduced motion settings
local settings = require "systems.settings"

local M = {}

function M.enabled()
	return settings.get_animations_enabled()
end

function M.animate(node, property, target, easing, duration)
	print("ANIMATIONS: ", tostring(M.enabled()))
	gui.cancel_animations(node, property)

	if M.enabled() and duration > 0 then
		gui.animate(node, property, target, easing, duration)
	else
		gui.set(node, property, target)
	end
end

return M
