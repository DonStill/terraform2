resource "aws_iam_user" "user_1" {
  name = "user123"
}

resource "aws_iam_group" "group_tf" {
  name = var.group
}

resource "aws_iam_user_group_membership" "grp_mem" {
  user = aws_iam_user.user_1.name
  groups = [ aws_iam_group.group_tf.name ]
}