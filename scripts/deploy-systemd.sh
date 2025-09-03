#!/bin/bash
# systemd一括デプロイスクリプト

echo "=== WealthAI Enterprise Systems - systemd一括デプロイ ==="

SERVICES=("wealthai-crm" "productmaster" "productmaster-mcp" "crm-mcp" "aichat" "database-mgmt")

# 1. 既存プロセス停止
echo "=== 既存プロセス停止 ==="
pkill -f "python3.*8004" || true
pkill -f "python3.*8006" || true

# 2. systemdファイルコピー
echo "=== systemdファイルコピー ==="
for service in "${SERVICES[@]}"; do
    if [ -f "/home/ec2-user/enterprise-systemd/systemd/${service}.service" ]; then
        echo "コピー: ${service}.service"
        sudo cp "/home/ec2-user/enterprise-systemd/systemd/${service}.service" "/etc/systemd/system/"
    else
        echo "警告: ${service}.service が見つかりません"
    fi
done

# 3. systemd再読み込み
echo "=== systemd再読み込み ==="
sudo systemctl daemon-reload

# 4. 全サービス有効化
echo "=== 全サービス有効化 ==="
for service in "${SERVICES[@]}"; do
    echo "有効化: $service"
    sudo systemctl enable $service
done

# 5. 全サービス開始
echo "=== 全サービス開始 ==="
for service in "${SERVICES[@]}"; do
    echo "開始: $service"
    sudo systemctl start $service
    sleep 3
done

# 6. 状態確認
echo "=== 状態確認 ==="
for service in "${SERVICES[@]}"; do
    status=$(sudo systemctl is-active $service)
    echo "$service: $status"
done

echo "=== デプロイ完了 ==="
