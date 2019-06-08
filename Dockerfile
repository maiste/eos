FROM ubuntu:latest

RUN apt-get update -y && apt-get install -y ocaml opam m4 
RUN opam init -y && opam update
RUN opam install -y dune cmdliner Ounit
RUN eval `opam config env`

COPY . /root
