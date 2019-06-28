FROM fedora:latest

RUN dnf upgrade -y
RUN dnf install -y ocaml opam ocaml-dune git
RUN opam init --disable-sandboxing -y && eval $(opam env)
RUN opam update -y && opam upgrade -y
RUN eval `opam config env`
RUN opam install -y dune cmdliner alcotest yojson
RUN eval `opam config env`

COPY . /root
