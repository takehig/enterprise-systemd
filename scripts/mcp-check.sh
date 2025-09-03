#!/bin/bash
# MCP動作確認標準手法 (WSL対応版)

echo "=== MCP システム診断 === $(date)"
echo

# 1. サービス状態
echo "1. MCPサービス状態:"
if command -v systemctl >/dev/null 2>&1; then
    if systemctl is-active productmaster-mcp >/dev/null 2>&1; then
        echo "  ✅ productmaster-mcp: アクティブ"
    else
        echo "  ❌ productmaster-mcp: 停止中"
    fi
else
    echo "  ⚠️  systemctl利用不可 (WSL環境)"
fi
echo

# 2. ポート確認 (WSL対応)
echo "2. ポート使用状況:"
if command -v netstat >/dev/null 2>&1; then
    if netstat -tlnp | grep :8003 >/dev/null 2>&1; then
        echo "  ✅ Port 8003: 使用中"
        netstat -tlnp | grep :8003 | sed 's/^/    /'
    else
        echo "  ❌ Port 8003: 未使用"
    fi
elif command -v ss >/dev/null 2>&1; then
    if ss -tlnp | grep :8003 >/dev/null 2>&1; then
        echo "  ✅ Port 8003: 使用中"
        ss -tlnp | grep :8003 | sed 's/^/    /'
    else
        echo "  ❌ Port 8003: 未使用"
    fi
else
    echo "  ⚠️  ポート確認コマンド利用不可"
fi
echo

# 3. ヘルスチェック
echo "3. MCPヘルスチェック:"
if command -v curl >/dev/null 2>&1; then
    health_response=$(timeout 5 curl -s http://localhost:8003/health 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$health_response" ]; then
        echo "  ✅ Health Check: OK"
        echo "  Response: $health_response"
    else
        echo "  ❌ Health Check: 失敗またはタイムアウト"
    fi
else
    echo "  ⚠️  curl利用不可"
fi
echo

# 4. プロセス確認
echo "4. MCP関連プロセス:"
mcp_processes=$(ps aux | grep -E '(simple_http_mcp|productmaster-mcp)' | grep -v grep | grep -v mcp-check)
if [ -n "$mcp_processes" ]; then
    echo "  ✅ MCPプロセスが存在:"
    echo "$mcp_processes" | sed 's/^/    /'
else
    echo "  ❌ MCPプロセスが見つかりません"
fi
echo

# 5. 修復推奨
echo "5. 修復推奨:"
if command -v systemctl >/dev/null 2>&1; then
    if ! systemctl is-active productmaster-mcp >/dev/null 2>&1; then
        echo "  🔧 sudo systemctl start productmaster-mcp"
    elif [ -z "$health_response" ]; then
        echo "  🔧 sudo systemctl restart productmaster-mcp"
    else
        echo "  ✅ MCPシステムは正常です"
    fi
else
    echo "  ⚠️  WSL環境: EC2で直接確認してください"
    echo "  🔧 EC2: sudo systemctl start productmaster-mcp"
fi
echo

# 6. 環境別テストコマンド
echo "6. 環境別テストコマンド:"
if command -v systemctl >/dev/null 2>&1; then
    echo "  # Linux/EC2環境:"
    echo "  curl http://localhost:8003/health"
    echo "  systemctl status productmaster-mcp"
    echo "  journalctl -u productmaster-mcp -f"
else
    echo "  # WSL環境:"
    echo "  curl http://44.217.45.24:8003/health"
    echo "  # EC2での確認が必要:"
    echo "  ssh ec2-user@44.217.45.24 'systemctl status productmaster-mcp'"
fi
echo
