" unite source: middleman
" Version: 1.0
" Author : @zeroyonichihachi <tkfm.yamaguchi@gmail.com>
" License: zlib License
" Origin : vim-unite-chef by @thinca

let s:save_cpo = &cpo
set cpo&vim

let s:source = {
\   'hooks': {},
\ }

function! s:source.hooks.on_init(args, context)
  let root = unite#sources#middleman#mm_root()
  if root == ""
    redraw
    echohl ErrorMsg | echo 'can not find MM_ROOT' | echohl None | return []
  endif

  let a:context._base = root
endfunction

function! s:source.gather_candidates(args, context)
  let pat = a:context._base . "/" . self.source__type . '/**/*.*'
  let files = map(split(glob(pat), "\n"),
  \               'unite#util#substitute_path_separator(v:val)')
  return map(files, '{
  \   "word": v:val,
  \   "kind": "file",
  \   "action__path": v:val,
  \   "action__directory": v:val,
  \ }')
endfunction

function! unite#sources#middleman#define()
  return map(['source', 'data', 'locales', 'helpers', 'lib'],
  \      'extend(deepcopy(s:source),
  \       {
  \         "name": "middleman/" . v:val,
  \         "description": "candidates from middleman of " . v:val,
  \         "source__type": v:val,
  \       })')
endfunction

function! unite#sources#middleman#mm_root()
  let conf_file = findfile("config.rb" , fnamemodify(expand("%:p"), ":h") . ";")
  if conf_file == "" | return "" | endif
  return fnamemodify(expand(conf_file), ":h")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

