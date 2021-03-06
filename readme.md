# Travis continuous delivery

[![Build Status](https://travis-ci.org/ldez/travis-continuous-delivery-atom-publish.svg?branch=master)](https://travis-ci.org/ldez/travis-continuous-delivery-atom-publish)

This project explains how to manipulate a Git repository within [Travis CI](https://travis-ci.org) to publish a tag.

Mainly for simulate the release of an Atom package.


## SSH way (recommended)

### Generating SSH keys and encryption

See [travis-secure-key.sh](travis-secure-key.sh)

[Adding a new SSH key to your GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)

In this case you can assume to don't define a passphrase for the SSH key.

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


## Skip Build

### Travis CI

Travis automatically skips the build if the commit contains `[ci skip]`.

- https://docs.travis-ci.com/user/customizing-the-build/#Skipping-a-build

Example:

```shell
git commit -m 'My commit message [ci skip]'
```

### AppVeyor

AppVeyor automatically skips the build if the commit contains `[ci skip]` or `[skip ci]` or `[skip appveyor]`.

AppVeyor can use a commits filter defined in `appveyor.yml` : `skip_commits:`

- https://www.appveyor.com/docs/how-to/skip-build

Examples:

```shell
git commit -m 'My commit message [ci skip]'
```

```yml
skip_commits:

  # Regex for matching commit message
  message: /Created.*\.(png|jpg|jpeg|bmp|gif)/

  # Commit author's username, name, email or regexp maching one of these.
  author: John
```
