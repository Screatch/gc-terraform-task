require 'aws-sdk' # Version 2.5.5
require 'net/ssh'

Aws.config.update({
  region: 'eu-west-1',
  credentials: Aws::SharedCredentials.new(path: '.credentials')
})

ec2 = Aws::EC2::Client.new
reservations = ec2.describe_instances(filters:[
		{ name: 'tag-key', values: ['deploy'] },
		{ name: 'instance-state-name', values: ['running'] }
	]).reservations


reservations.each do |reservation|
	reservation.instances.each do |instance|
		Net::SSH.start(instance.public_ip_address, 'ubuntu') do |ssh|
		  # capture all stderr and stdout output from a remote process
		  output = ssh.exec!("sudo local_chef_deploy")
		  puts output
		end
	end	
end	