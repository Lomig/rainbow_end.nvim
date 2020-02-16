local _G = getfenv(0)
local api = _G.vim.api

local Rainbow = {}
local Local = {}

local BlockFinder = require('rainbow.block_finder')
local BlockHighlighter = require('rainbow.block_highlighter')

Local.Running = false
Local.Colors = {
	Red = 196,
	Orange = 208,
	Yellow = 226,
	Green = 10,
	Blue = 81,
}

function Rainbow:Toggle()
	if Local.Running then
		self:Off()
	else
		self:On()
	end
end

function Rainbow.Off()
	api.nvim_command('call clearmatches()')
	Local.Running = false
	print 'Off!'
end

function Rainbow.On()
	Local.Running = true
	print 'On!'
end

return Rainbow
