# Demo purpose

This is a minimal demo on how to migrate a monorepo from using `pip` and one or more `requirements.txt` to using `rye` as a dependency management tool. While simplified examples never capture the full nuances of production-scale repos, the key points to highlight here are:
- The monorepo has an `app` that runs something like a web-server and is not an installable Python package
  - The `app` must run in a Docker container
- The monorepo has utility packages that should be installed and be importable by the interpreter running the `app`
  - Those libraries should be easy to develop against, i.e. not having to push versioned changes to an external repository before testing `app` locally
- A cloud development environment should be able to run a Docker container with this monorepo set up and installed, ready for local development or testing

Nice to haves:
- A lock file with hashes of the installed libraries for security audits
- Easy to split Docker targets for prod and dev

# Run

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