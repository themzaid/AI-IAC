"""Hello API - A simple greeting service."""

from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/hello/<name>", methods=["GET"])
def hello(name: str):
    """Return a JSON greeting for the given name."""
    return jsonify({"message": f"Hello {name} from Linkedin Learning"})


@app.route("/health", methods=["GET"])
def health():
    """Return a healthy-status JSON response for load balancer probes."""
    return jsonify({"status": "healthy"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8989)
