#!/bin/bash
# chkconfig: 2345 75 25
# description: etcd service


pidfile="/var/run/etcd.pid"
progname="etcd"
hostip="192.168.33.10"
node=`hostname`
datadir="/var/lib/etcd"

. /etc/rc.d/init.d/functions

case "$1" in
    start)\
        echo -n "Starting $progname: "
        /opt/etcd/etcd --name $node \
            --data-dir $datadir \
            --listen-client-urls http://${hostip}:2379,http://127.0.0.1:2379 \
            --advertise-client-urls http://${hostip}:2379 \
            --listen-peer-urls http://${hostip}:2380 \
            --initial-advertise-peer-urls http://${hostip}:2380 \
            --initial-cluster $node=http://${hostip}:2380 \
            --initial-cluster-token some-token \
            --initial-cluster-state new \
            >>/var/log/etcd.log 2>&1 &
        echo $! > $pidfile
        echo "OK"
    ;;

    status)
        status -p $pidfile $progname
    ;;

    stop)
        echo -n "Shutting $progname: "
	if [ -f "$pidfile" ]
	then
	    kill -9 `cat $pidfile`
	    rm -f $pidfile
	fi
        echo "OK"
    ;;

    *)
        echo $"Usage: $0 {start|stop|status}"
        exit 2
esac
exit
