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

## Custom variables
USER_EMAIL="lfernandez.dev@gmail.com"
USER_NAME="Ludovic Fernandez"
GIT_REPOSITORY='git@github.com:ldez/exp-travis-script.git'
GIHUB_REPO_SLUG='ldez/exp-travis-script'
SSH_KEY_NAME="travis_rsa"

# encrypted_43d3334a9d7d_key=
# encrypted_43d3334a9d7d_iv=

cd "$TRAVIS_BUILD_DIR"

## Prevent publish on tags
CURRENT_TAG=$(git tag --contains HEAD)

if [ "$TRAVIS_OS_NAME" = "linux" ] && [ "$TRAVIS_REPO_SLUG" = "$GIHUB_REPO_SLUG" ] && [ "$TRAVIS_BRANCH" = "master" ] && [ -z "$CURRENT_TAG" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
  echo 'Publishing...'
else
  echo 'Skipping publishing'
  exit 0
fi

## Git configuration
git config --global user.email ${USER_EMAIL}
git config --global user.name "${USER_NAME}"

## Loading SSH key
echo "Loading key..."
openssl aes-256-cbc -K "$encrypted_43d3334a9d7d_key" -iv "$encrypted_43d3334a9d7d_iv" -in .travis/${SSH_KEY_NAME}.enc -out ~/.ssh/${SSH_KEY_NAME} -d
eval "$(ssh-agent -s)"
chmod 600 ~/.ssh/${SSH_KEY_NAME}
ssh-add ~/.ssh/${SSH_KEY_NAME}

echo "First step achieved"

## Experimental
# git remote -v
# git status -sb
# git log --oneline --graph --decorate

## Change origin url to use SSH
git remote set-url origin ${GIT_REPOSITORY}
# git remote -v

## Force checkout master branch
git checkout master

echo "$TRAVIS_BUILD_ID" > "${TRAVIS_COMMIT}.txt"
git add .
# git status -sb
git commit -q -m "Publish test $TRAVIS_COMMIT"
git tag -a -m 'travis-script-tag' "v0.0.${TRAVIS_BUILD_NUMBER}"
git push --follow-tags origin master

# git remote -v
# git status -sb
git log --oneline --graph --decorate

echo "Second step achieved"
