#!/bin/bash
# get $1 as branch
sudo adduser --shell /bin/bash --home /opt/stack stack
echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
echo -e "nameserver 178.22.122.100\nnameserver 185.51.200.2" | sudo tee  /etc/resolv.conf
sudo -i -u stack bash << EOF
git clone https://git.openstack.org/openstack-dev/devstack
cd devstack
echo -e '[[local|localrc]]\nADMIN_PASSWORD=PmSrR1399\nDATABASE_PASSWORD=$ADMIN_PASSWORD\nRABBIT_PASSWORD=$ADMIN_PASSWORD\nSERVICE_PASSWORD=$ADMIN_PASSWORD' | sudo tee  local.conf
echo -e "enable_plugin networking-odl http://git.openstack.org/openstack/networking-odl $1\nODL_MODE=allinone" | sudo tee -a local.conf
echo -e "Q_ML2_PLUGIN_MECHANISM_DRIVERS=opendaylight,logger\nODL_GATE_SERVICE_PROVIDER=vpnservice\ndisable_service q-l3" | sudo tee -a local.conf
echo -e "ML2_L3_PLUGIN=odl-router\nODL_PROVIDER_MAPPINGS={PUBLIC_PHYSICAL_NETWORK}:ens3" | sudo tee -a local.conf
git checkout $1
sudo chown -R stack:stack /opt/stack
./stack.sh
EOF
