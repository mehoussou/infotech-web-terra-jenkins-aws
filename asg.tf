
#define AMI

data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

}

   
        
#DEFINE ASG LAUCNH CONFIG
   
resource "aws_launch_configuration" "custom-launch-config" {
    name = "custom-launch-config"
    image_id = data.aws_ami.latest-amazon-linux-image.id
    instance_type = "t2.micro"
    key_name = "terraform_ec2_key"
    associate_public_ip_address = true

    security_groups = [aws_security_group.custom-instance-sg.id]

    user_data = filebase64("install_apache.sh")

     
    lifecycle {
      create_before_destroy = true
    }
}
    


#define autoscalling group


resource "aws_autoscaling_group" "custom-group-autoscaling" {
    name                = "custom-group-autoscaling"
    vpc_zone_identifier = [aws_subnet.customvpc-public-1.id,aws_subnet.customvpc-public-2.id]
    launch_configuration = aws_launch_configuration.custom-launch-config.name
    min_size                    = 2
    max_size                    = 3
    health_check_grace_period   = 100
    health_check_type = "ELB"

    load_balancers = [aws_elb.custom-elb.name]
    force_delete = true

    tag {
        key = "Name"
        value = "custom_ec2_instance"
        propagate_at_launch = true
    }
}












    # output "elb" {
    #  value = aws_elb.custom-elb.dns_name
    # }

# #security group for instances
# resource "aws_security_group" "custom-instance-sg" {
#     vpc_id = aws_vpc.custom-vpc.id
#     name = "custom-instance-sg"
#     description = "security group for instances" 

# ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


#   lifecycle {
#     create_before_destroy = true
#   }
# }
    
    
    #define as config policy
    
#   resource "aws_autoscaling_policy" "custom-cpu-policy" {
#   name                   = "custom-cpu-policy"
#   scaling_adjustment     = 1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 60
#   policy_type = "SimpleScaling"
# }

  
    
    
    
    #define cloud watch monitoring
    
#   resource "aws_cloudwatch_metric_alarm" "custom-cpu-alarm" {
#   alarm_name                = "custom-cpu-alarm"
#   comparison_operator       = "GreaterThanOrEqualToThreshold"
#   evaluation_periods        = "2"
#   metric_name               = "CPUUtilization"
#   namespace                 = "AWS/EC2"
#   period                    = "120"
#   statistic                 = "Average"
#   threshold                 = "20"
#   alarm_description         = "This metric monitors ec2 cpu utilization"
#   dimensions = {
#     AutoScalingGroupName" :aws_autoscaling_group.custom-group-autoscaling.name
#    }
#    actions_enabled = true
#    alarm_actions = [aws_autoscaling_policy.custom-cpu-policy.arn]
    
    
    
#     #define auto descaling policy
    
#   resource "aws_autoscaling_policy" "custom-cpu-policy-scaledown" {
#   name                   = "custom-cpu-policy-scaledown"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 60
#   policy_type = "SimpleScaling"
# }

#       #define descaling cloud watch
      
#   resource "aws_cloudwatch_metric_alarm" "custom-cpu-alarm-scaledown" {
#   alarm_name                = "custom-cpu-alarm-scaledown"
#   comparison_operator       = "LessThanOrEqualToThreshold"
#   evaluation_periods        = "2"
#   metric_name               = "CPUUtilization"
#   namespace                 = "AWS/EC2"
#   period                    = "120"
#   statistic                 = "Average"
#   threshold                 = "10"
#   alarm_description         = "This metric monitors ec2 cpu utilization"
#   dimensions = {
#     AutoScalingGroupName" :aws_autoscaling_group.custom-group-autoscaling.name
#    }
#    actions_enabled = true
#    alarm_actions = [aws_autoscaling_policy.custom-cpu-policy-scaledown.arn]