
local M = {}

M.data = {
	beginner_001 = {
		name = "Heart",
		solution = {
			"01010",
			"11111",
			"11111",
			"01110",
			"00100"
		}
	},

	beginner_002 = {
		name = "Boat",
		solution = {
			"00100",
			"00110",
			"01110",
			"11111",
			"01110"
		}
	},

	beginner_003 = {
		name = "Anchor",
		solution = {
			"00100",
			"00100",
			"00100",
			"10101",
			"01110"
		}
	},

	beginner_004 = {
		name = "Test 10x10",
		solution = {
			"0011111100",
			"0110000110",
			"1100000011",
			"1000000001",
			"1001100001",
			"1001100001",
			"1000000001",
			"1100000011",
			"0110000110",
			"0011111100"
		}
	}
}

function M.get(id)
	return M.data[id]
end

return M
