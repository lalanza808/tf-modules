data "aws_caller_identity" "current" {}

locals {
  account_id       = data.aws_caller_identity.current.account_id
  alert_for        = "CloudTrailBreach"
  metric_namespace = "CISBenchmarks"
  metric_value     = "1"

  metric_name = [
    "CIS-3.1-AuthorizationFailureCount",
    "CIS-3.8-S3BucketActivityEventCount",
    "CIS-3.10-SecurityGroupEventCount",
    "CIS-3.11-NetworkAclEventCount",
    "CIS-3.12-NetworkGatewayEventCount",
    "CIS-3.14-VpcEventCount",
    "EC2InstanceEventCount",
    "EC2LargeInstanceEventCount",
    "CIS-3.5-CloudTrailEventCount",
    "CIS-3.6-ConsoleSignInFailureCount", # See link to this name down below
    "CIS-3.4-IAMPolicyEventCount",
    "CIS-3.2-ConsoleSignInWithoutMfaCount",
    "CIS-3.3-RootAccountUsageCount",
    "KMSKeyPendingDeletionErrorCount",
    "CIS-3.9-AWSConfigChangeCount",
    "CIS-3.13-RouteTableChangesCount",
    "CIS-3.7-ScheduledDeletionCustomerKMSKey"
  ]

  filter_pattern = [
    "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }",
    "{ ($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication)) }",
    "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup) }",
    "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }",
    "{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }",
    "{ ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }",
    "{ ($.eventName = RunInstances) || ($.eventName = RebootInstances) || ($.eventName = StartInstances) || ($.eventName = StopInstances) || ($.eventName = TerminateInstances) }",
    "{ ($.eventName = RunInstances) && (($.requestParameters.instanceType = *.8xlarge) || ($.requestParameters.instanceType = *.4xlarge) || ($.requestParameters.instanceType = *.16xlarge) || ($.requestParameters.instanceType = *.10xlarge) || ($.requestParameters.instanceType = *.12xlarge) || ($.requestParameters.instanceType = *.24xlarge)) }",
    "{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }",
    "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\") }",
    "{ ($.eventName = DeleteGroupPolicy) || ($.eventName = DeleteRolePolicy) ||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}",
    "{ $.eventName = ConsoleLogin && $.userIdentity.sessionContext.attributes.mfaAuthenticated = false && $.responseElements.ConsoleLogin = Success }",
    "{ $.userIdentity.type = Root && $.userIdentity.invokedBy NOT EXISTS && $.eventType != AwsServiceEvent }",
    "{ $.eventSource = kms* && $.errorMessage = \"* is pending deletion.\"}",
    "{ $.eventSource = config.amazonaws.com && (($.eventName=StopConfigurationRecorder)||($.eventName=DeleteDeliveryChannel) ||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder)) }",
    "{ ($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable) }",
    "{ ($.eventSource=kms.amazonaws.com) && (($.eventName=DisableKey) || ($.eventName=ScheduleKeyDeletion)) }"
  ]

  alarm_description = [
    "Alarms when an unauthorized API call is made.",
    "Alarms when an API call is made to S3 to put or delete a Bucket, Bucket Policy or Bucket ACL.",
    "Alarms when an API call is made to create, update or delete a Security Group.",
    "Alarms when an API call is made to create, update or delete a Network ACL.",
    "Alarms when an API call is made to create, update or delete a Customer or Internet Gateway.",
    "Alarms when an API call is made to create, update or delete a VPC, VPC peering connection or VPC connection to classic.",
    "Alarms when an API call is made to create, terminate, start, stop or reboot an EC2 instance.",
    "Alarms when an API call is made to create, terminate, start, stop or reboot a 4x-large or greater EC2 instance.",
    "Alarms when an API call is made to create, update or delete a .cloudtrail. trail, or to start or stop logging to a trail.",
    "Alarms when an unauthenticated API call is made to sign into the console.",
    "Alarms when an API call is made to change an IAM policy.",
    "Alarms when a user logs into the console without MFA.",
    "Alarms when a root account usage is detected.",
    "Alarms when a customer created KMS key is pending deletion.",
    "Alarms when AWS Config changes.",
    "Alarms when route table changes are detected.",
    "Alarms when a customer managed KMS key is deleted or scheduled for deletion"
  ]
}

resource "aws_cloudwatch_log_metric_filter" "default" {
  count          = length(local.filter_pattern)
  name           = "${local.metric_name[count.index]}-filter"
  pattern        = local.filter_pattern[count.index]
  log_group_name = var.log_group_name

  metric_transformation {
    name      = local.metric_name[count.index]
    namespace = local.metric_namespace
    value     = local.metric_value
  }
}

resource "aws_cloudwatch_metric_alarm" "default" {
  count               = length(local.filter_pattern)
  alarm_name          = "${local.metric_name[count.index]}-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = local.metric_name[count.index]
  namespace           = local.metric_namespace
  period              = "300" // 5 min
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"
  threshold           = local.metric_name[count.index] == "CIS-3.6-ConsoleSignInFailureCount" ? var.login_failures : 1
  alarm_description   = "AWS Account \"${var.account_name}\" (${local.account_id}) - ${local.alarm_description[count.index]}"
  alarm_actions       = [var.sns_topic_arn]
  tags                = var.tags
}
