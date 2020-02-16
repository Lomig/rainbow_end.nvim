local _G = getfenv(0)
local api = _G.vim.api

local BlockFinder = {}
local Local = {}

-- Special Treatment as we don't want to try and match an "end" for an onliner conditional
-- For an example: 'return foo if bar'
Local.SpecialKeywords = {'if', 'unless', 'while', 'until'}
Local.NormalKeywords = {'module', 'class', 'def', 'case', 'begin', 'do'}


function BlockFinder:FindSpecialKeyword(line)
	for _, keyword in ipairs(Local.SpecialKeywords) do
		local match = string.find(line, "^%s*%f[%a]" .. keyword .."%f[%A]")
		if match then
			local matchStart, matchEnd = line:find(keyword)
			if matchStart then return matchStart, matchEnd end
		end
	end

	return nil
end

function BlockFinder:FindNormalKeyword(line)
	for _, keyword in ipairs(Local.NormalKeywords) do
		local matchStart, matchEnd = line:find("%f[%a]" .. keyword .. "%f[%A]")
		if matchStart then return matchStart, matchEnd end
	end

	return nil
end

function BlockFinder:FindEndKeyword(line)
	local matchStart, matchEnd = line:find("%f[%a]end%f[%A]")
	if matchStart then return matchStart, matchEnd end

	return nil
end

-- A match is not eligible if it is in a comment
-- Or if it does not exist
function BlockFinder:IsEligible(line, match)
	local hash, _ = line:find("#")
	if not match then return false end
	if not hash then return true end
	if hash > match then return true end

	return false
end

function BlockFinder:MatchKeywords(lines)
	local startLines = {}
	local endLines = {}
	

	for i, line in ipairs(lines) do
		local match1, match2 = self:FindSpecialKeyword(line)
		if self:IsEligible(line, match1) then
			table.insert(startLines, {line = i, starting = match1, ending = match2})
		end

		match1, match2 = self:FindNormalKeyword(line)
		if self:IsEligible(line, match1) then
			table.insert(startLines,{line = i, starting = match1, ending = match2})
		end

		match1, match2 = self:FindEndKeyword(line)
		if self:IsEligible(line, match1) then
			table.insert(endLines, {line = i, starting = match1, ending = match2})
		end

	end
	return startLines, endLines
end

function BlockFinder:FindBlocks(startingTags, endingTags)
	local blocks = {}

	for _, endingTag in ipairs(endingTags) do
		local startingMatch = self:MatchEndingWithStarting(endingTag, startingTags)
		table.insert(blocks, {startingMatch, endingTag})
	end

	return blocks
end

function BlockFinder:MatchEndingWithStarting(endingTag, startingTags)
	for i = #startingTags, 1, -1 do
		local startingTag = startingTags[i]
		if startingTag and startingTag.line < endingTag.line then
			return table.remove(startingTags, i)
		end
	end
	return {}
end

function BlockFinder:GetBlocks()
	local currentBuffer = api.nvim_get_current_buf()
	local numberOfLine = api.nvim_buf_line_count(currentBuffer)
	local lines = api.nvim_buf_get_lines(currentBuffer, 0, numberOfLine, true)

	return self:FindBlocks(self:MatchKeywords(lines))
end

return BlockFinder
