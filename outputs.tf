output "shepherd_users_role_arn" {
  value       = aws_iam_role.shepherd_users.arn
  description = "shepherd-users role arn"
}