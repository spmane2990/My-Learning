"""
Example AWS Lambda handler used by the sample Step Functions state machine.

This file is intentionally lightweight and well-documented so you can
understand how the Step Functions Task states interact with Lambda.

Key behaviors demonstrated:
- Return a simple success result containing echoed input.
- If `event['fail']` is truthy, raise an exception to simulate task failures.
- If `event` contains a `taskToken`, return a structure that a real async
  starter would use to begin a callback-style Task.

Usage: Zip and deploy this handler as a Lambda (Python 3.9+) and update the
ARN references inside `statemachine/state_machine.asl.yaml` before using.
"""

import json
from typing import Any, Dict


def handler(event: Dict[str, Any], context) -> Dict[str, Any]:
    """Lambda entrypoint used by Step Functions Task states.

    Args:
        event: The event payload passed from Step Functions. Step Functions
            populates this with whatever `Parameters` you give it.
        context: Lambda context object (not used in this example).

    Returns:
        A dict representing the function result. The example state machine
        expects objects to have at least a `status` field.

    Behavior:
        - If `event.get('fail')` is truthy, the function raises an Exception
          so that the state machine can exercise Retry/Catch behavior.
        - If `taskToken` is present in the event, we return an object that
          includes the token, simulating a started async work item.
        - Otherwise, return a success payload containing an echo of the input.
    """

    # Simulate a failure path to exercise Retry / Catch in Step Functions
    if event.get("fail"):
        raise Exception("Simulated failure from Lambda (event requested fail)")

    # Simulate starting an async job when a Step Functions Task Token is provided.
    if "taskToken" in event:
        # In a real-world integration you would persist the token and resume
        # the Step Functions execution later by calling the Step Functions
        # API with the token using SendTaskSuccess/SendTaskFailure.
        return {
            "status": "started",
            "message": "Callback task started; awaiting external completion",
            "token": event.get("taskToken"),
        }

    # Normal synchronous success response
    return {
        "status": "success",
        "data": {
            "echo": event,
        },
    }
