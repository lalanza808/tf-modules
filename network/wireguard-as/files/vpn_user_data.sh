#!/bin/bash

set -x



# Set variables
export INSTANCE_ID=$(curl -s 169.254.169.254/latest/meta-data/instance-id)
export INSTANCE_PRIVATE_IP=$(curl -s 169.254.169.254/latest/meta-data/local-ipv4)
export PRIMARY_NETWORK_INT=$(netstat -i | grep -v "Iface\|Kern\|lo" | awk '{print $1}')
export APP_REPO=https://github.com/lalanza808/wgas
export APP_USER=wgas
export APP_SVC=wgas
export APP_HOME=/opt/wgas
export SYSTEMD_PATH=/lib/systemd/system/wgas.service
export WG_HOME=/etc/wireguard
export WGAS_ENDPOINT=${ENDPOINT}
export WGAS_SUDO=true
export WGAS_DNS=$INSTANCE_PRIVATE_IP
export WGAS_ROUTE=${CLIENT_ROUTE}
export WGAS_PORT=${WIREGUARD_PORT}


# Update package meta
apt-get update > /var/log/init-apt-update.log


# Auto upgrade OS if specified
if [[ ${AUTO_UPGRADE} == "true" ]]; then
  apt-get upgrade -y > /var/log/init-apt-upgrade.log
fi


# Install base packages
apt-get install -y awscli git sudo gettext build-essential software-properties-common > /var/log/init-base-packages.log


# Install WireGuard
add-apt-repository -y ppa:wireguard/wireguard
apt-get update >> /var/log/init-apt-update.log
apt-get install -y linux-headers-$(uname -r) wireguard iptables resolvconf > /var/log/init-wireguard-packages.log


# Setup traffic forwarding and routing
iptables -A FORWARD -i wg0 -j ACCEPT
iptables -t nat -A POSTROUTING -o $PRIMARY_NETWORK_INT -j MASQUERADE
mkdir -p /etc/iptables
iptables-save > /etc/iptables/rules.v4
sysctl -w net.ipv4.ip_forward=1


# Initialize WireGuard configs
aws s3api head-object --bucket ${CONFIG_BUCKET} --key wg0.conf
if [[ "$?" -eq 0 ]]; then
  echo "[+] Copying existing WireGuard configs and keys to system from s3://${CONFIG_BUCKET}"
  aws s3 sync s3://${CONFIG_BUCKET}/ $WG_HOME/
else
  echo "[+] Generating new WireGuard config"
  wg genkey | tee $WG_HOME/privkey | wg pubkey > $WG_HOME/pubkey
  cat << EOF > $WG_HOME/wg0.conf
[Interface]
Address = ${WIREGUARD_INTERFACE}
ListenPort = ${WIREGUARD_PORT}
PrivateKey = $(cat $WG_HOME/privkey)
SaveConfig = true
EOF
  aws s3 sync $WG_HOME/ s3://${CONFIG_BUCKET}/
fi


# Enable and start wg-quick service
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0


# Export new environment variable
export WGAS_PUBKEY=$(cat $WG_HOME/pubkey)


# Create new app user and clone the project
useradd $APP_USER -s /sbin/nologin -M
mkdir -p $APP_HOME
git clone $APP_REPO $APP_HOME
chown -R ubuntu:ubuntu $APP_HOME


# Install Rust and build application
cat << EOF > /opt/install_app.sh
#!/bin/bash
HOME=/home/ubuntu
PATH=$PATH:~/.cargo/bin
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | RUSTUP_HOME=~/.rustup sh -s -- -y
cd $APP_HOME
echo "[+] Installing nightly Rust"
rustup override set nightly > ~/rustup-nightly.log
echo "[+] Building new release binary"
cargo build --release > ~/cargo-build.log
EOF
chmod +x /opt/install_app.sh
sudo -u ubuntu -E /opt/install_app.sh


# Add app user to sudoers file
echo "$APP_USER ALL=(ALL) NOPASSWD: $(which wg), $(which wg-quick)" >> /etc/sudoers


# Setup systemd service
cat $APP_HOME/util/wgas.service | envsubst > $SYSTEMD_PATH
chmod 755 $SYSTEMD_PATH
systemctl daemon-reload
systemctl enable $APP_SVC
systemctl start $APP_SVC


# Elastic IP attachment
aws ec2 associate-address --allocation-id ${EIP_ID} --instance-id $INSTANCE_ID --region ${REGION}
