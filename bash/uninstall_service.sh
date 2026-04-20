#!/usr/bin/env bash

# 用法：
# sudo ./uninstall_service.sh <service_name>

set -e

SERVICE_NAME="$1"

if [[ -z "$SERVICE_NAME" ]]; then
    echo "Usage: sudo $0 <service_name>"
    exit 1
fi

SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

echo "Stopping service..."
systemctl stop "$SERVICE_NAME" 2>/dev/null || true

echo "Disabling service..."
systemctl disable "$SERVICE_NAME" 2>/dev/null || true

echo "Removing service file..."
if [[ -f "$SERVICE_FILE" ]]; then
    rm -f "$SERVICE_FILE"
    echo "Removed $SERVICE_FILE"
else
    echo "Service file not found: $SERVICE_FILE"
fi

echo "Reloading systemd daemon..."
systemctl daemon-reload
systemctl reset-failed

echo "Done."
