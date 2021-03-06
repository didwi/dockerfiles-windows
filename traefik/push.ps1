$version=$(select-string -Path Dockerfile -Pattern "ENV TRAEFIK_VERSION").ToString().split()[-1]

docker tag traefik stefanscherer/traefik-windows:v$version-1607
docker push stefanscherer/traefik-windows:v$version-1607

npm install -g rebase-docker-image

rebase-docker-image stefanscherer/traefik-windows:v$version-1607 `
  -s microsoft/nanoserver:10.0.14393.2125 `
  -t stefanscherer/traefik-windows:v$version-1709 `
  -b stefanscherer/netapi-helper:1709

..\update-docker-cli.ps1

docker manifest create `
  stefanscherer/traefik-windows:v$version `
  stefanscherer/traefik-windows:v$version-1607 `
  stefanscherer/traefik-windows:v$version-1709
docker manifest push stefanscherer/traefik-windows:v$version

docker manifest create `
  stefanscherer/traefik-windows:latest `
  stefanscherer/traefik-windows:v$version-1607 `
  stefanscherer/traefik-windows:v$version-1709
docker manifest push stefanscherer/traefik-windows:latest
