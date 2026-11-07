-- Puzzle solving session
local board = require "puzzle.board"
local puzzles = require "levels.puzzles"

local M = {}

function M.new(category_index, level_index)
	local level = assert(puzzles.get(category_index, level_index), "Unknown puzzle")
	local next_category, next_level = puzzles.next_puzzle(category_index, level_index)

	return {
		category_index = category_index,
		level_index = level_index,
		level = level,
		board = board.create(level),
		completed = false,

		next_category_index = next_category,
		next_level_index = next_level,

		ui = {
			status = "playing",
			show_next = false
		}
	}
end


function M.cycle_cell(s, row, col)
	if s.completed then
		return {
			changed = false,
			completed_now = false
		}
	end

	local current_state = s.board.cells[row][col]
	local next_state = board.next_state(current_state)

	return M.paint(s, row, col, next_state)
end


function M.paint(session, row, col, state)
	if session.completed then
		return {
			changed = false,
			completed_now = false
		}
	end

	local changed = board.set_cell(session.board, row, col, state)
	if not changed then
		return {
			changed = false,
			completed_now = false
		}
	end

	local completed_now = board.is_solved(session.board)

	if completed_now then
		session.completed = true
	end

	return {
		changed = true,
		completed_now = completed_now,
		row = row,
		col = col
	}
end

function M.finish(session, saved, can_advance)
	assert(session.completed, "Cannot finish an unsolved puzzle")
	assert(type(saved) == "boolean")
	assert(type(can_advance) == "boolean")

	local is_final_level = session.next_category_index == nil and session.next_level_index == nil
	if not saved then
		session.ui.status = "save_failed"
	elseif is_final_level then
		session.ui.status = "game_completed"
	else
		session.ui.status = "completed"
	end
	
	session.ui.show_next = saved and can_advance and not is_final_level

	return session.ui
end

return M
