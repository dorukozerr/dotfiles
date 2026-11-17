" ahmet_ikiz — black / white / red monochrome
" https://www.reddit.com/r/aphextwin/comments/1xv87ux/ahmet_ikiz/
" Matches the base16-black-metal-venom CLI setup.

vim9script 

export g:airline#themes#ahmet_ikiz#palette = {}

" accent (modified buffers, warnings)
airline#themes#ahmet_ikiz#palette.accents = {
      \ 'red': ['#a8433c', '', 1, ''],
      \ }

" normal: black on off-white
N1 = ['#000000', '#c1c1c1', 0, 7]
N2 = ['#c1c1c1', '#1a1a1a', 7, 0]
N3 = ['#999999', '#000000', 8, 0]
airline#themes#ahmet_ikiz#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

" insert: black on red
I1 = ['#000000', '#a8433c', 0, 1]
I2 = ['#c1c1c1', '#1a1a1a', 7, 0]
I3 = ['#999999', '#000000', 8, 0]
airline#themes#ahmet_ikiz#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)

" visual: black on grey
V1 = ['#000000', '#888888', 0, 8]
V2 = ['#c1c1c1', '#1a1a1a', 7, 0]
V3 = ['#999999', '#000000', 8, 0]
airline#themes#ahmet_ikiz#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

" replace: off-white on dark red
R1 = ['#f8f7f2', '#79241f', 7, 1]
R2 = ['#c1c1c1', '#1a1a1a', 7, 0]
R3 = ['#999999', '#000000', 8, 0]
airline#themes#ahmet_ikiz#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)

" command line
C1 = ['#000000', '#c1c1c1', 0, 7]
airline#themes#ahmet_ikiz#palette.commandline = airline#themes#generate_color_map(s:C1, s:N2, s:N3)

" inactive windows: dim
IA = ['#333333', '#000000', 8, 0]
airline#themes#ahmet_ikiz#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
airline#themes#ahmet_ikiz#palette.inactive_modified = {
      \ 'airline_c': ['#a8433c', '', 1, ''],
      \ }

" tabline
airline#themes#ahmet_ikiz#palette.tabline = {
      \ 'airline_tab':     ['#999999', '#000000', 8, 0, ''],
      \ 'airline_tabsel':  ['#000000', '#c1c1c1', 0, 7, ''],
      \ 'airline_tabtype': ['#000000', '#222222', 0, 8, ''],
      \ 'airline_tabfill': ['#333333', '#000000', 8, 0, ''],
      \ 'airline_tabmod':  ['#a8433c', '#000000', 1, 0, 'bold'],
      \ }
