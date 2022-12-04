#!/bin/bash
set -x


GOTOOLS=~/gotools
mkdir -p "$GOTOOLS"

GOPKGS=(
	github.com/spf13/cobra/cobra@latest \
  github.com/golangci/golangci-lint/cmd/golangci-lint@latest \
	github.com/rakyll/hey@latest 

)

GOPATH="$GOTOOLS" go install "${GOPKGS[@]}"
