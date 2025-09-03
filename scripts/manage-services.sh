#!/bin/bash
# サービス管理スクリプト

SERVICES=("wealthai-crm" "productmaster" "productmaster-mcp" "crm-mcp" "aichat" "database-mgmt")

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
        echo "=== 全サービス状態 ==="
        for service in "${SERVICES[@]}"; do
            echo "--- $service ---"
            sudo systemctl status $service --no-pager -l
            echo
        done
        ;;
    enable)
        echo "=== 自動起動有効化 ==="
        for service in "${SERVICES[@]}"; do
            echo "有効化: $service"
            sudo systemctl enable $service
        done
        ;;
    disable)
        echo "=== 自動起動無効化 ==="
        for service in "${SERVICES[@]}"; do
            echo "無効化: $service"
            sudo systemctl disable $service
        done
        ;;
    logs)
        service_name="${2:-wealthai-crm}"
        echo "=== $service_name ログ ==="
        sudo journalctl -u $service_name -f
        ;;
    *)
        echo "使用方法: $0 {start|stop|restart|status|enable|disable|logs [service_name]}"
        echo "サービス: ${SERVICES[*]}"
        exit 1
        ;;
esac
