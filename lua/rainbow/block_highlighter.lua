local _G = getfenv(0)
local api = _G.vim.api

local BlockHighlighter = {}
local Local = {}

Local.colors = {
	{"OneRed",    196, "#e06c75"},
	{"OneYellow", 226, "#e4c07b"},
	{"OneGreen",   10, "#98c379"},
	{"OneBlue",     1, "#61afef"},
	{"OnePurple",  92, "#c678dd"},
}

function BlockHighlighter:ColorKeywords(blocks)
	Local.currentColor = 1

	for _, block in ipairs(blocks) do
		local colorCode, colorHex, colorName = self:GetCurrentColor()
		self:SendCommandToVim(self:CreateVimColorGroup(colorCode, colorHex, colorName))
		self:SendCommandToVim(self:HighlightWord(colorName, block[1]))
		self:SendCommandToVim(self:HighlightWord(colorName, block[2]))
	end
end

function BlockHighlighter:GetCurrentColor()
	if not Local.currentColor then Local.currentColor = 1 end

	local colorName = Local.colors[Local.currentColor][1]
	local colorCode = Local.colors[Local.currentColor][2]
	local colorHex =  Local.colors[Local.currentColor][3]

	Local.currentColor = (Local.currentColor % #(Local.colors)) + 1

	return colorCode, colorHex, colorName
end

function BlockHighlighter:CreateVimColorGroup(colorCode, colorHex, colorName)
	return "highlight " .. colorName .. " ctermfg=" .. colorCode .. " guifg=" .. colorHex
end

function BlockHighlighter:HighlightWord(colorName, wordLocation)
	local line = wordLocation.line
	local startingTag = wordLocation.starting
	local endingTag = wordLocation.ending + 1

	local matchLocation = "\\%" .. line .. "l\\&\\%"
	matchLocation = matchLocation .. startingTag .. "v.*\\%" .. endingTag .."v"

	local matchAddCommand = "call matchadd('" .. colorName

	return matchAddCommand .. "', '" .. matchLocation .. "')"
end

function BlockHighlighter:SendCommandToVim(command)
	api.nvim_command(command)
end

return BlockHighlighter
