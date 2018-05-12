#!/bin/bash

[ $(whoami) == "root" ] && exec sudo -u ${1:-nobody} $0

exec > ~/bootstrap.log 2>&1

set -x

python3 -m bash_kernel.install
jupyter contrib nbextension install --user
jupyter nbextension install lc_multi_outputs --user --py
jupyter nbextension enable lc_multi_outputs --user --py
for ext in freeze toc2; do
  jupyter nbextension enable $ext/main --user
done

[ -f ~/.gitconfig ] || cat <<EOF > ~/.gitconfig
[filter "clean_ipynb"]
    clean = jq --indent 1 --monochrome-output '. + if .metadata.git.suppress_outputs | not then { cells: [.cells[] | . + if .cell_type == \"code\" then { outputs: [], execution_count: null } else {} end ] } else {} end'
    smudge = cat
EOF

[ -f ~/.gitattributes ] || cat <<EOF > ~/.gitattributes
*.ipynb  filter=clean_ipynb
EOF