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
            "DisassociateAddress"
        ],
        "requestParameters": {
            "associationId": [
                ${eip_association_id}
            ]
        }
    }
}