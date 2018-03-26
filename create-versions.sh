#!/bin/bash

render() {
sedStr="
  s!%%GONG_REPORTE_VERSION%%!$version!g;
"

sed -r "$sedStr" $1
}

versions=(1.1.5)
for version in ${versions[*]}; do
  mkdir $version
  render Dockerfile.template > $version/Dockerfile
  cp docker-entrypoint.sh org-netbeans-core-1.0.jar docker-compose.yml $version/
done
