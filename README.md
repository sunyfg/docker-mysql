# Docker MySQL 本地开发环境

基于 Docker Compose 的本地 MySQL 8.4 开发环境，支持 Intel Mac 与 Apple Silicon Mac。

## 项目结构

```text
.
├── compose.yaml          # Compose 配置
├── .env                  # 本地环境变量（含密码，不提交 Git）
├── .env.example          # 环境变量模板
├── .gitignore
├── README.md
└── mysql
    └── init
        └── 001_init.sql  # 首次初始化 SQL
```

## 配置

所有数据库配置均来自 `.env`：

| 变量 | 说明 | 默认值 |
|---|---|---|
| `MYSQL_IMAGE` | MySQL 镜像 | `mysql:8.4` |
| `MYSQL_PORT` | 宿主机映射端口 | `3306` |
| `MYSQL_DATABASE` | 数据库名 | `app` |
| `MYSQL_USER` | 应用用户 | `app` |
| `MYSQL_PASSWORD` | 应用用户密码 | 本地 `.env` 中的随机值 |
| `MYSQL_ROOT_PASSWORD` | root 密码 | 本地 `.env` 中的随机值 |

首次使用：`cp .env.example .env`，然后修改 `.env` 中的密码。

## 启动

```bash
docker compose up -d
```

## 查看状态

```bash
docker compose ps
```

等待 mysql 服务的 `STATUS` 变为 `healthy`。

## 查看日志

```bash
docker compose logs -f mysql
```

## 进入 MySQL

密码在本地 `.env` 中（`MYSQL_PASSWORD` / `MYSQL_ROOT_PASSWORD`），不会写入 README 或 Git。

```bash
# 以应用用户进入 app 数据库
docker compose exec mysql mysql -uapp -p app

# 以 root 进入
docker compose exec mysql mysql -uroot -p
```

## 停止

```bash
docker compose down
```

## 删除数据库并完全重新初始化

> ⚠️ 以下命令会删除本地数据库全部数据（`down -v` 会移除数据卷）：

```bash
docker compose down -v
docker compose up -d
```

注意：`mysql/init/` 下的初始化 SQL 只在数据卷首次创建（空 `/var/lib/mysql`）时执行。
修改初始化 SQL 后如需重新执行，必须按上面的方式删除 volume 后重新初始化。

## 本机程序连接数据库

默认连接参数：

```text
host:     127.0.0.1
port:     3306          # 即 .env 中的 MYSQL_PORT
database: app           # 即 .env 中的 MYSQL_DATABASE
user:     app           # 即 .env 中的 MYSQL_USER
password: 查看本地 .env 中的 MYSQL_PASSWORD
```

示例（Python / mysql client）：

```bash
mysql -h 127.0.0.1 -P 3306 -uapp -p app
```

数据持久化在 named volume `docker-mysql_mysql_data` 中，`docker compose down` 不会删除数据。