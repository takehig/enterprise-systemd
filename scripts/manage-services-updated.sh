#!/bin/bash
# サービス管理スクリプト (SystemPrompt追加版)

SERVICES=("wealthai-crm" "productmaster" "productmaster-mcp" "crm-mcp" "aichat" "database-mgmt" "systemprompt")

case "$1" in
    start)
        echo "=== 全サービス開始 ==="
        for service in "${SERVICES[@]}"; do
            echo "開始: $service"
            sudo systemctl start $service
            sleep 2
        done
        ;;
    stop)
        echo "=== 全サービス停止 ==="
        for service in "${SERVICES[@]}"; do
            echo "停止: $service"
            sudo systemctl stop $service
        done
        ;;
    restart)
        echo "=== 全サービス再起動 ==="
        for service in "${SERVICES[@]}"; do
            echo "再起動: $service"
            sudo systemctl restart $service
            sleep 2
        done
        ;;
    status)
        echo "=== 全サービス状態確認 ==="
        for service in "${SERVICES[@]}"; do
            echo -n "$service: "
            sudo systemctl is-active $service
        done
        ;;
    *)
        echo "使用方法: $0 {start|stop|restart|status}"
        echo "対象サービス: ${SERVICES[*]}"
        exit 1
        ;;
esac
