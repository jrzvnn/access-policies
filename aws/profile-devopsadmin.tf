### DEVOPS ADMIN ###

# 1. LOCAL VARIABLE
locals {
  rootname1 = "devopsadmin"
}

# 2. CREATE THE MAIN ROLE WITH INLINE ATTACHED POLICY TO MAKE IT ASSUMABLE
resource "aws_iam_role" "devopsadmin-role" {
  name = "${local.tfsettings.prefix}-${local.rootname1}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = { "AWS" : "${local.tfsettings.accountnumber}" }
        # Condition = {
        #   "Bool" : {
        #     "aws:MultiFactorAuthPresent" : true
        #   }
        # }
    }]
  })
}

# 3. SKIPPED - CREATE THE POLICY FOR THE MAIN ROLE

# 4. ATTACH THE POLICY FOR THE MAIN ROLE
resource "aws_iam_role_policy_attachment" "admin-group-policy-attachment" {
  role       = aws_iam_role.devopsadmin-role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


# 5. CREATE GROUP
resource "aws_iam_group" "devopsadmin-group" {
  name = "${local.tfsettings.prefix}-${local.rootname1}"
}


# 6. ALLOW THE GROUP TO ASSUME THE ROLE
resource "aws_iam_policy" "assume-devopsadmin-policy" {
  name        = "${local.tfsettings.prefix}-assume-${local.rootname1}-policy"
  description = "Allow assuming the DevOps Admin role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "arn:aws:iam::${local.tfsettings.accountnumber}:role/${local.tfsettings.prefix}-${local.rootname1}-role"
    }]
  })
}


# 7. ATTACH ASSUME POLICY TO THE GROUP
resource "aws_iam_group_policy_attachment" "devopsadmin-group-policy-attachment" {
  group      = aws_iam_group.devopsadmin-group.name
  policy_arn = aws_iam_policy.assume-devopsadmin-policy.arn
}
