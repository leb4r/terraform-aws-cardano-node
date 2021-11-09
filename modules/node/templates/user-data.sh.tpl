#!/bin/bash

set -ex

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

EC2_TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
EC2_INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $EC2_TOKEN" http://instance-data/latest/meta-data/instance-id)
EC2_AVAILABILITY_ZONE=$(curl -s -H "X-aws-ec2-metadata-token: $EC2_TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)
EC2_REGION="$${EC2_AVAILABILITY_ZONE::-1}"

CARDANO_ROOT="/srv/cardano-node"
CARDANO_CONFIG="$CARDANO_ROOT/config"
CARDANO_DATA="$CARDANO_ROOT/data"

DEVICE_NAME="/dev/sdh"
DEVICE_LABEL="cardano-root"

# update packages
yum update -y

# install docker
yum install -y docker

# add ec2-user to docker group
usermod -aG docker ec2-user

# start and enable docker service
service docker start

# install docker-compose

curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# attach ebs volume
aws ec2 attach-volume --region $EC2_REGION --device $DEVICE_NAME --instance-id $EC2_INSTANCE_ID --volume-id ${ebs_volume_id}

while [[ ! -b $(readlink -f $DEVICE_NAME) ]]; do
  echo "Wating for volume attachment..."
  sleep 2
done

devpath="$(readlink -f $DEVICE_NAME)"

blkid $devpath || mkfs -t ext4 $devpath
e2label $devpath $DEVICE_LABEL

mkdir -p $CARDANO_ROOT $CARDANO_CONFIG $CARDANO_DATA
chmod -R 0755 $CARDANO_ROOT

grep -q ^LABEL=$DEVICE_LABEL /etc/fstab || echo "LABEL=$DEVICE_LABEL $CARDANO_ROOT ext4 defaults,nofail 0 2" | tee -a /etc/fstab >/dev/null

mount -a

# download node configuration
aws s3 sync s3://${config_bucket_name}/ $CARDANO_CONFIG

# create .env file
cd $CARDANO_CONFIG

echo "CARDANO_ROOT=$CARDANO_ROOT" >> $CARDANO_CONFIG/.env

/usr/local/bin/docker-compose up -d

echo $SECONDS
