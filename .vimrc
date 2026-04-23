let mapleader = "\\"

"quicknav
nmap <C-h> 5h
nmap <C-j> 5j
nmap <C-k> 5k
nmap <C-l> 5l
nmap <C-a> 0
nmap <C-e> $
imap <C-a> <esc>0i
imap <C-e> <esc>$i
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>

"quickest 2 buffer switch
nmap <Leader>j :b#<Enter>

"go to next location
nmap <Leader>n :lne<Enter>

"go to previous location
nmap <Leader>m :lpr<Enter>

"un/indenting
nmap <Tab> V>
nmap <S-Tab> V<
vmap <Tab> >
vmap <S-Tab> <


"Quick single char insert
nmap <Space> i_<Esc>r
nmap <S-Space> a_<Esc>r
"^doesnt work on many machines.
"http://stackoverflow.com/questions/279959/how-can-i-make-shiftspacebar-page-up-in-vim
"for solutions


cabbrev E Explore


