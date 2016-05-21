#!/bin/sh
set -e

## Here, you will need to replace <org@email>, <somewhere> and <token>
USER_EMAIL="<org@email>"
PROJECT_DIRECTORY="<somewhere>"
SSH_KEY_NAME="travis_rsa"
GITHUB_TOKEN="<token>"

## First you create a RSA public/private key pair just for Travis.
ssh-keygen -t rsa -C "${USER_EMAIL}" -f ~/.ssh/${SSH_KEY_NAME}

## Copy to clipboard.
##
## Then following the official doc (https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/),
xclip -sel clip < ~/.ssh/${SSH_KEY_NAME}.pub

echo 'Paste your key into the "Key" field ; Click "Add key" ; Confirm the action by entering your GitHub password'

commandExists() {
  command -v "$1" 1>/dev/null 2>&1 && return 0 || return 1
}

## Ruby dev dependencies via RVM, needed by Travis CLI
# rvm install 2.3.0-dev

## Install Travis CLI if necessary.
commandExists travis || sudo gem install travis

## Logged in to Travis CI
# travis login --github-token ${GITHUB_TOKEN}

## Let's go to where your ".travis.yml" is
cd ${PROJECT_DIRECTORY}
mkdir -p .travis

## Encrypt SSH key
## https://docs.travis-ci.com/user/encrypting-files/
## https://github.com/travis-ci/travis.rb#encrypt-file
travis encrypt-file ~/.ssh/${SSH_KEY_NAME} .travis/${SSH_KEY_NAME}.enc --add
