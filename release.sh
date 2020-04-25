#!/bin/sh

# adopted from https://medium.com/travis-on-docker/how-to-version-your-docker-images-1d5c577ebf54

set -ex

docker run --rm -v "$PWD":/app treeder/bump patch
version="v$(cat VERSION)"
echo "Current Version: $version"

git add VERSION
git commit -m "[ci skip] tagging new version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags
