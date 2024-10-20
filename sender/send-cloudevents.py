import sys
import time
import os
from datetime import datetime

import argparse

from cloudevents.http import CloudEvent
from cloudevents.conversion import to_structured
import requests
import logging


# Logging
module = sys.modules["__main__"].__file__
logger = logging.getLogger(module)

# E.g. http://broker-ingress.knative-eventing.svc.cluster.local/$NAMESPACE/default
broker_base = "http://broker-ingress.knative-eventing.svc.cluster.local"
broker_name = "default"


#
# Sending Cloud Event to broker
#


def send_cloud_event(broker, msg):
    logger.info(f"Send cloud event to {broker}")
    ce_action_type = "dev.knative.samples.receiver"
    ce_action_source = "dev.knative.samples/receiversource"

    # Create a CloudEvent
    # - The CloudEvent "id" is generated if omitted. "specversion" defaults to "1.0".
    try:
        attributes = {
            "type": ce_action_type,
            "source": ce_action_source,
        }

        # Define the event data (payload)
        data = {"message": msg}

        event = CloudEvent(attributes, data)

        # Creates the HTTP request representation of the CloudEvent in structured content mode
        headers, body = to_structured(event)

        logger.info(f"Send CloudEvent {msg} to {broker}")
        # POST
        requests.post(broker, data=body, headers=headers)

    except:
        logger.error(f"Failed to send CloudEvent to: {broker}")

    return


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Cloud Event simulator Client")

    parser.add_argument(
        "--broker",
        type=str,
        default="http://localhost:8080/",
        help="brocker address  [default: http://localhost:8080]",
    )

    parser.add_argument(
        "-l",
        "--log-level",
        default="WARNING",
        help="Set log level to ERROR, WARNING, INFO or DEBUG",
    )

    parser.add_argument(
        "--ns_default_broker",
        action="store_true",
        help="Send messages to default broker in current namespace [default: false]",
    )

    args = parser.parse_args()

    #
    # Configure logging
    #

    try:
        logging.basicConfig(
            stream=sys.stderr,
            level=args.log_level,
            format="%(name)s (%(levelname)s): %(message)s",
        )
    except ValueError:
        logger.error("Invalid log level: {}".format(args.log_level))
        sys.exit(1)

    logger.info(
        "Log level set: {}".format(logging.getLevelName(logger.getEffectiveLevel()))
    )

    if args.ns_default_broker:
        namespace = os.getenv("NAMESPACE", "default")
        broker = f"{broker_base}/{namespace}/{broker_name}"

    else:
        broker = args.broker

    logger.info(f"Send cloud event to {broker}")

    while True:
        now = datetime.now()  # current date and time
        date_time = now.strftime("%d.%m.%Y, %H:%M:%S")
        send_cloud_event(broker, date_time + ": This is a cloud event.")
        time.sleep(10)
