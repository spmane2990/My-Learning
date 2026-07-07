# AWS Step Functions Revision Notes

This repository contains two practical Step Functions examples:

- [LambdaGlueAthenaS3](LambdaGlueAthenaS3) — an end-to-end data pipeline using Lambda, Glue, Athena, and S3.
- [StepFunctionForRevision](StepFunctionForRevision) — a smaller, revision-friendly example with many Step Functions patterns.

The goal of this note is to give you a quick, crisp summary of the most important Step Functions concepts.

---

## 1. What is AWS Step Functions?

AWS Step Functions is a serverless workflow orchestrator. It lets you coordinate multiple services such as Lambda, Glue, Athena, SNS, SQS, and API Gateway in a visual, state-based workflow.

Think of it as:

- a workflow engine for business processes
- a way to chain tasks together
- a tool for handling retries, branching, and failures cleanly

---

## 2. Core building blocks

### Task state

Used to call a service or function.

Example:

- invoke a Lambda function
- start a Glue job
- submit an Athena query

### Choice state

Used for branching logic.

Example:

- if validation passes, continue
- if validation fails, go to an error path

### Parallel state

Used when multiple independent tasks can run at the same time.

Example:

- validate file
- scan for virus
- check schema
- detect duplicates

### Map state

Used to process a list of items one by one.

Example:

- process each record in an array
- run the same workflow for many records

### Wait state

Used to pause execution for a duration or until a specific time.

Example:

- wait before checking Athena query status
- poll for job completion

### Pass state

Used to pass input through or transform it without calling a service.

### Succeed / Fail states

Used as terminal states.

### Retry and Catch

Used for resilience.

Example:

- retry a Lambda call 3 times
- if it still fails, route to a failure handler

---

## 3. Important Step Functions concepts

### State machine structure

A Step Functions state machine is a workflow definition written in Amazon States Language (ASL). At the top level, it typically contains:

- Comment: adds human-readable documentation
- StartAt: the first state to execute
- TimeoutSeconds: the maximum execution time allowed
- Version: optional version identifier for the definition
- States: the full collection of states in the workflow

Example:

```json
{
  "Comment": "Simple workflow",
  "StartAt": "FirstState",
  "TimeoutSeconds": 300,
  "States": {
    "FirstState": {
      "Type": "Pass",
      "End": true
    }
  }
}
```

### Common state fields

Most states share common fields such as:

- Type: the category of state, such as Task, Choice, Parallel, Map, Pass, Succeed, or Fail
- Comment: explains the purpose of the state
- Next: points to the next state in a linear flow
- End: marks the state as terminal
- Parameters: customizes the input passed to a downstream service or Lambda
- InputPath, OutputPath, ResultPath, ResultSelector: control how input and output are processed
- Retry and Catch: handle failures

### Intrinsic functions

Step Functions provides intrinsic functions to manipulate data at runtime. Common examples include:

- States.Format: format strings
- States.JsonToString: convert JSON to string
- States.StringToJson: convert string to JSON
- States.Array: create arrays
- States.MathAdd, States.MathRandom, States.MathMultiply: perform simple math
- States.ArrayPartition: split arrays for processing

These are useful when you want to build dynamic values without writing custom code.

### Input and output processing

Each state receives input and can produce output. Step Functions gives you several ways to control this flow:

- InputPath: select only a subset of the current input
- Parameters: construct a new payload for the next step
- ResultPath: place the result of a task into a specific part of the input object
- OutputPath: select the final output that is passed onward
- ResultSelector: transform task output without changing the input structure

### Ways to identify components within JSON text

Step Functions uses JSONPath-like syntax to identify values inside JSON data.

Common examples include:

- $: the entire input document
- $.name: a field named name
- $.details.id: a nested field
- $.items[0]: the first item in an array
- $.items[0].id: a nested value inside the first item
- $$.Execution.Id: execution-level context such as the execution ID

This is important for selecting the correct data before passing it to the next state.

### Passing data along the state machine

Data can be passed from one state to another in several ways:

- By default, the full input is passed to the next state
- With InputPath, only part of the input is forwarded
- With Parameters, a new payload is built for the next state
- With ResultPath, the result of a task is inserted into the current input object
- With OutputPath, only the desired portion of the final output continues downstream

