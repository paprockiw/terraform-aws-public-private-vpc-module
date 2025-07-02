# Flow logs and related resources

resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name = "${var.platform}-${var.environment}_vpc_flow_log_group"
  tags = {
    Built-by    = "terraform"
    Environment = var.environment
    Name        = "${var.platform}-${var.environment}-vpc-flow-logs-group"
  }
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "${var.platform}-${var.environment}_vpc_flow_logs_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "vpc-flow-logs.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Built-by    = "terraform"
    Environment = var.environment
    Name        = "${var.platform}-${var.environment}-vpc-flow-logs-role"
  }
}

resource "aws_flow_log" "vpc_flow_logs" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id
  tags = {
    Built-by    = "terraform"
    Environment = "${var.environment}"
    Name        = "${var.platform}-${var.environment}-vpc-flow-logs"
    Tier        = "private"
  }
}

resource "aws_iam_role_policy" "iam_vpc_flow_logs_policy" {
  name = "${var.platform}-${var.environment}_vpc_flow_logs_access"
  role = aws_iam_role.vpc_flow_logs_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}
