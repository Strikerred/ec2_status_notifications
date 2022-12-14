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
            "AuthorizeSecurityGroupIngress",
            "RevokeSecurityGroupIngress"
        ],
        "requestParameters": {
            "groupId": [
                ${security_group_id}
            ]
        }
    }
}