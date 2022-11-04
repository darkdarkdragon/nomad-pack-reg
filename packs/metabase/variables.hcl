variable "job_name" {
  type        = string
  description = "The name to use as the job name which overrides using the pack name"
}

variable "machine_name" {
  type = string
  description = "The name of the machine on which to deploy."
  default = "machine"
}
