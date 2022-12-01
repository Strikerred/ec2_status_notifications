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
            "AssociateIamInstanceProfile"
        ],
        "responseElements": {
            "AssociateIamInstanceProfileResponse": {
                "iamInstanceProfileAssociation": {
                    "instanceId": [
                        ${instance_id}
                    ]
                }
            }
        }
    }
}