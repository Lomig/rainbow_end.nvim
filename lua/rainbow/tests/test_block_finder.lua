if _G.vim == nil then _G.vim = {} end

local luaunit = require('luaunit')
local BlockFinder = require("rainbow.block_finder")

TestBlockFinder = {}
-------------------------------------------------------------

-------------- IsEligible
function TestBlockFinder.test_ItDetectsIfKeywordIsCommented()
	local line = "The # is before the word"
	local match = line:find("word")
	local result = BlockFinder:IsEligible(line, match)
	luaunit.assertFalse(result)
end

function TestBlockFinder.test_ItDetectsIfKeywordIsNotCommented()
	local line = "The word is before the #"
	local match = line:find("word")
	local result = BlockFinder:IsEligible(line, match)
	luaunit.assertTrue(result)
end

function TestBlockFinder.test_ItDetectsIfThereIsNoComment()
	local line = "There is no comment on the line of word"
	local match = line:find("word")
	local result = BlockFinder:IsEligible(line, match)
	luaunit.assertTrue(result)
end

function TestBlockFinder.test_ItDetectsIfThereIsNoMatch()
	local line = "There is no comment on the line of word"
	local match = line:find("Nope, not here.")
	local result = BlockFinder:IsEligible(line, match)
	luaunit.assertFalse(result)
end


-------------- FindSpecialKeyword
function TestBlockFinder.test_ItFindsSpecialKeywordsAtStart()
	local line = "  unless this"
	local result1, result2 = BlockFinder:FindSpecialKeyword(line)
	luaunit.assertEquals(result1, 3)
	luaunit.assertEquals(result2, 8)
end

function TestBlockFinder.test_ItSkipsKeywordIfNotAtStart()
	local line = "d  unless this"
	local result = BlockFinder:FindSpecialKeyword(line)
	luaunit.assertEquals(result, nil)
end

function TestBlockFinder.test_ItReturnsNilIfNoSpecialKeyword()
	local line = "d this"
	local result = BlockFinder:FindSpecialKeyword(line)
	luaunit.assertEquals(result, nil)
end


-------------- FindNormalKeyword
function TestBlockFinder.test_ItFindsNormalKeywords()
	local line = "case this"
	local result1, result2 = BlockFinder:FindNormalKeyword(line)
	luaunit.assertEquals(result1, 1)
	luaunit.assertEquals(result2, 4)
end

function TestBlockFinder.test_ItReturnsNilIfNoNormalKeyword()
	local line = "d this"
	local result = BlockFinder:FindNormalKeyword(line)
	luaunit.assertEquals(result, nil)
end


-------------- FindEndKeyword
function TestBlockFinder.test_ItFindsEndKeyword()
	local line = "the end is near"
	local result1, result2 = BlockFinder:FindEndKeyword(line)
	luaunit.assertEquals(result1, 5)
	luaunit.assertEquals(result2, 7)
end

function TestBlockFinder.test_ItReturnsNilIfNoEndKeyword()
	local line = "This is just the beginning"
	local result = BlockFinder:FindEndKeyword(line)
	luaunit.assertEquals(result, nil)
end


-------------- MatchKeywords
function TestBlockFinder.test_ItCreatesTablesOfTags()
	local lines = {
		"# Truc def",
		"def x",
		"	machin",
		"	if rtr",
		"		bidule",
		"	else",
		"		truc",
		"	end",
		"end",
		"",
		"class bidule",
		"	vrai",
		"end",
	}

	local result1, result2 = BlockFinder:MatchKeywords(lines)
	local solution1 = {
		{line = 2, starting = 1, ending = 3},
		{line = 4, starting = 2, ending = 3},
		{line = 11, starting = 1, ending = 5},
	}
	local solution2 = {
		{line = 8, starting = 2, ending = 4},
		{line = 9, starting = 1, ending = 3},
		{line = 13, starting = 1, ending = 3},
	}
	luaunit.assertEquals(result1, solution1)
	luaunit.assertEquals(result2, solution2)
end


-------------- MatchEndingWithStarting
function TestBlockFinder.test_ItFindAMatchingStartingTag()
	local endingTag = {line = 8, starting = 2, ending = 4}
	local startingTags = {
		{line = 2, starting = 1, ending = 3},
		{line = 4, starting = 2, ending = 3},
		{line = 11, starting = 1, ending = 5},
	}
	local result = BlockFinder:MatchEndingWithStarting(endingTag, startingTags)
	luaunit.assertEquals(result, {line = 4, starting = 2, ending = 3})
end


-------------- FindBlocks
function TestBlockFinder.test_ItFindMatchingTagsAndReturnBlocks()
	local startingTags = {
		{line = 2, starting = 1, ending = 3},
		{line = 4, starting = 2, ending = 3},
		{line = 11, starting = 1, ending = 5},
	}
	local endingTags = {
		{line = 8, starting = 2, ending = 4},
		{line = 9, starting = 1, ending = 3},
		{line = 13, starting = 1, ending = 3},
	}
	local result = BlockFinder:FindBlocks(startingTags, endingTags)
	local solution = {
		{
			{line = 4, starting = 2, ending = 3},
			{line = 8, starting = 2, ending = 4},
		},

		{
			{line = 2, starting = 1, ending = 3},
			{line = 9, starting = 1, ending = 3},
		},

		{
			{line = 11, starting = 1, ending = 5},
			{line = 13, starting = 1, ending = 3},
		},
	}
	luaunit.assertEquals(result, solution)
end


-------------------------------------------------------------
print("\n\27[35m---\nTesting BlockFinder...\n\27[0m")
os.exit( luaunit.LuaUnit:run() )
