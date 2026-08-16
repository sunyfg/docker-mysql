-- 001_init.sql
-- Runs ONLY on the first initialization of an empty data volume
-- (see README "完全重新初始化" for how to re-run it).
-- The official mysql image entrypoint executes this against MYSQL_DATABASE.

CREATE TABLE IF NOT EXISTS health_check (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    message VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO health_check (message) VALUES ('mysql initialized successfully');