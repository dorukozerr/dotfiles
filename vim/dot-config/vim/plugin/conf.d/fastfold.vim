vim9script

nmap zuz <Plug>(FastFoldUpdate)
xnoremap <silent> iz :<c-u>FastFoldUpdate<cr>]z<up>$v[z<down>^
xnoremap <silent> az :<c-u>FastFoldUpdate<cr>]zV[z

g:fastfold_savehook = 1
g:fastfold_fdmhook = 0
g:fastfold_fold_command_suffixes =  ['x', 'X', 'a', 'A', 'o', 'O', 'c', 'C']
g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']
# g:fastfold_savehook = 1
# g:fastfold_fold_command_suffixes = ['x', 'X', 'a', 'A', 'o', 'O', 'c', 'C', 'r', 'R', 'm', 'M', 'i', 'n', 'N']
