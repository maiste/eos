FROM fedora:latest

RUN dnf upgrade -y
RUN dnf install -y ocaml opam ocaml-dune git
RUN opam init --disable-sandboxing -y && eval $(opam env)
RUN opam update -y && opam upgrade -y && eval $(opam env) 

COPY . /root
WORKDIR /root

RUN opam switch create 4.08.0
RUN eval `opam config env`
RUN opam switch 4.08.0 && eval $(opam env)
RUN ocaml --version
RUN opam install -y . --deps-only
RUN eval $(opam env)