A simple mental model is:

- InputPath decides what input the state sees
- Parameters decides what the state sends to a service
- ResultPath decides where the result is stored
- OutputPath decides what output continues downstream

### Execution termination

A state machine ends when it reaches a terminal state.

Common terminal states are:

- End: used by states such as Pass, Task, Parallel, and Map to stop execution normally
- Succeed: a dedicated terminal state that stops execution successfully
- Fail: a dedicated terminal state that stops execution with an error

### Parallel and Map states

#### Parallel state

Use Parallel when multiple branches can run independently at the same time.

Example use cases:

- running several validations together
- processing different business checks in parallel

#### Map state

Use Map when the same workflow must be executed for every item in an array.

Example use cases:

- processing each record in a batch
- applying the same transformation to many files

Both states are useful for fan-out processing and improve throughput when work is independent.

### Error handling

Use:

- Retry
- Catch
- Fail

### Branching

Use:

- Choice
- Next
- Default

---

## 4. Common patterns you should remember

### A. Sequential flow

A → B → C → D

Good for linear workflows such as:

- validate input
- archive file
- run ETL
- generate report

### B. Branching flow

A decision point sends execution to different paths.

Good for:

- success vs failure
- approved vs rejected

### C. Parallel flow

Multiple tasks run at the same time.

Good for:

- independent validations
- fan-out processing

### D. Polling loop

A task starts an asynchronous job, then Wait + Task checks status repeatedly.

Good for:

- Glue jobs
- Athena queries
- long-running services

### E. Map loop

The same workflow is repeated over each element in an array.

Good for:

- batch records
- multiple files
- repeated transformations

---

## 5. How the examples in this repo map to these concepts

### In [LambdaGlueAthenaS3](LambdaGlueAthenaS3)

This example shows a realistic production-style workflow:

1. Validate input file
2. Run parallel checks
3. Archive the original file
4. Start Glue ETL
5. Wait for Glue completion
6. Run Athena query
7. Generate outputs and reports
8. Handle failures with retries and catches

This is a great example of:

- Task states
- Parallel states
- Wait states
- Choice states
- Retry / Catch
- long-running orchestration

### In [StepFunctionForRevision](StepFunctionForRevision)

This example is more focused on learning the syntax and state patterns.

It helps you revise:

- Task
- Choice
- Parallel
- Map
- Wait
- Retry
- Catch
- Pass
- Succeed / Fail

---

## 6. Quick cheat sheet

```json
{
  "StartAt": "Validate",
  "States": {
    "Validate": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:region:account:function:validate",
      "Next": "CheckResult"
    },
    "CheckResult": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.status",
          "StringEquals": "SUCCESS",
          "Next": "Process"
        }
      ],
      "Default": "Fail"
    },
    "Process": {
      "Type": "Parallel",
      "Branches": [
        { "StartAt": "A", "States": { "A": { "Type": "Task", "End": true } } },
        { "StartAt": "B", "States": { "B": { "Type": "Task", "End": true } } }
      ],
      "End": true
    },
    "Fail": {
      "Type": "Fail",
      "Error": "ValidationFailed",
      "Cause": "Input was invalid"
    }
  }
}
```

---

## 7. One-line memory trick

Remember this order for quick revision:

- Start → Task → Choice → Parallel/Map → Wait → Retry/Catch → End

---

## 8. Simple workflow diagram

```mermaid
flowchart LR
A[Start] --> B[Validate]
B --> C{Valid?}
C -->|Yes| D[Run Parallel Tasks]
C -->|No| E[Fail]
D --> F[Wait for Async Job]
F --> G[Generate Report]
G --> H[End]
```

---

## 9. Fast revision checklist

Before an interview or exam, make sure you can explain:

- what a state machine is
- the difference between Task, Choice, Parallel, and Map
- when to use Wait
- how Retry and Catch work
- how to use ResultPath and Parameters
- how Step Functions coordinate Lambda, Glue, and Athena

If you want, this README can later be expanded into a more detailed interview-style guide with AWS-specific examples and diagrams.
