local M = {}

function M.get(category_index, level_index)
	local category = M.categories[category_index]
	if not category then return nil end

	return category.levels[level_index]
end

function M.next_puzzle(category_index, level_index)
	local category = M.categories[category_index]
	if not category then
		return nil, nil
	end

	-- Next puzzle in the current category.
	if level_index < #category.levels then
		return category_index, level_index + 1
	end

	-- First puzzle in the next category.
	local next_category_index = category_index + 1

	if next_category_index <= #M.categories then
		return next_category_index, 1
	end

	-- No more puzzles: the game is finished.
	return nil, nil
end

M.categories = {
	{
		name = "Tutorial",
		levels = {
			{
				title = "Heart",
				hint = "beats",
				gridSize = 5,
				grid = {
					0,1,0,1,0,
					1,1,1,1,1,
					1,1,1,1,1,
					0,1,1,1,0,
					0,0,1,0,0
				}
			},
			{
				title = "Boat",
				hint = "Travel faraway",
				gridSize = 5,
				grid = {
					0,0,1,0,0,
					0,0,1,1,0,
					0,1,1,1,0,
					1,1,1,1,1,
					0,1,1,1,0
				}
			},
			{
				title = "Anchor",
				hint = "keeps in place",
				gridSize = 5,
				grid = {
					0,0,1,0,0,
					0,0,1,0,0,
					0,0,1,0,0,
					1,0,1,0,1,
					0,1,1,1,0
				}
			},
			{
				title = "Test 10x10",
				hint = "read the title",
				gridSize = 10,
				grid = {
					0,0,1,1,1,1,1,1,0,0,
					0,1,1,0,0,0,0,1,1,0,
					1,1,0,0,0,0,0,0,1,1,
					1,0,0,0,0,0,0,0,0,1,
					1,0,0,1,1,0,0,0,0,1,
					1,0,0,1,1,0,0,0,0,1,
					1,0,0,0,0,0,0,0,0,1,
					1,1,0,0,0,0,0,0,1,1,
					0,1,1,0,0,0,0,1,1,0,
					0,0,1,1,1,1,1,1,0,0
				}
			},
			{
				title = "Gargamel",
				hint = "25x25 test",
				gridSize = 25,
				grid = {
					0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,
					0,0,0,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,0,1,1,0,0,0,0,
					1,1,1,1,1,0,0,1,0,0,0,0,1,1,1,1,1,0,1,1,1,0,0,0,0,
					1,0,1,1,1,1,1,0,1,0,0,0,1,0,0,1,1,0,1,1,0,0,0,0,0,
					0,1,1,1,1,1,1,1,1,0,0,0,1,0,0,0,1,1,0,1,1,0,0,0,0,
					1,0,1,1,1,1,1,1,1,1,0,0,1,1,0,0,0,1,0,0,1,0,0,0,0,
					1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,0,1,0,1,0,1,1,1,1,0,
					1,0,0,1,0,0,0,1,1,1,1,1,0,0,1,1,0,0,0,0,0,0,0,1,1,
					1,0,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,1,1,1,0,0,0,0,1,
					0,1,1,0,0,1,1,0,0,1,1,0,0,0,0,1,0,1,0,0,0,0,0,0,1,
					1,1,1,0,0,1,1,1,1,0,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,
					1,1,1,1,0,0,0,1,1,0,0,0,0,0,1,1,1,0,1,0,1,0,0,0,0,
					1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1,1,1,0,1,0,0,0,0,
					1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,0,1,0,0,1,0,0,0,0,
					1,1,0,1,1,1,0,1,0,0,0,0,0,0,1,1,1,1,0,0,1,0,0,0,0,
					1,1,0,0,1,1,0,1,0,0,0,0,0,0,1,1,1,0,0,0,1,0,0,0,0,
					1,0,1,1,1,1,1,1,0,0,0,0,0,1,0,0,0,1,0,1,1,0,0,0,0,
					1,1,1,1,1,1,1,1,1,0,0,0,0,1,0,0,1,0,0,1,0,0,0,0,0,
					1,1,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,0,1,1,0,0,0,0,0,
					1,1,0,1,1,1,1,1,1,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,
					1,1,0,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,
					1,1,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,
					0,0,1,1,1,1,1,1,0,1,1,0,0,0,0,0,1,0,1,0,1,0,1,1,1,
					1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,
					1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,0,1,0,1,0,1,0,1
				}
			},
		}
	},
	{
		name = "Easy",
		levels = {
			-- Original Easy puzzles
		}
	},
	-- Medium, Hard, Expert, Insane
}
return M