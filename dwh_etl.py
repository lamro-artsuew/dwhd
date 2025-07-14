from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

with DAG(
    dag_id="minio_to_clickhouse_etl",
    schedule_interval="0 2 * * *",
    start_date=datetime(2024, 1, 1),
    catchup=False
) as dag:

    extract = BashOperator(
        task_id="extract_from_minio",
        bash_command="mc cp s3/dwh-landing/2024-07-14/*.parquet /tmp/etl/"
    )

    load = BashOperator(
        task_id="load_to_clickhouse",
        bash_command="clickhouse-client --host 192.168.10.12 --query \"INSERT INTO dwh.sales SELECT * FROM file('/tmp/etl/*.parquet', Parquet)\""
    )

    extract >> load
