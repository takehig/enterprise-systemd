# Enterprise Systems systemd Management

EC2上の3つのエンタープライズシステムのsystemd管理ファイル

## 🎯 管理対象システム

1. **WealthAI-CRM** (Port 8000) - 顧客管理システム
2. **ProductMaster** (Port 8001) - 商品管理システム  
3. **AIChat** (Port 8002) - AI対話システム
4. **ProductMaster-MCP** (Port 8003) - MCPサーバー

## 📁 ファイル構成

```
systemd/
├── wealthai-crm.service     # CRMサービス定義
├── productmaster.service    # ProductMasterサービス定義
└── aichat.service          # AIChatサービス定義

scripts/
└── manage-services.sh      # 統合サービス管理スクリプト
```

## 🚀 使用方法

### systemdサービスファイル配置
```bash
sudo cp systemd/*.service /etc/systemd/system/
sudo systemctl daemon-reload
```

### サービス管理
```bash
# 統合管理スクリプト使用
./scripts/manage-services.sh start     # 全サービス開始
./scripts/manage-services.sh stop      # 全サービス停止
./scripts/manage-services.sh restart   # 全サービス再起動
./scripts/manage-services.sh status    # 全サービス状態確認

# 個別サービス管理
sudo systemctl start wealthai-crm
sudo systemctl stop productmaster
sudo systemctl restart aichat
```

### 自動起動設定
```bash
./scripts/manage-services.sh enable    # 自動起動有効化
./scripts/manage-services.sh disable   # 自動起動無効化
```

### ログ確認
```bash
./scripts/manage-services.sh logs wealthai-crm
sudo journalctl -u productmaster -f
```

## 🔧 サービス仕様

### 共通設定
- **User/Group**: ec2-user
- **Restart**: always (3秒間隔)
- **Logging**: systemd journal

### 個別設定
- **CRM**: PYTHONPATH設定でモジュール解決
- **ProductMaster**: fixed_main.py使用
- **AIChat**: 標準uvicorn起動

## 📋 デプロイ履歴

- **2025-08-26**: 初回systemd化実装
- **作成者**: Amazon Q
- **EC2インスタンス**: i-087fe7edbc1cfad6a
