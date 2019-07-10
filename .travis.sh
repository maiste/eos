set -e

# Functions to separate actions in travis jobs
fold_start () { printf 'travis_fold:start:%s\r\033[33;1m%s\033[0m\n' "$1" "$2"; }
fold_end () { printf 'travis_fold:end:%s\r' "$1"; }

# Create container
fold_start build_docker 'Build docker image'
docker build -t maiste/eos:v1 .
fold_end build_docker

# Launch test
fold_start eos_test 'Running eos tests'
docker run --rm --name eos maiste/eos:v1 sh -c 'eval `opam config env` ; dune runtest'
fold_end eos_test
