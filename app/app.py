# app/app.py - A simple Flask web application
# It reads the pod hostname to demonstrate which Kubernetes pod serves the request.

import os
from flask import Flask

app = Flask(__name__)

# Route 1: Home page
# Shows a greeting and the pod name (HOSTNAME environment variable set by Kubernetes).
@app.route("/")
def home():
    # Kubernetes automatically sets the HOSTNAME environment variable to the pod's name.
    pod_name = os.environ.get("HOSTNAME", "unknown-pod")
    return f"Hello from Kubernetes! Served by pod: {pod_name}\n"

# Route 2: Health check endpoint
# Used by Kubernetes liveness and readiness probes to verify the container is alive and ready.
@app.route("/health")
def health():
    return "ok\n", 200

# Listen on all interfaces (0.0.0.0) so traffic from outside the container can reach port 5000.
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
