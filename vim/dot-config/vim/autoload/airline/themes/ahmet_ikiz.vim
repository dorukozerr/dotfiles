" ahmet_ikiz — black / white / red monochrome
" https://www.reddit.com/r/aphextwin/comments/1xv87ux/ahmet_ikiz/
" Matches the base16-black-metal-venom CLI setup.

let g:airline#themes#ahmet_ikiz#palette = {}

" accent (modified buffers, warnings)
let g:airline#themes#ahmet_ikiz#palette.accents = {
      \ 'red': ['#a8433c', '', 1, ''],
      \ }

" normal: black on off-white
let s:N1 = ['#000000', '#c1c1c1', 0, 7]
let s:N2 = ['#c1c1c1', '#1a1a1a', 7, 0]
let s:N3 = ['#999999', '#000000', 8, 0]
let g:airline#themes#ahmet_ikiz#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

" insert: black on red
let s:I1 = ['#000000', '#a8433c', 0, 1]
let s:I2 = ['#c1c1c1', '#1a1a1a', 7, 0]
let s:I3 = ['#999999', '#000000', 8, 0]
let g:airline#themes#ahmet_ikiz#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)

" visual: black on grey
let s:V1 = ['#000000', '#888888', 0, 8]
let s:V2 = ['#c1c1c1', '#1a1a1a', 7, 0]
let s:V3 = ['#999999', '#000000', 8, 0]
let g:airline#themes#ahmet_ikiz#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

" replace: off-white on dark red
let s:R1 = ['#f8f7f2', '#79241f', 7, 1]
let s:R2 = ['#c1c1c1', '#1a1a1a', 7, 0]
let s:R3 = ['#999999', '#000000', 8, 0]
let g:airline#themes#ahmet_ikiz#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)

" command line
let s:C1 = ['#000000', '#c1c1c1', 0, 7]
let g:airline#themes#ahmet_ikiz#palette.commandline = airline#themes#generate_color_map(s:C1, s:N2, s:N3)

" inactive windows: dim
let s:IA = ['#333333', '#000000', 8, 0]
let g:airline#themes#ahmet_ikiz#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let g:airline#themes#ahmet_ikiz#palette.inactive_modified = {
      \ 'airline_c': ['#a8433c', '', 1, ''],
      \ }

" tabline
let g:airline#themes#ahmet_ikiz#palette.tabline = {
      \ 'airline_tab':     ['#999999', '#000000', 8, 0, ''],
      \ 'airline_tabsel':  ['#000000', '#c1c1c1', 0, 7, ''],
      \ 'airline_tabtype': ['#000000', '#222222', 0, 8, ''],
      \ 'airline_tabfill': ['#333333', '#000000', 8, 0, ''],
      \ 'airline_tabmod':  ['#a8433c', '#000000', 1, 0, 'bold'],
      \ }
