
#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install awscli ruby
wget -O /tmp/install-codedeploy-agent https://aws-codedeploy-eu-west-1.s3.amazonaws.com/latest/install
chmod +x /tmp/install-codedeploy-agent
sudo /tmp/install-codedeploy-agent auto
rm /tmp/install-codedeploy-agent