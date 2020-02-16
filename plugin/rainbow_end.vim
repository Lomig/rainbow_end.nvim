if exists('g:rainbow_end_loaded')
    finish
endif
let g:rainbow_end_loaded = 1


lua Rainbow = require("rainbow")

function! RainbowToggle()
    lua Rainbow:Toggle()
endfunction

function! RainbowOn()
    lua Rainbow:On()
endfunction

function! RainbowOff()
    lua Rainbow:Off()
endfunction
