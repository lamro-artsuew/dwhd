
CREATE DATABASE IF NOT EXISTS dwh;

CREATE TABLE dwh.sales (
    id UUID,
    sale_date DateTime,
    customer_id UInt32,
    amount Float64,
    status String
)
ENGINE = MergeTree
PARTITION BY toYYYYMM(sale_date)
ORDER BY (sale_date, id)
SETTINGS index_granularity = 8192;
/*
ClickHouse Table/Schema
External Table using Iceberg & S3/MinIO
*/

CREATE TABLE dwh.sales_iceberg
ENGINE = Iceberg('s3://dwh-lake/sales/', 'dwhadmin', 'MyStr0ngS3curePW', 'http://192.168.10.11:9000')
AS SELECT * FROM dwh.sales;
