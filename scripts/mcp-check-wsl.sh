#!/bin/bash
# WSL専用 MCP動作確認スクリプト

echo "=== WSL環境 MCP リモート診断 === $(date)"
echo

# EC2サーバー設定
EC2_HOST="44.217.45.24"

# 1. MCPヘルスチェック
echo "1. EC2 MCPヘルスチェック:"
health_response=$(curl -s --connect-timeout 5 http://$EC2_HOST:8003/health 2>/dev/null)
if [ $? -eq 0 ] && [ -n "$health_response" ]; then
    echo "  ✅ MCP Health: OK"
    echo "  Response: $health_response"
else
    echo "  ❌ MCP Health: 失敗"
fi
echo

# 2. ポータルサイト確認
echo "2. ポータルサイト確認:"
portal_response=$(curl -s --connect-timeout 5 http://$EC2_HOST/ | grep -c "Enterprise Systems Portal")
if [ "$portal_response" -gt 0 ]; then
    echo "  ✅ Portal: 正常"
else
    echo "  ❌ Portal: 異常"
fi
echo

# 3. 各システム確認
echo "3. 各システム確認:"
systems=("crm:8000:CRM" "products:8001:ProductMaster" "aichat:8002:AIChat")

for system in "${systems[@]}"; do
    IFS=':' read -r path port name <<< "$system"
    response=$(curl -s --connect-timeout 3 http://$EC2_HOST/$path/ | head -1)
    if [[ "$response" == *"<!DOCTYPE html>"* ]]; then
        echo "  ✅ $name: 正常"
    else
        echo "  ❌ $name: 異常"
    fi
done
echo

# 4. MCP機能テスト
echo "4. MCP機能テスト:"
echo "  ブラウザで確認: http://$EC2_HOST/aichat/"
echo "  MCPボタンが緑色「MCP: ON」であることを確認"
echo

# 5. トラブルシューティング
echo "5. トラブルシューティング:"
if [ -z "$health_response" ]; then
    echo "  🔧 EC2でMCPサーバー確認が必要:"
    echo "     ssh ec2-user@$EC2_HOST 'sudo systemctl status productmaster-mcp'"
    echo "     ssh ec2-user@$EC2_HOST 'sudo systemctl restart productmaster-mcp'"
else
    echo "  ✅ システム正常 - ブラウザでテスト可能"
fi
echo

# 6. 便利なコマンド
echo "6. 便利なコマンド:"
echo "  # 直接ヘルスチェック"
echo "  curl http://$EC2_HOST:8003/health"
echo "  # ブラウザアクセス"
echo "  echo 'http://$EC2_HOST/' | clip.exe  # URLをクリップボードにコピー"
echo
