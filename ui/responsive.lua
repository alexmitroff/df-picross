
local M = {}

function M.calculate(width, height)
	assert(width > 0 and height > 0)

	local portrait = height >= width
	local margin = math.max(16,	math.min(width, height) * 0.04)
	local header_height = math.min(100, height * 0.13)
	local content_bottom = margin
	local content_top = height - header_height
	local result = {
		orientation = portrait and "portrait" or "landscape",
		width = width,
		height = height,
		margin = margin,
		header = {
			x = margin,
			y = height - header_height,
			width = width - margin * 2,
			height = header_height,
		}
	}

	if portrait then
		local footer_height = math.min(240,	height * 0.23)
		result.board = {
			x = margin,
			y = footer_height + margin,
			width = width - margin * 2,
			height = math.max(1, content_top - footer_height - margin * 2)
		}

		result.footer = {
			x = margin,
			y = margin,
			width = width - margin * 2,
			height = footer_height
		}
	else
		local available_width = width - margin * 3
		local board_width = available_width * 0.7
		result.board = {
			x = margin,
			y = content_bottom,
			width = board_width,
			height = math.max(1, content_top - content_bottom - margin)
		}
		result.footer = {
			x = margin * 2 + board_width,
			y = content_bottom,
			width = available_width - board_width,
			height = math.max(1, content_top - content_bottom - margin)
		}
	end
	return result
end

return M
