# Use

## Web app

- Start server: `docker build --target prod -t monodemo . && docker run --rm -it -p 5000:5000 monodemo`
- Query endpoint: `curl http://localhost:5000/foo`

## Tests
- Run tests: `docker build --target dev -t monodemo . && docker run --rm -it monodemo`


# Migration steps

- Install `rye` locally, `curl -sSf https://rye.astral.sh/get | RYE_INSTALL_OPTION="--yes" bash`
  - Can include `RYE_TOOLCHAIN=$(which python)` arg to stop `rye` from installing its own interpreter
  - May need to source `~/.profile`, eventually `which rye` should point to `~/.rye/shims/rye`
  - `rye self update` (`rye self update --version 1.2.3`) to manage `rye` as a system tool

- `rye init --virtual` creates `pyproject.toml` and `.python-version` (can delete the latter)
  - Can also delete everything in `pyproject.toml` `[project]` setting except for `name` and `dependencies`

- Add noraml dependencies
  - `rye add flask`
  - `rye add pytest --dev`
  - This will create and install libraries to a `.venv`, as well as create `requirements.lock` and `requirements-dev.lock` files

- Add monorepo lib dependencies (`foo`)
  - Normally `rye add foo --path foo` would work but there's a bug with `virtual` projects (https://github.com/astral-sh/rye/issues/912)
  - Instead, add to `pyproject.toml` manually `foo @ file:///${PROJECT_ROOT}/foo`, which is what the CLI syntax would have done for us
  - If `flask` was pinned to `>=3` from the earlier sync, unpin it in `pyproject.toml` and rerun `rye sync`

- Update `Dockerfile` to install `rye` and run `rye sync` to install dependencies
  - Run web-app and tests from the virtualenv Python rather than system Python