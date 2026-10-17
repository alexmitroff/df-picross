local M = {}

local MIN_ZOOM = 1
local MAX_ZOOM = 4
local ZOOM_FACTOR = 1.2

function M.new()
	return {
		zoom = 1,
		pan_x = 0,
		pan_y = 0
	}
end

local function clamp_axis(offset, zoom, start, length, viewport_size)
	local scaled_start = start * zoom
	local scaled_length = length * zoom

	-- Center content when smaller than the viewport.
	if scaled_length <= viewport_size then
		return (viewport_size - scaled_length) / 2 - scaled_start
	end

	-- Otherwise do not allow empty space beyond the edges.
	local min_offset = viewport_size - (start + length) * zoom

	local max_offset = -start * zoom

	return math.max(min_offset, math.min(max_offset, offset))
end

function M.clamp(state, geometry, width, height)
	state.pan_x = clamp_axis(state.pan_x, state.zoom, geometry.grid_left, geometry.grid_width, width)
	state.pan_y = clamp_axis(state.pan_y, state.zoom, geometry.grid_bottom, geometry.grid_height, height)
end

function M.zoom_at(state, factor, cursor_x, cursor_y, geometry, width, height)
	local old_zoom = state.zoom
	local new_zoom = math.max(MIN_ZOOM,	math.min(MAX_ZOOM, old_zoom * factor))

	if new_zoom == old_zoom then return end

	local ratio = new_zoom / old_zoom

	-- Keep the content point under the cursor stationary.
	state.pan_x = cursor_x - (cursor_x - state.pan_x) * ratio
	state.pan_y = cursor_y - (cursor_y - state.pan_y) * ratio
	state.zoom = new_zoom
	M.clamp(state, geometry, width, height)
end

function M.zoom_step(state, direction, x, y, geometry, width, height)
	local factor = direction > 0 and ZOOM_FACTOR or 1 / ZOOM_FACTOR
	M.zoom_at(state, factor, x, y, geometry, width, height)
end

function M.pan(state, dx, dy, geometry, width, height)
	state.pan_x = state.pan_x + dx
	state.pan_y = state.pan_y + dy
	M.clamp(state, geometry, width, height)
end

function M.reset(state, geometry, width, height)
	state.zoom = 1
	state.pan_x = 0
	state.pan_y = 0
	M.clamp(state, geometry, width, height)
end

return M
