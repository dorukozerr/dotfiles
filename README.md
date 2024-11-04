# My little vim setup

-   To use my vim config fallow theese instructions. First run `git clone https://github.com/dorukozerr/my-vim-config.git ~/.vim && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && rm -rf ~/.vim/.git`.
-   Then enter vim and type `:PlugInstall`.
-   Then in terminal run `cd ~/.vim/plugged/coc.nvim && npm ci && cd ~` after this, you can run `:CocInstall coc-tsserver coc-eslint coc-vimlsp coc-json coc-css @yaegassy/coc-tailwindcss3` in vim to install my default coc extensions.
-   I'm using custom base2tone-sea-dark theme on macos terminal app. Colors are setted to t_Co=16 in my settings. You can import `sea-dark-custom.terminal` file to use my theme if you want. Or you can simply search for base2tone terminal themes, and find the sea-dark theme. Only modification I made to theme is changed background color to pitch black `#000000`.
-   I also created a custom airline theme to match my terminal theme. It's already configured in my airline settings file, to use it just run this command `mv ~/.vim/seadark.vim ~/.vim/plugged/vim-airline-themes/autoload/airline/themes`. I think it looks nice. Or you can just change the airline theme in `~/.vim/config/airline.vim` to `let g:airline_theme='minimalist'.

And thats my vim setup.
