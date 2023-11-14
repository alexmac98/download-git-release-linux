#!/bin/bash

# Release tag
TAG=$1

if [[ $TAG == '' ]]; then
    echo "No tag was provided... Aborting."
    echo "Usage: ./download-release.sh <tag>"
    exit
fi

GITHUB_USER_ORGANIZATION="..."	# YOUR USER NAME OR ORGANIZATION NAME
GITHUB_REPOSITORY="..."		# THE REPOSITORY
GITHUB_API_TOKEN="..." 		# YOUR API TOKEN
GITHUB_API_VERSION="2022-11-28" # THE GITHUB API VERSION
ASSET_NAME="..."                # THE NAME OF THE ASSET TO DOWNLOAD

echo "Downloading releases information to releases.json..."
curl -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_API_TOKEN" -H "X-GitHub-Api-Version: $GITHUB_API_VERSION"  -L https://api.github.com/repos/$GITHUB_USER_ORGANIZATION/$GITHUB_REPOSITORY/releases > releases.json

echo "Fetching specific release for $TAG..."
RELEASE=$(cat releases.json | jq --arg tag "$TAG" '.[] | select(.tag_name == $tag)') 

if [[ $RELEASE == '' ]]; then
    echo "No release with tag '$TAG' was found... Aborting."
    exit
fi

# Get packages ZIP asset ID
echo "Getting asset of $TAG..."
ASSETS=$(echo $RELEASE | jq '.assets')
ASSET=$(echo $ASSETS | jq --arg asset "$ASSET_NAME" '.[] | select(.name | contains($asset))' )
ASSET_ID=$(echo $ASSET | jq '.id')
echo "Asset ID is $ASSET_ID..."
LOCATION="https://api.github.com/repos/$GITHUB_USER_ORGANIZATION/$GITHUB_REPOSITORY/releases/assets/$ASSET_ID"

echo "Downloading $LOCATION to $ASSET_NAME-$TAG..."
curl -H "Accept: application/octet-stream" -H "Authorization: Bearer $GITHUB_API_TOKEN" -H "X-GitHub-Api-Version: $GITHUB_API_VERSION"  -L -o $ASSET_NAME-$TAG $LOCATION

echo "Removing releases.json file..."
rm releases.json
