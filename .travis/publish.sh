#!/bin/bash
set -e

## for testing purpose only
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
SSH_KEY_NAME="travis_rsa"
AUTHORIZED_BRANCH='master'
PUBLISH_TYPE=${PUBLISH_TYPE:="patch"}

cd "$TRAVIS_BUILD_DIR"

## Prevent publish on tags
CURRENT_TAG=$(git tag --contains HEAD)

if  [ -z "${STOP_PUBLISH}" ] && [ "$TRAVIS_OS_NAME" = "linux" ] && [ "$TRAVIS_BRANCH" = "$AUTHORIZED_BRANCH" ] && [ -z "$CURRENT_TAG" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]
then
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

## Change origin url to use SSH
git remote set-url origin ${GIT_REPOSITORY}

## Force checkout master branch (because Travis uses a detached head)
git checkout ${AUTHORIZED_BRANCH}

## Simulate a publish action (only for testing purpose)
echo "$TRAVIS_BUILD_ID" > "${TRAVIS_COMMIT}.txt"
git add .
# NOTE: Travis automatically skips the build if the commit contains [skip ci] 
git commit -q -m "Prepare 0.0.${TRAVIS_BUILD_NUMBER} release [ci skip]"
git tag -a -m "travis-script-tag ${PUBLISH_TYPE}" "v0.0.${TRAVIS_BUILD_NUMBER}"
git push --follow-tags origin master

git log --oneline --graph --decorate
