rgf {
    rg --files $2 | rg $1
}

transfer() {
    curl --progress-bar --upload-file "$1" https://free.keep.sh/$(basename "$1") -H "Expires-After 1" | tee /dev/null;
    echo
}

function lint-go() {
 golangci-lint run --out-format tab "$1"
}

