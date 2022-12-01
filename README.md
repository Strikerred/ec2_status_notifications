# EC2 status check notifications

This repository contains all the necessary components for the ec2 status check notifications tool.

It works with 3 AWS components: CloudTrail, Eventbridge and SNS.

First, a SNS topic is created for notifications by email.

Whenever either a virtual component is added/removed or there is a status change on an instance, an event is registered by CloudTrail, and its `Event record` provides `eventName, requestParameters` and `responseElements` information which is used to define an `Eventbridge rule/Event pattern` to track and capture specific events along with their components and/or resources IDs.

For Example:

```
{
  "detail": {
    "eventName": ["DetachNetworkInterface"],
    "eventSource": ["ec2.amazonaws.com"],
    "requestParameters": {
      "attachmentId": ["eni-attach-0671xxxxxxx2df46", "eni-attach-09xxxxxxxfb0e1553"]
    }
  },
  "detail-type": ["AWS API Call via CloudTrail"],
  "source": ["aws.ec2"]
}
```

Then the target is added, and it will invoke the SNS previously created when an event matches the `event pattern`. Finally, a `target input transformer` defines what information is included in the email. 

For Example:

```
Input path:

{
  "name": "$.detail.requestParameters.attachmentId",
  "source": "$.detail.eventName",
  "time": "$.time",
  "value": "$.detail"
}

Template:

"A <source> was performed on <name> at <time> with the following details: <value>"
```

