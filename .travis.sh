# Create container
docker build -t maiste/eos:v1 .

# Launch test
docker run --rm --name eos maiste/eos:v1 sh -c 'eval `opam config env` ; cd /root ; dune runtest'
