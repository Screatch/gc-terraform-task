resource "aws_placement_group" "default" {
  name     = "default-placement-group"
  strategy = "cluster"
}




resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPYQ9gY5pItfBxG2cWYRjitS8jRtmAr4GwJQxg6JHuoIkB/OYwghQL7XUQA1NBWy1QlAllBNdzMrAMfvAEar+MUBIq9lS832knpcDGFp0pqJpGU1nHh8n4gso05vNXWLfOqvTv0+haBlMPpyxQwB7baanteZUvBKBOuT2INYXn8KbyfAlSHEW9qOfFu6of5+4fx9edACeC6y8hMXQWKO2GKwLAUkVIcX7aS1gZIq2FXuxBpzs1CAXEx21vD6j8gCpRzPxCUphosFaSAwZjwInprz+eWrfKjA74NpVvgpsNQiLFG5+1c6tsynRO3Sfzy7ZBhDJ+eARimVtlfkYsCrOsyJCrAYrAE8utieBRDJWu/eiUo8dUFuC2vjjlyd2G8kyrnDV33qrI++9ONnm6TwSRUuyQd32j1azgmTFtRvLQLE9hWoU0EFejKGg4MFQwuUGBFTzrOUUVrNCNJVLG7qNXREpwnQT55Haex9JrV8u68MIJvHAHizAgzbteH2cQgbIvT2ydWSI9g8OFef4JKZMDhgx0WLWf+F71LD2Pt52+f1Ah3cYYI1ty9E/qF73F3ajVtkJu9XnmwLp8SpkZ6MNdRKc5ydtUgW/icVFlgTSxJM4MQ4KvPy92z/jGgk2IuXbNP6sMHTPj0P0QoX1uscKuSUOqm7qExGgTeLD3mTZwJQ== vitali.raikov@gmail.com"
}

resource "template_file" "user_data" {
  template = "app_install.tpl"
  vars {
    cluster = "apache2"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "default" {
  name          = "web_config"
  image_id      = "ami-785db401" # Ubuntu 16.04 provided by AWS
  instance_type = "m4.large"
  key_name 			= "${aws_key_pair.deployer.key_name}"
  user_data 		= "${template_file.user_data.rendered}"
}



resource "aws_autoscaling_group" "default" {
  availability_zones        = ["eu-west-1a"]
  name                      = "default-autoscaling-group"
  max_size                  = 2
  min_size                  = 0
  desired_capacity					= 0
  health_check_grace_period = 100
  health_check_type         = "ELB"
	placement_group           = "${aws_placement_group.default.id}"
	launch_configuration      = "${aws_launch_configuration.default.name}"
	timeouts {
    delete = "5m"
	}
}