#!/bin/bash
set -euo pipefail

mkdir -p /opt/three-tier-app

cat > /opt/three-tier-app/app.py <<'PY'
from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import os
import socket
import urllib.request

DATABASE_HOST = "${database_host}"
DATABASE_PORT = int("${database_port}")


def metadata(path):
    token_request = urllib.request.Request(
        "http://169.254.169.254/latest/api/token",
        method="PUT",
        headers={"X-aws-ec2-metadata-token-ttl-seconds": "21600"},
    )
    with urllib.request.urlopen(token_request, timeout=2) as response:
        token = response.read().decode()

    request = urllib.request.Request(
        f"http://169.254.169.254/latest/meta-data/{path}",
        headers={"X-aws-ec2-metadata-token": token},
    )
    with urllib.request.urlopen(request, timeout=2) as response:
        return response.read().decode()


def database_status():
    if not DATABASE_HOST:
        return "not configured"

    try:
        with socket.create_connection((DATABASE_HOST, DATABASE_PORT), timeout=2):
            return "connected"
    except OSError:
        return "unreachable"


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"ok\n")
            return

        body = {
            "instance_id": metadata("instance-id"),
            "availability_zone": metadata("placement/availability-zone"),
            "database_status": database_status(),
            "health_check": "/health",
        }

        response = json.dumps(body, indent=2).encode()
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(response)))
        self.end_headers()
        self.wfile.write(response)

    def log_message(self, format, *args):
        return


HTTPServer(("0.0.0.0", 80), Handler).serve_forever()
PY

cat > /etc/systemd/system/three-tier-app.service <<'SERVICE'
[Unit]
Description=Three-tier project application
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/bin/python3 /opt/three-tier-app/app.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable --now three-tier-app.service
