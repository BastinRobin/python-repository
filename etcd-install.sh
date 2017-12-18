#! /bin/bash

set -e

mkdir -p /opt/etcd
mkdir -p /var/lib/etcd

curl -L -o /tmp/etcd-v3.2.11-linux-amd64.tar.gz http://storage.googleapis.com/etcd/v3.2.11/etcd-v3.2.11-linux-amd64.tar.gz
curl -L -o /tmp/etcd.service https://github.com/ttsdzzg/python-repository/raw/master/chkconfig-etcd.sh

tar xzvf /tmp/etcd-v3.2.11-linux-amd64.tar.gz -C /opt/etcd --strip-components=1

mv /tmp/etcd.service /etc/init.d/etcd
chmod +x /etc/init.d/etcd

chkconfig --add etcd
chkconfig --list etcd
service etcd start

/opt/etcd/etcd --version
ETCDCTL_API=3 /opt/etcd/etcdctl version

echo "# etcdctl alias" >> /tmp/tuotian_etcd.sh
echo "alias etcdctl='ETCDCTL_API=3 /opt/etcd/etcdctl'" >> /tmp/tuotian_etcd.sh
echo "alias etcdctl2='ETCDCTL_API=2 /opt/etcd/etcdctl'" >> /tmp/tuotian_etcd.sh
mv /tmp/tuotian_etcd.sh /etc/profile.d/
chown root:root /etc/profile.d/tuotian_etcd.sh
chmod g-w /etc/profile.d/tuotian_etcd.sh

echo "install success"


# rm /tmp/etcd-v3.2.11-linux-amd64.tar.gz


