# Use

## Web app

- Start server: `docker build --target prod -t monodemo . && docker run --rm -it -p 5000:5000 monodemo`
- Query endpoint: `curl http://localhost:5000/foo`

## Tests
- Run tests: `docker build --target dev -t monodemo . && docker run --rm -it monodemo`