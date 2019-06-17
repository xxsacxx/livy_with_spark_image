docker run --rm -it --name spark-master --hostname spark-master \
    -p 7077:7077 -p 8083:8083 --network spark_network \
    $MYNAME/spark:latest /bin/sh

/spark/bin/spark-class org.apache.spark.deploy.worker.Worker --webui-port 8083 spark://spark-master:7077



bin/spark-submit  \
    --master k8s://https://35.185.176.81\
    --deploy-mode cluster  \
    --conf spark.executor.instances=1  \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark  \
    --conf spark.kubernetes.container.image=bde2020/spark-master \
    --class org.apache.spark.examples.SparkPi  \
    --name spark-pi  \
    local:///usr/local/spark/examples/jars/spark-examples_2.11-2.4.0.jar 

