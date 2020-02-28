variable "registry" {
  default = "436196666173.dkr.ecr.us-east-1.amazonaws.com"
}

locals {
  tag = "1.13.9-patched-${builtins.gitRevisionShort}"
  image_name = "cluster-autoscaler"
}

exec "build" {
  command = "make"
  args    = [
    "-C",
    "cluster-autoscaler",
    "build-in-docker"
  ]
}

docker_release "cluster-autoscaler" {
  depends_on = ["exec.build"]
  registry   = "${var.registry}"
  image      = "${local.image_name}"
  tag        = "${local.tag}"

  exec = {
    command = "make"
    args    = [
      "-C",
      "cluster-autoscaler",
      "make-image"
    ]
    env     = {
      TAG      = "${local.tag}"
      REGISTRY = "${var.registry}"
    }
  }
}
