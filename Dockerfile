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
# RUN /root/.rye/shims/rye sync --no-dev

# `rye` is a problem, rolling back to pip!! 
COPY requirements.lock .

# Create venv so we can keep using same CMD's
RUN python -m venv .venv

# Set PROJECT_ROOT so that pip can expand ${PROJECT_ROOT} in lock file
ENV PROJECT_ROOT=app 
RUN .venv/bin/pip install -r requirements.lock

COPY app app

CMD [".venv/bin/python", "app/main.py"]

# DEV target (docker build --target dev)
FROM prod AS dev

WORKDIR /app

# Install dev dependencies, see above for note on PATH 
# RUN /root/.rye/shims/rye sync

# `rye` is a problem, rolling back to pip!!
COPY requirements-dev.lock .
RUN .venv/bin/pip install -r requirements-dev.lock

COPY tests tests

# Would need to put this venv on a PATH for the dev environment, 
# rye automagically handled getting it sourced through ~/.profile
CMD [".venv/bin/python", "-m", "pytest"]

