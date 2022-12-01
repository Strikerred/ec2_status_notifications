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
            "DetachNetworkInterface"
        ],
        "requestParameters": {
            "attachmentId": [
                ${eni_attachment_id}
            ]
        }
    }
}