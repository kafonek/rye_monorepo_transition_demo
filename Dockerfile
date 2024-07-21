# PROD target (docker build --target prod)
FROM python:3.10-slim AS prod

# Install curl for local testing
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install rye
RUN curl -sSf https://rye.astral.sh/get | RYE_TOOLCHAIN="/usr/local/bin/python" RYE_INSTALL_OPTION="--yes" bash

# pyproject.toml has all dependencies (prod, dev, and relative paths)
COPY pyproject.toml .

# Copy foo, needed for the `rye sync` since relative path is specified in pyproject.toml
COPY foo foo

# `rye` isn't on PATH until we source `~/.profile` (which sources `~/.rye/env`)
RUN /root/.rye/shims/rye sync --no-dev

COPY app app

CMD [".venv/bin/python", "app/main.py"]

# DEV target (docker build --target dev)
FROM prod AS dev

WORKDIR /app

# Install dev dependencies, see above for note on PATH 
RUN /root/.rye/shims/rye sync

COPY tests tests

CMD [".venv/bin/python", "-m", "pytest"]

