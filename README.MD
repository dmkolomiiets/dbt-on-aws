https://jaehyeon.me/blog/2022-11-01-dbt-on-aws-part-4-emr-eks/
https://jaehyeon.me/blog/2022-10-09-dbt-on-aws-part-2-glue/
https://docs.getdbt.com/docs/core/connect-data-platform/glue-setup

*Spark Thrift Server*
https://jaehyeon.me/blog/2022-11-01-dbt-on-aws-part-4-emr-eks/
The article discusses implementing data transformation pipelines using dbt on Amazon EMR on EKS. A significant aspect is overcoming a limitation where Spark Submit doesn't allow the Spark Thrift Server to run in cluster mode on Kubernetes. The author creates a wrapper class to address this issue, enabling a long-running Thrift JDBC/ODBC server on EMR on EKS, which is crucial for using the dbt-spark adapter. This setup facilitates scalable data transformations, leveraging AWS's autoscaling and reduced scheduling latency features through Karpenter, managing EMR job pods within an Amazon EKS cluster

1. Limitations and Benefits:
  - Limitation: Can't write/read into/from Hudi. Was not able configure hudi datasource implementation 
  - Benefit: Read/Write into CSV, JSON, parquet, .etc works out of box
  - Limitation: Spark Thrift Server can't run in cluster mode on Kubernetes natively.
  - Benefit: The wrapper class allows overcoming this limitation, enabling scalable data transformations on EMR on EKS.

2. Capabilities:
  - The setup enables data transformation pipelines using dbt on Amazon EMR on EKS, allowing scalable data processing and analytics.

3. Operation and Scalability:
  - The infrastructure leverages an Amazon EKS cluster and EMR virtual cluster, with auto-scaling managed by Karpenter, promoting scalability.

4. Extension beyond Spark SQL:
  - For connecting to Spark Thrift Server used dbt-spark[PyHive] library and it allow ONLY Spark SQL

AWS Glue interactive sessions

https://jaehyeon.me/blog/2022-10-09-dbt-on-aws-part-2-glue/
https://docs.getdbt.com/docs/core/connect-data-platform/glue-setup#always-schema-never-database

1. Limitations and Benefits:
  - Benefit: Hudi works on reading and writing

2. Capabilities:
  - The setup enables data transformation pipelines using dbt on AWS Glue, allowing scalable data processing and analytics need only properly configured interactive sessions.

3. Operation and Scalability:
  - For each dbt run will be created interactive sessions and after finishing execution it will be terminated.

4. Extension beyond Spark SQL:
  - Can be used not only for Spark SQL (we able extend functionality by adding custom python code) like example DBT adapter for reading only new hudi data can be modified by next code



DBT .dbt/profiles.yml
```yaml
dbt_glue_proj:
  outputs:
    dev:
      conf: spark.serializer=org.apache.spark.serializer.KryoSerializer --conf spark.sql.hive.convertMetastoreParquet=false
        --conf mapreduce.input.fileinputformat.input.dir.recursive=true
      database: imdb
      datalake_formats: hudi
      glue_version: '4.0'
      idle_timeout: 60
      location: s3://glue-<ID>-us-east-1
      query_timeout_in_seconds: 300
      region: us-east-1
      role_arn: arn:aws:iam::<ID>:role/glue-glue-interactive-session
      schema: imdb
      session_provisioning_timeout_in_seconds: 240
      type: glue
      worker_type: G.1X
      workers: 3
  target: dev
emr_eks:
  outputs:
    dev:
      host: a0d03865b635744e2bd3722d1c6efac3-911306355.us-east-1.elb.amazonaws.com
      method: thrift
      port: 10001
      schema: emr_eks
      threads: 3
      type: spark
  target: dev
```

