### VPC DEPLOYER ###

# 1. LOCAL VARIABLE
locals {
  rootname2 = "deploymainvpc"
}

# 2. CREATE THE MAIN ROLE WITH INLINE ATTACHED POLICY TO MAKE IT ASSUMABLE
resource "aws_iam_role" "deploymainvpc-role" {
  name = "${local.tfsettings.prefix}-${local.rootname2}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = { "AWS" : "${local.tfsettings.accountnumber}" }
    }]
  })
}

# 3. CREATE THE POLICY FOR THE MAIN ROLE
resource "aws_iam_policy" "deploymainvpc-policy" {
  name        = "${local.tfsettings.prefix}-${local.rootname2}-policy"
  description = "IAM policy for Main VPC deployment"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:DescribeVpcs",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:DescribeSubnets",
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:DescribeRouteTables",
          "ec2:CreateInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DescribeInternetGateways",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:DescribeSecurityGroups",
          "ec2:CreateNetworkAcl",
          "ec2:DeleteNetworkAcl",
          "ec2:CreateNetworkAclEntry",
          "ec2:DeleteNetworkAclEntry",
          "ec2:DescribeNetworkAcls",
          "ec2:CreateVpcPeeringConnection",
          "ec2:DeleteVpcPeeringConnection",
          "ec2:AcceptVpcPeeringConnection",
          "ec2:DescribeVpcPeeringConnections"
        ],
        Resource = "*",
      },
    ],
  })
}

# 4. ATTACH THE POLICY FOR THE MAIN ROLE
resource "aws_iam_policy_attachment" "deploymainvpc-role-policy-attachment" {
  name       = "${local.tfsettings.prefix}-${local.rootname2}-attachment"
  policy_arn = aws_iam_policy.deploymainvpc-policy.arn
  roles       = [aws_iam_role.deploymainvpc-role.name]
}

# 5. CREATE GROUP
resource "aws_iam_group" "deploymainvpc-group" {
  name = "${local.tfsettings.prefix}-${local.rootname2}"
}

# 6. ALLOW THE GROUP TO ASSUME THE ROLE
resource "aws_iam_policy" "assume-deploymainvpc-policy" {
  name        = "${local.tfsettings.prefix}-assume-${local.rootname2}-policy"
  description = "Allow assuming the deploy Main vpc role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "arn:aws:iam::${local.tfsettings.accountnumber}:role/${local.tfsettings.prefix}-${local.rootname2}-role"
    }]
  })
}

# 7. ATTACH ASSUME POLICY TO THE GROUP
resource "aws_iam_group_policy_attachment" "deploymainvpc-group-policy-attachment" {
  group      = aws_iam_group.deploymainvpc-group.name
  policy_arn = aws_iam_policy.assume-deploymainvpc-policy.arn
}
