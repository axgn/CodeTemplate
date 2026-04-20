#!/usr/bin/env bash

# 用法：
# sudo ./install_service.sh <service_name> <exec_path> [description]

set -e

SERVICE_NAME="$1"
EXEC_PATH="$2"
DESCRIPTION="${3:-Custom Service}"

if [[ -z "$SERVICE_NAME" || -z "$EXEC_PATH" ]]; then
    echo "Usage: sudo $0 <service_name> <exec_path> [description]"
    exit 1
fi

SERVICE_FILE="/etc/systemd/${SERVICE_NAME}.service"

echo "Creating service file: $SERVICE_FILE"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=$DESCRIPTION
After=network.target

[Service]
Type=simple
Environment=DISPLAY=:0
Environment=XAUTHORITY=/home/aaa123/.Xauthority
Environment=DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
ExecStart=$EXEC_PATH
Restart=always
RestartSec=3

[Install]
WantedBy=default.target
EOF

echo "Reloading systemd daemon..."
systemctl daemon-reexec
systemctl daemon-reload

echo "Enabling service..."
systemctl enable "$SERVICE_NAME"

echo "Starting service..."
systemctl start "$SERVICE_NAME"

echo "Service status:"
systemctl status "$SERVICE_NAME" --no-pager
