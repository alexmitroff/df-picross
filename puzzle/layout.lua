
local M = {}

function M.calculate(puzzle, area)
	local rows = puzzle.height
	local cols = puzzle.width

	local clue_ratio = 0.45
	local clue_gap_ratio = 0.25
	local cell_gap_ratio = 0.05
	local group_gap_ratio = 0.12
	local clue_padding_ratio = 0.30

	local function group_count(count)
		return math.floor((count - 1) / 5)
	end

	local max_row_clues = 0
	local max_col_clues = 0

	for _, clues in ipairs(puzzle.row_clues) do	max_row_clues = math.max(max_row_clues, #clues)	end
	for _, clues in ipairs(puzzle.col_clues) do	max_col_clues = math.max(max_col_clues, #clues)	end

	local row_panel_units =	max_row_clues * clue_ratio + 2 * clue_padding_ratio
	local col_panel_units =	max_col_clues * clue_ratio + 2 * clue_padding_ratio
	local width_units =	cols + group_count(cols) * group_gap_ratio + row_panel_units + clue_gap_ratio
	local height_units = rows + group_count(rows) * group_gap_ratio + col_panel_units + clue_gap_ratio

	local size = math.min(area.width / width_units,	area.height / height_units,	area.max_cell_size or 92)

	local total_width = width_units * size
	local total_height = height_units * size

	local left = area.x + (area.width - total_width) / 2
	local bottom = area.y + (area.height - total_height) / 2

	local clue_padding = size * clue_padding_ratio
	local clue_step = size * clue_ratio
	local clue_gap = size * clue_gap_ratio
	local group_gap = size * group_gap_ratio

	local row_panel_width =	max_row_clues * clue_step + clue_step + 2 * clue_padding
	local col_panel_height = max_col_clues * clue_step + clue_step + 2 * clue_padding

	local grid_left = left + row_panel_width + clue_gap
	local grid_bottom = bottom
	local grid_width = cols * size + group_count(cols) * group_gap
	local grid_height =	rows * size + group_count(rows) * group_gap

	return {
		cell_size = size,
		visual_cell_size = size * (1 - cell_gap_ratio),
		group_gap = group_gap,

		clue_step = clue_step,
		clue_gap = clue_gap,

		grid_left = grid_left,
		grid_bottom = grid_bottom,
		grid_width = grid_width,
		grid_height = grid_height,

		row_clue_right = grid_left - clue_gap - clue_padding - clue_step / 2,
		col_clue_bottom = grid_bottom + grid_height	+ clue_gap + clue_padding,

		row_panel_width = row_panel_width,
		col_panel_height = col_panel_height,

		total_width = total_width,
		total_height = total_height
	}
end


function M.calculate_grid(puzzle, area)
	local rows = puzzle.height
	local cols = puzzle.width

	local group_gap_ratio = 0.12
	local cell_gap_ratio = 0.05

	local col_groups = math.floor((cols - 1) / 5)
	local row_groups = math.floor((rows - 1) / 5)

	local width_units =	cols + col_groups * group_gap_ratio
	local height_units = rows + row_groups * group_gap_ratio

	local size = math.min(area.width / width_units,	area.height / height_units,	area.max_cell_size or 92)
	local group_gap = size * group_gap_ratio

	local grid_width = cols * size + col_groups * group_gap
	local grid_height =	rows * size + row_groups * group_gap

	return {
		cell_size = size,
		visual_cell_size = size * (1 - cell_gap_ratio),
		group_gap = group_gap,

		clue_step = size * 0.45,

		grid_left = (area.width - grid_width) / 2,
		grid_bottom = (area.height - grid_height) / 2,

		grid_width = grid_width,
		grid_height = grid_height
	}
end



function M.cell_position(geometry, row, col, height)
	local size = geometry.cell_size
	local extra = geometry.group_gap

	local x = geometry.grid_left + (col - 0.5) * size + math.floor((col - 1) / 5) * extra
	local rows_below = height - row

	local total_groups = math.floor((height - 1) / 5)
	local groups_above = math.floor((row - 1) / 5)
	local groups_below = total_groups - groups_above

	local y = geometry.grid_bottom + (rows_below + 0.5) * size + groups_below * extra

	return x, y
end

return M
