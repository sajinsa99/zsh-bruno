echo
./clean-docker-none.sh

echo
docker build -f Dockerfile -t zsh-bruno .
