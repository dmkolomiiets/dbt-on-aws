export VIRTUAL_CLUSTER_ID=$(terraform -chdir=./infra output --raw emrcontainers_virtual_cluster_id)
export EMR_ROLE_ARN=$(terraform -chdir=./infra output --json emr_on_eks_role_arn | jq '.[0]' -r)
export DEFAULT_BUCKET_NAME=$(terraform -chdir=./infra output --raw default_bucket_name)
export AWS_REGION=$(aws ec2 describe-availability-zones --query 'AvailabilityZones[0].[RegionName]' --output text)

aws emr-containers start-job-run \
--virtual-cluster-id $VIRTUAL_CLUSTER_ID \
--name thrift-server \
--execution-role-arn $EMR_ROLE_ARN \
--release-label emr-6.8.0-latest \
--region $AWS_REGION \
--job-driver '{
    "sparkSubmitJobDriver": {
        "entryPoint": "s3://'${DEFAULT_BUCKET_NAME}'/resources/jars/spark-thrift-server-1.0.0-SNAPSHOT.jar",
        "sparkSubmitParameters": "--class io.jaehyeon.hive.SparkThriftServerRunner --jars s3://'${DEFAULT_BUCKET_NAME}'/resources/jars/spark-thrift-server-1.0.0-SNAPSHOT.jar,local:///usr/lib/hudi/hudi-spark3.3-bundle_2.12-0.11.1-amzn-0.jar,local:///usr/lib/hudi/hudi-utilities-bundle.jar,local:///usr/lib/hudi/hudi-utilities-bundle.jar,local:///usr/lib/hudi/hudi-spark-bundle.jar,local:///usr/lib/spark/external/lib/spark-avro.jar --conf spark.sql.extensions=org.apache.spark.sql.hudi.HoodieSparkSessionExtension --conf spark.serializer=org.apache.spark.serializer.KryoSerializer --conf spark.sql.hive.convertMetastoreParquet=false  --conf spark.executor.instances=3 --conf spark.executor.memory=2G --conf spark.executor.cores=1 --conf spark.driver.cores=1 --conf spark.driver.memory=2G"
        }
    }' \
--configuration-overrides file://spark-thrift-config.json



