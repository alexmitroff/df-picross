-- Puzzle solving session
local board = require "puzzle.board"
local catalog = require "levels.catalog"
local puzzles = require "levels.puzzles"

local M = {}

function M.new(level_id)
	local level = assert(puzzles.get(level_id),	"Unknown puzzle: " .. tostring(level_id))
	local next_level = catalog.next_level(level_id)
	local session = {
		level_id = level_id,
		level = level,
		board = board.create(level),
		completed = false,
		next_level_id = next_level and next_level.id or nil,
		ui = {
			status = "playing",
			show_next = false
		}
	}
	return session
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
		session.ui.status = "completed"
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

	session.ui.status = saved and "completed" or "save_failed"
	session.ui.show_next = saved and can_advance and session.next_level_id ~= nil

	return session.ui
end

return M
