#!/bin/bash

set -x

# Elastic IP attachment
INSTANCE_ID=$(curl -s 169.254.169.254/latest/meta-data/instance-id)
aws ec2 associate-address --allocation-id ${EIP_ID} --instance-id $INSTANCE_ID --region ${REGION}


# Install WireGuard and other dependencies
apt-get install -y software-properties-common
add-apt-repository -y ppa:wireguard/wireguard
apt-get update
apt-get install -y "linux-headers-$(uname -r)"
apt-get install -y wireguard iptables resolvconf awscli git sudo

# Initialization WireGuard configs
aws s3api head-object --bucket ${CONFIG_BUCKET} --key wg0.conf
if [[ "$?" -eq 0 ]]; then
  echo "[+] Copying existing WireGuard config to system from s3://${CONFIG_BUCKET}"
  aws s3 cp s3://${CONFIG_BUCKET}/wg0.conf /etc/wireguard/wg0.conf
else
  echo "[+] Generating new WireGuard config"
  wg genkey | tee /opt/privkey | wg pubkey > /opt/pubkey
  cat << EOF > /etc/wireguard/wg0.conf
[Interface]
Address = ${WIREGUARD_INTERFACE}
ListenPort = ${WIREGUARD_PORT}
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE;
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE;
PrivateKey = $(cat /opt/privkey)
SaveConfig = true
EOF
  aws s3 cp /etc/wireguard/wg0.conf s3://${CONFIG_BUCKET}/wg0.conf
fi


# Install Rust and app as a systemd service
sudo apt install build-essential -y

cat << EOF > /opt/install_app.sh
#!/bin/bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | RUSTUP_HOME=~/.rustup sh -s -- -y
source ~/.cargo/env
git clone https://github.com/lalanza808/wgas-rs ~/wgas-rs
cd ~/wgas-rs
rustup override set nightly
cargo build --release
EOF
chmod +x /opt/install_app.sh
sudo -u ubuntu /opt/install_app.sh
useradd wgas-rs -s /sbin/nologin -M
cat << EOF > /lib/systemd/system/wgas-rs.service
[Unit]
Description=WireGuard Access Server Service
ConditionPathExists=/home/ubuntu/wgas-rs/target/release/wgas-rs
After=network.target

[Service]
Type=simple
User=wgas-rs
Group=wgas-rs
LimitNOFILE=1024

Restart=on-failure
RestartSec=10
startLimitIntervalSec=60

WorkingDirectory=/home/ubuntu/wgas-rs
ExecStart=/home/ubuntu/wgas-rs/target/release/wgas-rs

# make sure log directory exists and owned by syslog
PermissionsStartOnly=true
ExecStartPre=/bin/mkdir -p /var/log/wgas-rs
ExecStartPre=/bin/chown syslog:adm /var/log/wgas-rs
ExecStartPre=/bin/chmod 755 /var/log/wgas-rs
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=wgas-rs

[Install]
WantedBy=multi-user.target
EOF
chmod 755 /lib/systemd/system/wgas-rs.service
systemctl daemon-reload
systemctl enable wgas-rs
systemctl start wgas-rs
