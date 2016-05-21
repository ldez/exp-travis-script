# Travis publish

[![Build Status](https://travis-ci.org/ldez/exp-travis-script.svg?branch=master)](https://travis-ci.org/ldez/exp-travis-script)

## SSH way (recommended)

### Generating SSH keys and encryption

See [travis-secure-key.sh](travis-secure-key.sh)

#### GitHub token (optional)

Get a Personal Access Token under https://github.com/settings/tokens.

Only enable `public_repo` access for public repositories, `repo` for private.
Save the token somewhere as you can only see it once.

### Use SSH keywords

See [publish.sh](publish.sh)
