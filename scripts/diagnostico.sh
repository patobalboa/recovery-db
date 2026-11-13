#!/usr/bin/env bash
# Inventario NO destructivo, sin claves ni secretos.
set -u
echo "=== FECHA / HOST ==="
date -Is
hostname
echo "=== OS ==="
cat /etc/os-release | grep -E '^(NAME|VERSION)=' || true
echo "=== CPU / RAM / DISK ==="
nproc
free -h
df -h
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
echo "=== POSTGRES ==="
psql --version 2>/dev/null || true
systemctl is-active postgresql 2>/dev/null || true
ss -lnt | grep ':5432 ' || true
echo "=== GIT ==="
git rev-parse --short HEAD 2>/dev/null || true
echo "No se muestran claves, credenciales ni datos sensibles."
