### JENKINS DEPLOYER ###

# 1. LOCAL VARIABLE
locals {
  rootname4 = "deployjenkins"
}

# 2. CREATE THE MAIN ROLE WITH INLINE ATTACHED POLICY TO MAKE IT ASSUMABLE
resource "aws_iam_role" "deployjenkins-role" {
  name = "${local.tfsettings.prefix}-${local.rootname4}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = { "AWS" : "${local.tfsettings.accountnumber}" }
      }
    ]
  })
}

# 3. CREATE THE POLICY FOR THE JENKINS DEPLOYER ROLE
resource "aws_iam_policy" "deployjenkins-policy" {
  name        = "${local.tfsettings.prefix}-${local.rootname4}-policy"
  description = "IAM policy for Jenkins Deployer"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecs:RegisterTaskDefinition",
          "ecs:DeregisterTaskDefinition",
          "ecs:ListClusters",
          "ecs:ListTaskDefinitions",
          "ecs:DescribeContainerInstances",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeClusters",
          "ecs:ListTagsForResource",
          "ecs:RunTask",
          "ecs:StopTask",
          "ecs:DescribeTasks",
          "iam:GetRole",
          "iam:PassRole",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs",
          "logs:CreateLogGroup",
          "logs:PutRetentionPolicy",
          "iam:CreateServiceLinkedRole",
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken",
          "ecr:GetRegistryCatalogData",
          "ecr:DescribeImages",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:DescribeRepositories",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "elasticloadbalancing:CreateLoadBalancer",
          "elasticloadbalancing:CreateListener",
          "elasticloadbalancing:CreateTargetGroup",
          "elasticloadbalancing:ModifyListener",
          "elasticloadbalancing:ModifyTargetGroup",
          "elasticloadbalancing:DeleteLoadBalancer",
          "elasticloadbalancing:DeleteListener",
          "elasticloadbalancing:DeleteTargetGroup",
          "elasticloadbalancing:DescribeLoadBalancers",
          "elasticloadbalancing:DescribeListeners",
          "elasticloadbalancing:DescribeTargetGroups",
          "elasticloadbalancing:AddTags",
          "elasticloadbalancing:RemoveTags",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:DescribeTargetHealth",
          "ec2:CreateVpc",
          "ec2:CreateSubnet",
          "ec2:CreateInternetGateway",
          "ec2:CreateRouteTable",
          "ec2:AssociateRouteTable",
          "ec2:CreateNatGateway",
          "ec2:AllocateAddress",
          "ec2:CreateVpcPeeringConnection",
          "ec2:AcceptVpcPeeringConnection",
          "ec2:CreateTags"
        ],
        Resource = "*",
      },
    ],
  })
}

# 4. ATTACH THE POLICY FOR THE JENKINS DEPLOYER ROLE
resource "aws_iam_policy_attachment" "deployjenkins-role-policy-attachment" {
  name       = "${local.tfsettings.prefix}-${local.rootname4}-attachment"
  policy_arn = aws_iam_policy.deployjenkins-policy.arn
  roles      = [aws_iam_role.deployjenkins-role.name]
}

# 5. CREATE GROUP FOR JENKINS DEPLOYER
resource "aws_iam_group" "deployjenkins-group" {
  name = "${local.tfsettings.prefix}-${local.rootname4}"
}

# 6. ALLOW THE JENKINS DEPLOYER GROUP TO ASSUME THE ROLE
resource "aws_iam_policy" "assume-deployjenkins-policy" {
  name        = "${local.tfsettings.prefix}-assume-${local.rootname4}-policy"
  description = "Allow assuming the Jenkins Deployer role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "arn:aws:iam::${local.tfsettings.accountnumber}:role/${local.tfsettings.prefix}-${local.rootname4}-role"
      }
    ]
  })
}

# 7. ATTACH ASSUME POLICY TO THE GROUP
resource "aws_iam_group_policy_attachment" "deployjenkins-group-policy-attachment" {
  group      = aws_iam_group.deployatlantis-group.name
  policy_arn = aws_iam_policy.assume-deployatlantis-policy.arn
}

