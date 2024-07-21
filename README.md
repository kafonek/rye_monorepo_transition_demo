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