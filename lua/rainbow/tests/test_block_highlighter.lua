if _G.vim == nil then _G.vim = {} end

local luaunit = require('luaunit')
local BlockHighlighter = require("rainbow.block_highlighter")

TestBlockHighlighter = {}
-------------------------------------------------------------

-------------- GetCurrentColor
function TestBlockHighlighter.test_ItCircleThroughColors()
	local color = BlockHighlighter:GetCurrentColor()
	luaunit.assertEquals(color, 196)

	local color = BlockHighlighter:GetCurrentColor()
	luaunit.assertEquals(color, 226)

	local color = BlockHighlighter:GetCurrentColor()
	luaunit.assertEquals(color, 10)

	local color = BlockHighlighter:GetCurrentColor()
	luaunit.assertEquals(color, 1)

	local color = BlockHighlighter:GetCurrentColor()
	luaunit.assertEquals(color, 92)

	local color = BlockHighlighter:GetCurrentColor()
	luaunit.assertEquals(color, 196)
end


-------------- CreateVimColorGroup
function TestBlockHighlighter.test_ItGeneratesAValidColorGroup()
	local colorCode = 196
	local colorName = "RED"
	local colorHex = "#e06c75"
	local result = BlockHighlighter:CreateVimColorGroup(colorCode, colorHex, colorName)
	luaunit.assertEquals(result, "highlight RED ctermfg=196 guifg=#e06c75")
end


-------------- HighlightWord
function TestBlockHighlighter.test_ItGeneratesAValidHighlightCommand()
	local colorName = "RED"
	local wordLocation = {line = 11, starting = 1, ending = 5}
	local result = BlockHighlighter:HighlightWord(colorName, wordLocation)
	luaunit.assertEquals(result, "call matchadd('RED', '\\%11l\\&\\%1v.*\\%6v')")
end


-------------------------------------------------------------
print("\n\27[35m---\nTesting BlockHighlighter...\n\27[0m")
os.exit( luaunit.LuaUnit:run() )
