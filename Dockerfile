FROM alpine:latest

RUN apk add opam build-base m4 git coreutils
RUN opam init --disable-sandboxing -y
RUN opam update -y && opam upgrade -y
RUN opam switch create 4.08.0
RUN eval $(opam env)
RUN opam switch 4.08.0
RUN eval $(opam env) && ocaml --version

COPY . /root
WORKDIR /root

RUN opam install -y . --deps-only
RUN eval $(opam env)

