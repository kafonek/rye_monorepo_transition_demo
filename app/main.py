from foo import hello
import flask

app = flask.Flask(__name__)


@app.route("/foo")
def foo():
    return hello()


if __name__ == "__main__":
    app.run(host="0.0.0.0")
