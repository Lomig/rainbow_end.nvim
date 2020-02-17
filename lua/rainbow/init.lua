local _G = getfenv(0)
local api = _G.vim.api

local Rainbow = {}
local Local = {}

local BlockFinder = require('rainbow.block_finder')
local BlockHighlighter = require('rainbow.block_highlighter')

Local.Running = false

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
end

function Rainbow.On()
	Local.Running = true
	local blocks = BlockFinder:GetBlocks()
	BlockHighlighter:ColorKeywords(BlockFinder:GetBlocks())
end

return Rainbow
