#!/bin/bash
set -e

## Experimental
echo "TRAVIS_BRANCH: $TRAVIS_BRANCH"
echo "TRAVIS_BUILD_DIR: $TRAVIS_BUILD_DIR"
echo "TRAVIS_BUILD_ID: $TRAVIS_BUILD_ID"
echo "TRAVIS_BUILD_NUMBER: $TRAVIS_BUILD_NUMBER"
echo "TRAVIS_COMMIT: $TRAVIS_COMMIT"
echo "TRAVIS_COMMIT_RANGE: $TRAVIS_COMMIT_RANGE"
echo "TRAVIS_JOB_ID: $TRAVIS_JOB_ID"
echo "TRAVIS_JOB_NUMBER: $TRAVIS_JOB_NUMBER"
echo "TRAVIS_PULL_REQUEST: $TRAVIS_PULL_REQUEST"
echo "TRAVIS_SECURE_ENV_VARS: $TRAVIS_SECURE_ENV_VARS"
echo "TRAVIS_REPO_SLUG: $TRAVIS_REPO_SLUG"
echo "TRAVIS_OS_NAME: $TRAVIS_OS_NAME"
echo "TRAVIS_TAG: $TRAVIS_TAG"
# cd "$TRAVIS_BUILD_DIR"
# git log --oneline --graph --decorate
# git status

## Custom variables
USER_EMAIL="lfernandez.dev@gmail.com"
USER_NAME="Ludovic Fernandez"
SSH_KEY_NAME="travis_rsa"

# encrypted_43d3334a9d7d_key=
# encrypted_43d3334a9d7d_iv=

if [ "$TRAVIS_OS_NAME" = "linux" ] && [ "$TRAVIS_BRANCH" = "master" ] && [ ! -z "$TRAVIS_TAG" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
  echo 'Publishing...'
else
  echo 'Skipping publishing'
  exit 0
fi

if [ -z "$VERSION" ]; then
    VERSION=$(git rev-parse HEAD)
fi

git config --global user.email ${USER_EMAIL}
git config --global user.name "${USER_NAME}"

echo "Loading key..."
openssl aes-256-cbc -K "$encrypted_43d3334a9d7d_key" -iv "$encrypted_43d3334a9d7d_iv" -in .travis/${SSH_KEY_NAME}.enc -out ~/.ssh/${SSH_KEY_NAME} -d
eval "$(ssh-agent -s)"
chmod 600 ~/.ssh/${SSH_KEY_NAME}
ssh-add ~/.ssh/${SSH_KEY_NAME}

echo "First step achieved"
