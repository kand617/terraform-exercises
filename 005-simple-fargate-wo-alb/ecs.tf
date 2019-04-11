
resource "aws_ecs_cluster" "main" {
  name = "tf-ecs-cluster",
  
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "fargate-ecs-task-execution-role",
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_cloudwatch" {
  role       = "${aws_iam_role.ecs_task_execution_role.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_task_definition" "app" {
  family                   = "app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
  execution_role_arn       = "${aws_iam_role.ecs_task_execution_role.arn}"
  task_role_arn            = "${aws_iam_role.ecs_task_execution_role.arn}"

  container_definitions = <<DEFINITION
[
  {
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options": {
        "awslogs-region" : "us-west-2",
        "awslogs-group": "awslogs-app",
        "awslogs-stream-prefix": "app"

      }
    },
    "cpu": ${var.fargate_cpu},
    "image": "${var.app_image}",
    "memory": ${var.fargate_memory},
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ],
    "environment": [
        {
            "name": "REDIS",
            "value": "redis://cluster-example.oswru1.0001.usw2.cache.amazonaws.com:6379"
        }
    ]
  },
  {
    "logConfiguration" : {
      "logDriver" : "awslogs",
      "options": {
        "awslogs-region" : "us-west-2",
        "awslogs-group": "awslogs-app",
        "awslogs-stream-prefix": "app"

      }
    },
    "cpu": ${var.fargate_cpu},
    "image": "${var.app_image}",
    "memory": ${var.fargate_memory},
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ],
    "environment": [
        {
            "name": "REDIS",
            "value": "redis://cluster-example.oswru1.0001.usw2.cache.amazonaws.com:6379"
        }
    ]
  }
]
DEFINITION
}


# # Traffic to the ECS Cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "tf-ecs-tasks"
  description = "security group for ECS tasks"
  vpc_id      = "${aws_vpc.my_vpc.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "${var.app_port}"
    to_port         = "${var.app_port}"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}




resource "aws_ecs_service" "main" {
  name            = "tf-ecs-service"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"
  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = ["${aws_subnet.my_private_subnet_001.id}"]
  },
  depends_on= ["aws_ecs_task_definition.app"]

#   load_balancer {
#     target_group_arn = "${aws_alb_target_group.app.id}"
#     container_name   = "app"
#     container_port   = "${var.app_port}"
#   }

#   depends_on = [
#     "aws_alb_listener.front_end",
#   ]
}

