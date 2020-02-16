if exists('g:rainbow_end_loaded')
    finish
endif
let g:rainbow_end_loaded = 1


lua rainbow = require("rainbow")

function! ToggleRainbow()
    lua rainbow.toggle()
endfunction

function! RainbowOff()
    lua rainbow.on()
endfunction

function! RainbowOff()
    lua rainbow.off()
endfunction
