To create a network:

docker network create spark_network

Run spark master with the network :

docker run --rm -it --name spark-master --hostname spark-master \
    -p 7077:7077 -p 8080:8080 --network spark_network \
    $MYNAME/spark:latest /bin/sh

To create workers from same container :
docker run --rm -it --name spark-worker --hostname spark-worker \
    --network spark_network \
    $MYNAME/spark:latest /bin/sh


To start the master :

/spark/bin/spark-class org.apache.spark.deploy.master.Master --ip `hostname` --port 7077 --webui-port 8080

To start the worker :
/spark/bin/spark-class org.apache.spark.deploy.worker.Worker \
    --webui-port 8080 spark://spark-master:7077


To run the example :
docker run --rm -it --network spark_network \
    $MYNAME/spark:latest /bin/sh

Submit the application to spark

spark/bin/spark-submit --master spark://spark-master:7077 --class \
    org.apache.spark.examples.SparkPi \
    /spark/examples/jars/spark-examples_2.11-2.4.0.jar 1000
