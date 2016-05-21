# Travis publish

[![Build Status](https://travis-ci.org/ldez/exp-travis-script.svg?branch=master)](https://travis-ci.org/ldez/exp-travis-script)

## SSH way (recommended)

### Generating SSH keys and encryption

See [travis-secure-key.sh](travis-secure-key.sh)

[Adding a new SSH key to your GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)

Encrypt SSH key:
- https://docs.travis-ci.com/user/encrypting-files/
- https://github.com/travis-ci/travis.rb#encrypt-file

#### GitHub token (optional)

Get a [Personal Access Token](https://github.com/settings/tokens).

Only enable `public_repo` access for public repositories, `repo` for private.
Save the token somewhere as you can only see it once.

### Use SSH key

See [publish.sh](.travis/publish.sh)

- Custom Deployment: [Git](https://docs.travis-ci.com/user/deployment/custom/#Git)
- Security information: [Security-Restrictions-when-testing-Pull-Requests](https://docs.travis-ci.com/user/pull-requests#Security-Restrictions-when-testing-Pull-Requests)
