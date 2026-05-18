variable "PUSH" {
  default = "true"
}

variable "REPOSITORY" {
  default = "runpod"
}

variable "WORKER_VERSION" {
  default = "0.0.1"
}

group "all" {
  targets = ["worker-1281"]
}

target "worker-1281" {
  tags = ["${REPOSITORY}/worker-infinity-embedding:${WORKER_VERSION}-cuda12.8.1"]
  context = "."
  dockerfile = "Dockerfile"
  output = ["type=docker,push=${PUSH}"]
}