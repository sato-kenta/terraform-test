# 構成図

```mermaid
graph LR
    A[クライアント] --> B{Internet Gateway}
    B --> C[Route Table]
    C --> D[Public Subnet 1a]
    C --> E[Public Subnet 1b]
    C --> F[Public Subnet 1c]
    D --> K[Route Table]
    E --> L[Route Table]
    F --> M[Route Table]
    K --> N[Private Subnet 1a]
    L --> O[Private Subnet 1a]
    M --> P[Private Subnet 1a]

    D[Public Subnet 1a]
    subgraph D [Public Subnet 1a]
        G[Nat Gateway]
    end
    E[Public Subnet 1c]
    subgraph E [Public Subnet 1c]
        H[Nat Gateway]
    end
    F[Public Subnet 1c]
    subgraph F [Public Subnet 1d]
        I[Nat Gateway]
    end

    classDef className fill:#f9f,stroke:#333,stroke-width:4px;
    class A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P className;
```

# コマンド
```
# 環境変数読み込み（これは一番最初に実行する）
# ~/.aws/credentialに登録していること
$ export AWS_PROFILE="satoken"

# 初期化
$ terraform init

# 検証
$ terraform plan

# 適用
$ terraform apply

# 削除
$ terraform destroy
```