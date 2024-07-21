# PROD target (docker build --target prod)
FROM python:3.10-slim AS prod

# Install curl for local testing
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install non-dev dependencies and the foo lib
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY foo /tmp/foo
RUN pip install /tmp/foo

COPY app app

CMD ["python", "app/main.py"]

# DEV target (docker build --target dev)
FROM prod AS dev

WORKDIR /app

# Install dev dependencies
COPY requirements-dev.txt .
RUN pip install -r requirements-dev.txt

COPY tests tests

CMD ["python", "-m", "pytest"]

