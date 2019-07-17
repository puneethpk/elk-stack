#!/bin/bash
apt-get update
apt-get install -y curl wget unzip git jq gcc python-dev build-essential python-pip
pip install ansible==2.2.2.0 awscli==1.11.36 shyaml yamllint
pip install setuptools --upgrade

# Cloud credentials/configs
mkdir -p /home/ubuntu/.aws
printf "[default]\noutput=json\nregion=$AWS_REGION" > /home/ubuntu/.aws/config
printf "[default]\naws_access_key_id=$AWS_ACCESS_KEY\naws_secret_access_key=$AWS_SECRET_KEY" > /home/ubuntu/.aws/credentials
mkdir -p /root/.aws
cp /home/ubuntu/.aws/config /root/.aws/
cp /home/ubuntu/.aws/credentials /root/.aws/

# SSH configs
mkdir -p /root/.ssh
mv /home/ubuntu/id_rsa /home/ubuntu/.ssh
mv /home/ubuntu/id_rsa.pub /home/ubuntu/.ssh/
chmod 400 /home/ubuntu/.ssh/id_rsa
chmod 664 /home/ubuntu/.ssh/id_rsa.pub
cp /home/ubuntu/.ssh/id_rsa /root/.ssh/
cp /home/ubuntu/.ssh/id_rsa.pub /root/.ssh/

#Install KubeCTL and KOPS

#Installing KubeCTL version 1.12 for HPA Describe
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl


#Installing kops version 1.10 for metrics server and hpa to work 
curl -LO https://github.com/kubernetes/kops/releases/download/1.10.0/kops-linux-amd64
chmod +x kops-linux-amd64
mv ./kops-linux-amd64 /usr/local/bin/kops

#Hpa describe doesnt work in kubectl version 1.13,will be commented till stable kubectl version is released
#curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
#chmod +x ./kubectl
#mv ./kubectl /usr/local/bin/kubectl

#Metrics server doesnt work in kops v1.11 i.e latest version,will be commented till stable kops version is released
#curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
#chmod +x kops-linux-amd64
#mv kops-linux-amd64 /usr/local/bin/kops

#Install Heptio-Ark
wget https://github.com/heptio/ark/releases/download/v0.9.3/ark-v0.9.3-linux-amd64.tar.gz
tar -xvf ark-v0.9.3-linux-amd64.tar.gz
sudo mv ark /usr/bin/ark
rm ark-v*

if [ -z "$TOOLS" ]
then
   TOOLS1=$TOOLS
else
   TOOLS1=`echo $TOOLS|sed 's/\// /g'|sed -e "s/.*/\"&\"/"`
fi
CART=`echo $CARTRIDGE|sed 's/,/ /g'|sed -e "s/.*/\"&\"/"`
printf "export KOPS_STATE_STORE=$KOPS_STATE_STORE\nexport ZONES=$AWS_REGION"a"\nexport VPC=$VPC\nexport node_count=$NODE_COUNT\nexport node_size=$NODE_TYPE\nexport master_size=t2.medium\nexport api_loadbalancer_type=public\nexport topology=private\nexport dns=private\nexport dns_zone=$DNS_ZONE\nexport CLIENT=$CLIENT\nexport INITIAL_ADMIN_USER=ethanadmin\nexport TOOLS=$TOOLS1\nexport node_type=$NODE_TYPE\nexport CARTRIDGE=$CART" > /home/ubuntu/vars.sh
