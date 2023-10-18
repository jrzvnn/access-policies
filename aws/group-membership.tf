resource "aws_iam_group_membership" "devopsadmin-group-membership" {
  name = "${local.tfsettings.prefix}-${local.rootname1}-group-membership"
  users = [
    "joriz",
  ]
  group = aws_iam_group.devopsadmin-group.name
}

resource "aws_iam_group_membership" "deploymainvpc-group-membership" {
  name = "${local.tfsettings.prefix}-${local.rootname2}-group-membership"
  users = [
    "joriz",
  ]
  group = aws_iam_group.deploymainvpc-group.name
}

resource "aws_iam_group_membership" "deployatlantis-group-membership" {
  name = "${local.tfsettings.prefix}-${local.rootname3}-group-membership"
  users = [
    "joriz",
  ] # Add the usernames as needed
  group = aws_iam_group.deployatlantis-group.name
}

resource "aws_iam_group_membership" "jenkinsdeployer-group-membership" {
  name = "${local.tfsettings.prefix}-${local.rootname4}-group-membership"
  users = [
    "joriz",
  ]
  group = aws_iam_group.deployjenkins-group.name
}
