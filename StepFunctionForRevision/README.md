# AWS Step Functions — Verbose Example

This repository contains a heavily-commented AWS Step Functions state machine example
and a minimal AWS Lambda handler to demonstrate integrations and common features.

Files added:

- `statemachine/state_machine.asl.yaml` — a commented ASL (YAML) file demonstrating
  many Step Functions features (Parallel, Map, Task, Choice, Wait, Succeed, Fail,
  Retry, Catch, ResultSelector/ResultPath, and callback token usage).
- `lambda/handler.py` — a small Python Lambda handler used by Task examples.

Before You Begin

- Install and configure the AWS CLI and ensure you have permissions to create
  Lambda functions and Step Functions state machines.
- Replace all placeholder ARNs in `statemachine/state_machine.asl.yaml` with
  real ARNs from your account (Lambda function ARNs, role ARN, etc.).

Quick deployment (manual steps)

1. Convert YAML to JSON (Step Functions APIs expect JSON). Example using Python:

```bash
python - <<'PY'
import yaml, json, sys
with open('statemachine/state_machine.asl.yaml') as f:
    obj = yaml.safe_load(f)
print(json.dumps(obj, indent=2))
PY
```

Save the JSON output to `state_machine.asl.json`.

2. Create an IAM role for Step Functions (replace `<ACCOUNT_ID>` and adjust policy):

```bash
aws iam create-role --role-name StepFunctionsStateMachineRole \
  --assume-role-policy-document file://trust-policy.json
# attach policies that allow invoking Lambda and logging to CloudWatch
```

3. Create or deploy the Lambda function(s). For a quick local deploy (not production):

```bash
zip function.zip lambda/handler.py
aws lambda create-function --function-name WorkerFunction \
  --runtime python3.9 --handler handler.handler --zip-file fileb://function.zip \
  --role arn:aws:iam::<ACCOUNT_ID>:role/YourLambdaExecutionRole
```

Update the ARNs in the ASL YAML to point to your deployed Lambda functions.

4. Create the state machine (using the JSON file produced above):

```bash
aws stepfunctions create-state-machine \
  --name VerboseExampleStateMachine \
  --definition file://state_machine.asl.json \
  --role-arn arn:aws:iam::<ACCOUNT_ID>:role/StepFunctionsStateMachineRole
```

Testing the state machine

Use `start-execution` to run the state machine. Provide JSON input matching the
structure the YAML expects (for example, include `items` for the Map state):

```bash
aws stepfunctions start-execution \
  --state-machine-arn arn:aws:states:us-east-1:<ACCOUNT_ID>:stateMachine:VerboseExampleStateMachine \
  --input '{"items": [{"id":1},{"id":2}], "other": "value"}'
```

Notes & Next steps

- The ASL file contains many placeholders and comments. Carefully replace
  function and role ARNs with ones from your AWS account.
- For production deployments, use frameworks like AWS SAM, CloudFormation,
  or the Serverless Framework to manage resources, permissions, and packaging.

I can also:

- Convert the YAML to JSON and add a CloudFormation/SAM template for deployment.
- Scaffold a SAM `template.yaml` and CI steps for building and deploying.
