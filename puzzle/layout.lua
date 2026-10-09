
local M = {}

function M.calculate(puzzle, area)
	local rows = puzzle.height
	local cols = puzzle.width

	-- Determine how much space clues require.
	local max_row_clues = 0
	local max_col_clues = 0

	for _, clues in ipairs(puzzle.row_clues) do
		max_row_clues = math.max(max_row_clues, #clues)
	end

	for _, clues in ipairs(puzzle.col_clues) do
		max_col_clues = math.max(max_col_clues, #clues)
	end

	-- Clue slots are proportional to cell size.
	local clue_ratio = 0.45
	local gap_ratio = 0.25

	local total_width_units = cols + max_row_clues * clue_ratio + gap_ratio
	local total_height_units = rows + max_col_clues * clue_ratio + gap_ratio

	local cell_size = math.min(area.width / total_width_units, area.height / total_height_units, area.max_cell_size or 92)

	-- Whole layout: grid + clues + gaps.
	local total_width = total_width_units * cell_size
	local total_height = total_height_units * cell_size

	local left = area.x + (area.width - total_width) / 2
	local bottom = area.y + (area.height - total_height) / 2

	local row_clue_width = max_row_clues * clue_ratio * cell_size
	local col_clue_height = max_col_clues * clue_ratio * cell_size

	local gap = gap_ratio * cell_size
	local grid_left = left + row_clue_width + gap
	local grid_bottom = bottom

	return {
		cell_size = cell_size,
		clue_step = cell_size * clue_ratio,
		clue_gap = gap,

		grid_left = grid_left,
		grid_bottom = grid_bottom,
		grid_width = cols * cell_size,
		grid_height = rows * cell_size,

		-- Used to position the clue groups.
		row_clue_right = grid_left - gap,
		col_clue_bottom = grid_bottom + rows * cell_size + gap,

		total_width = total_width,
		total_height = total_height
	}
end

function M.cell_position(geometry, row, col, height)
	local size = geometry.cell_size
	local x = geometry.grid_left + (col - 0.5) * size
	local y = geometry.grid_bottom + (height - row + 0.5) * size
	return x, y
end

return M
