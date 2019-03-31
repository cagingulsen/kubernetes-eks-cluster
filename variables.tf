variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type        = "list"

  default = [
    /*
    {
      user_arn = "arn:aws:iam::11111111111:user/example-user"
      username = "example-user"
      group    = "system:masters"
    }
    */
  ]
}

variable "map_users_count" {
  description = "The count of roles in the map_users list."
  type        = "string"
  default     = 0
}


