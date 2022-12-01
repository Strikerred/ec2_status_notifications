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
            "ModifyNetworkInterfaceAttribute"
        ],
        "requestParameters": {
            "networkInterfaceId": [
                ${network_interface_id}
            ]
        }
    }
}