function rgf {
    rg --files $2 | rg $1
}

function transfer() {
    curl --progress-bar --upload-file "$1" https://free.keep.sh/$(basename "$1") -H "Expires-After 1" | tee /dev/null;
    echo
}

function lint-go() {
 golangci-lint run --out-format tab "$1"
}
function fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}
