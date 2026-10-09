local M = {}

M.categories = {
	{
		id = "beginner",
		name = "Beginner",
		levels = {
			{ id = "beginner_001", size = 5 },
			{ id = "beginner_002", size = 5 },
			{ id = "beginner_003", size = 5 },
			{ id = "beginner_004", size = 10 },
		}
	},
	{
		id = "easy",
		name = "Easy",
		levels = {}
	},
	{
		id = "medium",
		name = "Medium",
		levels = {}
	},
	{
		id = "hard",
		name = "Hard",
		levels = {}
	},
	{
		id = "expert",
		name = "Expert",
		levels = {}
	},
	{
		id = "master",
		name = "Master",
		levels = {}
	}
}


function M.next_level(level_id)
	local found = false

	for _, category in ipairs(M.categories) do
		for _, level in ipairs(category.levels) do
			if found then
				return level, category
			end

			if level.id == level_id then
				found = true
			end
		end
	end

	return nil, nil
end


return M
