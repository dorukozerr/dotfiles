vim9script
# ahmet_ikiz — black / white / red monochrome
# https://www.reddit.com/r/aphextwin/comments/1xv87ux/ahmet_ikiz/
# Matches the base16-black-metal-venom CLI setup.

g:airline#themes#ahmet_ikiz#palette = {}

# accent (modified buffers, warnings)
g:airline#themes#ahmet_ikiz#palette.accents = {
      red: ['#a8433c', '', 1, ''],
      }

# normal: black on off-white
var N1 = ['#000000', '#c1c1c1', 0, 7]
var N2 = ['#c1c1c1', '#1a1a1a', 7, 0]
var N3 = ['#999999', '#000000', 8, 0]
g:airline#themes#ahmet_ikiz#palette.normal = airline#themes#generate_color_map(N1, N2, N3)

# insert: black on red
var I1 = ['#000000', '#a8433c', 0, 1]
var I2 = ['#c1c1c1', '#1a1a1a', 7, 0]
var I3 = ['#999999', '#000000', 8, 0]
g:airline#themes#ahmet_ikiz#palette.insert = airline#themes#generate_color_map(I1, I2, I3)

# visual: black on grey
var V1 = ['#000000', '#888888', 0, 8]
var V2 = ['#c1c1c1', '#1a1a1a', 7, 0]
var V3 = ['#999999', '#000000', 8, 0]
g:airline#themes#ahmet_ikiz#palette.visual = airline#themes#generate_color_map(V1, V2, V3)

# replace: off-white on dark red
var R1 = ['#f8f7f2', '#79241f', 7, 1]
var R2 = ['#c1c1c1', '#1a1a1a', 7, 0]
var R3 = ['#999999', '#000000', 8, 0]
g:airline#themes#ahmet_ikiz#palette.replace = airline#themes#generate_color_map(R1, R2, R3)

# command line
var C1 = ['#000000', '#c1c1c1', 0, 7]
g:airline#themes#ahmet_ikiz#palette.commandline = airline#themes#generate_color_map(C1, N2, N3)

# inactive windows: dim
var IA = ['#333333', '#000000', 8, 0]
g:airline#themes#ahmet_ikiz#palette.inactive = airline#themes#generate_color_map(IA, IA, IA)
g:airline#themes#ahmet_ikiz#palette.inactive_modified = {
      airline_c: ['#a8433c', '', 1, ''],
      }

# tabline
g:airline#themes#ahmet_ikiz#palette.tabline = {
      airline_tab:     ['#999999', '#000000', 8, 0, ''],
      airline_tabsel:  ['#000000', '#c1c1c1', 0, 7, ''],
      airline_tabtype: ['#000000', '#222222', 0, 8, ''],
      airline_tabfill: ['#333333', '#000000', 8, 0, ''],
      airline_tabmod:  ['#a8433c', '#000000', 1, 0, 'bold'],
      }
