" Vim plugin for setting breakpoints in GDB for vim.
" author: Robert Guthrie

let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_breakpoint")
    finish
endif
let g:loaded_breakpoint = 1


" ===------------------------------------------------===
" SCRIPT VARS
" ===------------------------------------------------===
let s:BreakpointLocations = [ ]


" ===------------------------------------------------===
" CONFIG GLOBALS
" ===------------------------------------------------===
" The file to output your breakpoints to.
" Default: breakpoint.gdb
if !exists("g:breakpoint_script_file")
    let g:breakpoint_script_file = getcwd() . "/breakpoint.gdb"
endif

if !exists("g:breakpoint_delete_file_on_exit")
    let g:breakpoint_delete_file_on_exit = 1
endif


" ===------------------------------------------------===
" CORE FUNCTIONS
" ===------------------------------------------------===
function! s:SetBreakpoint()
    let filename = expand("%:p")
    let linenumber = line(".")
    echo "Adding breakpoint"
    call add(s:BreakpointLocations, "b " . filename . ":" . linenumber)
endfunction

function! s:WriteBreakpointsToFile()
    if !empty(s:BreakpointLocations)
        call writefile(s:BreakpointLocations, g:breakpoint_script_file)
    endif
endfunction

function! s:ClearBreakpoints()
    let s:BreakpointLocations = [ ]
    call delete(g:breakpoint_script_file)
endfunction

function! s:PrintBreakpoints()
    for breakpoint in s:BreakpointLocations
        echo breakpoint
    endfor
endfunction

function! s:DeleteOnExit()
    if g:breakpoint_delete_file_on_exit
        call delete(g:breakpoint_script_file)
    endif
endfunction


" ===------------------------------------------------===
" COMMANDS AND MAPPINGS
" ===------------------------------------------------===
if g:breakpoint_delete_file_on_exit
    augroup BreakpointAutocommands
        autocmd VimLeave * call s:DeleteOnExit()
    augroup END
endif
augroup BreakpointAutocommands
    autocmd BufWritePost * call s:WriteBreakpointsToFile()
augroup END

command -nargs=0 BreakpointSetBreakpoint call s:SetBreakpoint()
command -nargs=0 BreakpointClearBreakpoints call s:ClearBreakpoints()
command -nargs=0 BreakpointPrintBreakpoints call s:PrintBreakpoints()
command -nargs=0 BreakpointWriteBreakpoints call s:WriteBreakpointsToFile()

nnoremap <leader>BB :BreakpointSetBreakpoint<CR>
nnoremap <leader>BC :BreakpointClearBreakpoints<CR>


let &cpo = s:save_cpo
