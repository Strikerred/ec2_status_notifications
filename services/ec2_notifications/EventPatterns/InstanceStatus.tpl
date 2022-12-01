{
    "source": [
        "aws.ec2"
    ],
    "detail-type": [
        "AWS API Call via CloudTrail"
    ],
    "detail": {
        "eventSource": [
            "ec2.amazonaws.com"
        ],
        "eventName": [
            "RunInstances",
            "StartInstances",
            "StopInstances",
            "TerminateInstances"
        ],
        "requestParameters": {
            "instancesSet": {
                "items": {
                    "instanceId": [
                        ${instance_id}
                    ]
                }
            }
        }
    }
}