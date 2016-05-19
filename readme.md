# Travis publish

## Github way

1. Get a Personal Access Token under https://github.com/settings/tokens

Only enable `public_repo` access for public repositories, `repo` for private.

Save the token somewhere as you can only see it once.

2. On the Travis settings for the repository `https://travis-ci.org/<me>/<myrepo>/settings` create an environment variable:

```shell
GITHUB_API_KEY=<token>
```

and make sure to mark "Display value in build log" as `off`.

This is safe because only authorized pushes by you see such environment variables,
so if a malicious user tries to make a pull request to get your string,
the variable won't be there.

Just make sure that you never, ever list your environment variables on your build!

3. Add the following to your `.travis.yml`:

```yml
after_success: |
  if [ -n "$GITHUB_API_KEY" ]; then
    cd "$TRAVIS_BUILD_DIR"
    # This generates a `web` directory containing the website.
    make web
    cd web
    git init
    git checkout -b gh-pages
    git add .
    git -c user.name='travis' -c user.email='travis' commit -m init
    # Make sure to make the output quiet, or else the API token will leak!
    # This works because the API key can replace your password.
    git push -f -q https://<me>:$GITHUB_API_KEY@github.com/<me>/<myrepo>-gh-pages gh-pages &2>/dev/null
    cd "$TRAVIS_BUILD_DIR"
  fi
```
