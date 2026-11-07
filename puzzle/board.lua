
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



local function clues_match(actual, expected)
	if #actual ~= #expected then
		return false
	end

	for i = 1, #expected do
		if actual[i] ~= expected[i] then
			return false
		end
	end

	return true
end


local function read_solution(level)
	-- Original Harbour Picross format
	if level.grid then
		local size = assert(level.gridSize, "Missing gridSize")
		assert(#level.grid == size * size, "Invalid flat grid length")
		return size, size, function(row, col)
			local index = (row - 1) * size + col
			return level.grid[index]
		end
	end

	-- Temporary compatibility with existing test puzzles
	local solution = assert(level.solution, "Missing solution")

	local height = #solution
	assert(height > 0, "Empty solution")

	local width = #solution[1]

	return width, height, function(row, col)
		return tonumber(solution[row]:sub(col, col))
	end
end


function M.create(level)
	assert(level and level.grid, "Invalid level")
	local size = assert(level.gridSize, "Missing gridSize")

	assert(type(size) == "number" and size > 0 and size % 1 == 0, "Invalid gridSize")
	assert(#level.grid == size * size, "Invalid flat grid length")

	local board = {
		width = size,
		height = size,
		solution = {},
		cells = {},
		row_clues = {},
		col_clues = {}
	}

	-- Initialize solution and player cells.
	for row = 1, size do
		board.solution[row] = {}
		board.cells[row] = {}

		for col = 1, size do
			local index = (row - 1) * size + col
			local value = level.grid[index]
			assert(value == 0 or value == 1, "Invalid solution cell at index " .. tostring(index))
			board.solution[row][col] = value
			board.cells[row][col] = M.UNKNOWN
		end

		-- Generate clues for this row.
		board.row_clues[row] =
		calculate_clues(board.solution[row])
	end

	-- Generate column clues.
	for col = 1, size do
		local values = {}
		for row = 1, size do
			values[row] = board.solution[row][col]
		end
		board.col_clues[col] = calculate_clues(values)
	end

	return board
end



function M.next_state(state)
	if state == M.CROSSED then
		return M.UNKNOWN
	else
		return state + 1
	end
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


function M.row_clues_satisfied(puzzle, row)
	local values = {}

	for col = 1, puzzle.width do
		values[col] = puzzle.cells[row][col] == M.FILLED
		and 1 or 0
	end

	local actual = calculate_clues(values)

	-- Do not mark a completely untouched row as complete.
	if actual[1] == 0 then
		return false
	end

	return clues_match(actual, puzzle.row_clues[row])
end


function M.col_clues_satisfied(puzzle, col)
	local values = {}

	for row = 1, puzzle.height do
		values[row] = puzzle.cells[row][col] == M.FILLED
		and 1 or 0
	end

	local actual = calculate_clues(values)

	if actual[1] == 0 then
		return false
	end

	return clues_match(actual, puzzle.col_clues[col])
end

return M

