from flask import Flask, request
import os
import logging


log_level = os.getenv("LOGLEVEL", default="CRITICAL").upper()

app = Flask(__name__)

logging.basicConfig(level=getattr(logging, log_level, logging.INFO))

werkzeug_logger = logging.getLogger("werkzeug")
werkzeug_logger.setLevel(getattr(logging, log_level, logging.INFO))


# Receive CloudEvent
@app.route("/", methods=["POST"])
def receive_cloudevent():
    # app.logger.warning(request.data)
    print("Received event: {}".format(request.data), flush=True)
    return True


if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0", port=8080)
