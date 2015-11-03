#!/bin/bash
ES_VERSION="3.3.0"
ES_DATA_DIR="/srv/eventstore/db"
ES_LOGS_DIR="/srv/eventstore/logs"
ES_USER="eventstore"
IP_LOCAL=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
IP_PUBLIC=`curl http://169.254.169.254/latest/meta-data/public-ipv4`

DST_TMP="/tmp"
DST_OPT="/opt"

ES_BASE="EventStore-OSS-Ubuntu-v${ES_VERSION}"
ES_TARBALL="${ES_BASE}.tar.gz"
DOWNLOAD_URL="http://download.geteventstore.com/binaries/${ES_TARBALL}"

echo "EventStore v${ES_VERSION}"
echo "Downloading ${ES_TARBALL} from ${DOWNLOAD_URL}"
echo "EventStore Data Dir: ${ES_DATA_DIR}"
echo "EventStore Logs Dir: ${ES_LOGS_DIR}"
echo "Node IP (Public): ${IP_PUBLIC}"
echo "Node IP (Private): ${IP_LOCAL}"

WD=`pwd`
cd ${DST_TMP}
echo "Downloading to ${DST_TMP}"
wget ${DOWNLOAD_URL}

cd ${DST_OPT}
echo "Extracting to ${DST_OPT}"
tar xzvf ${DST_TMP}/${ES_TARBALL}
cd ${WD}

echo "Installing supervisor"
apt-get install -y supervisor
service supervisor restart

echo "Creating EventStore directories: ${ES_DATA_DIR}"
mkdir -p ${ES_DATA_DIR}
echo "Creating EventStore directories: ${ES_LOGS_DIR}"
mkdir -p ${ES_LOGS_DIR}

echo "Configuring supervisor"
cat > /etc/supervisor/conf.d/eventstore.conf <<CONFEOF
[program:eventstore]
#user=${ES_USER}
directory=${DST_OPT}/${ES_BASE}/
command=/bin/bash -c "cd ${DST_OPT}/${ES_BASE} && ${DST_OPT}/${ES_BASE}/run-node.sh -Db ${ES_DATA_DIR} -Log ${ES_LOGS_DIR} --int-ip=${IP_LOCAL} --ext-ip=0.0.0.0 --run-projections=all"
autostart=true
autorestart=true
startsecs=60
stopwaitsecs=30
stderr_logfile=/var/log/eventstore.err.log
stdout_logfile=/var/log/eventstore.out.log
CONFEOF

echo "/etc/supervisor/conf.d >>>"
cat /etc/supervisor/conf.d/eventstore.conf
echo "/etc/supervisor/conf.d <<<"

echo "Supervisor: reread"
supervisorctl reread
echo "Supervisor: update"
supervisorctl update
