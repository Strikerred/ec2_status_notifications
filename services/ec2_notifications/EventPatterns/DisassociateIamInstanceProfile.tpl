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
            "DisassociateIamInstanceProfile"
        ],
        "responseElements": {
            "DisassociateIamInstanceProfileResponse": {
                "iamInstanceProfileAssociation": {
                    "instanceId": [
                        ${instance_id}
                    ]
                }
            }
        }
    }
}