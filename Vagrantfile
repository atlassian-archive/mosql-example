require 'json'

$salt_version = "v2015.8.0"
# vagrant box add aws https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box
$box = "aws"
$aws_cf_stack_name = ARGV[-1]
$aws_cf = JSON.parse(`aws --region #{ENV['AWS_REGION']} cloudformation describe-stacks --stack-name #{$aws_cf_stack_name}`)

Vagrant.configure("2") do |config|

  config.vm.define "#{$aws_cf_stack_name}" do |node|
    node.vm.box = "#{$box}"
    node.vm.hostname = "#{$aws_cf_stack_name}"

    node.vm.synced_folder   ".",              "/vagrant",        type: "rsync",  disabled: true
    node.vm.synced_folder   "salt/states",    "/srv/salt/base",  type: "rsync",  disabled: false

    node.vm.provision :salt do |salt|
      salt.install_master = false
      salt.install_type = "git"
      salt.bootstrap_options = "-F -c /tmp/ -P"
      salt.install_args = $salt_version
      salt.always_install = true
      salt.bootstrap_script = "salt/config/bootstrap-salt.sh"
      salt.minion_config = "salt/config/minion"
      salt.run_highstate = true
      salt.colorize = true
      salt.verbose = true
    end

    node.vm.provider :aws do |aws, override|
      aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
      aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
      aws.keypair_name = ENV['AWS_KEYPAIR_NAME']
      override.ssh.private_key_path = ENV['SSH_KEY_PATH']
      override.ssh.username = "ubuntu"
      aws.ami = $aws_cf['Stacks'][0]['Outputs'][3]['OutputValue']
      aws.instance_type = 'c4.large'
      aws.region = ENV['AWS_REGION']
      aws.subnet_id = $aws_cf['Stacks'][0]['Outputs'][0]['OutputValue']
      aws.security_groups = [$aws_cf['Stacks'][0]['Outputs'][2]['OutputValue']]
      aws.associate_public_ip = true
      aws.tags = { 'Name' => "#{$aws_cf_stack_name}" }
    end

  end

end
