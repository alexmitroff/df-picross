
local M = {}

M.UNKNOWN = 0
M.FILLED = 1
M.CROSSED = 2

local function calculate_clues(line)
	local clues = {}
	local count = 0

	for i = 1, #line do
		if line[i] == 1 then
			count = count + 1
		elseif count > 0 then
			table.insert(clues, count)
			count = 0
		end
	end

	if count > 0 then
		table.insert(clues, count)
	end

	if #clues == 0 then
		return { 0 }
	end

	return clues
end

function M.create(level)
	assert(level and level.solution, "Invalid level")

	local board = {
		width = #level.solution[1],
		height = #level.solution[1] > 0	and #level.solution or 0,
		solution = {},
		cells = {},
		row_clues = {},
		col_clues = {}
	}

	-- Initialize solution and player cells.
	for row = 1, board.height do
		assert(#level.solution[row] == board.width,	"Inconsistent row width")
		board.solution[row] = {}
		board.cells[row] = {}

		for col = 1, board.width do
			local value = tonumber(level.solution[row]:sub(col, col))
			assert(value == 0 or value == 1, "Invalid solution cell")

			board.solution[row][col] = value
			board.cells[row][col] = M.UNKNOWN
		end

		board.row_clues[row] = calculate_clues(board.solution[row])
	end

	-- Calculate column clues.
	for col = 1, board.width do
		local values = {}

		for row = 1, board.height do
			values[row] = board.solution[row][col]
		end
		board.col_clues[col] = calculate_clues(values)
	end

	return board
end

function M.set_cell(board, row, col, state)
	assert(row >= 1 and row <= board.height)
	assert(col >= 1 and col <= board.width)
	assert(state >= M.UNKNOWN and state <= M.CROSSED)

	if board.cells[row][col] == state then
		return false
	end

	board.cells[row][col] = state

	return true
end

function M.is_solved(board)
	for row = 1, board.height do
		for col = 1, board.width do
			local expected = board.solution[row][col] == 1
			local actual = board.cells[row][col] == M.FILLED
			if expected ~= actual then
				return false
			end
		end
	end

	return true
end

return M

