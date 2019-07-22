FROM openjdk:8-alpine

ENV SPARK_HOME=/opt/spark
ENV LIVY_HOME=/opt/livy
ENV HADOOP_CONF_DIR=/etc/hadoop/conf
ENV SPARK_USER=ticksmith
ENV SPARK_KUBERNETES_IMAGE=sunnybingome/spark8s:pyspark240py368
ENV k8s_url=https://DEB5B33A43953E4771B3BDF07D501933.yl4.ap-south-1.eks.amazonaws.com

ARG AWS_JAVA_SDK_VERSION=1.7.4
ARG HADOOP_AWS_VERSION=2.7.3
ARG LIVY_VERSION=0.6.0
ARG SPARK_VERSION=2.4.3

WORKDIR /opt

RUN apk add --update openssl wget bash && \
    wget -P /opt https://www.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop2.7.tgz && \
    tar xvzf spark-$SPARK_VERSION-bin-hadoop2.7.tgz && \
    rm spark-$SPARK_VERSION-bin-hadoop2.7.tgz && \
    ln -s /opt/spark-$SPARK_VERSION-bin-hadoop2.7 /opt/spark

RUN wget https://apache.mirrors.benatherton.com/incubator/livy/$LIVY_VERSION-incubating/apache-livy-$LIVY_VERSION-incubating-bin.zip && \
    unzip apache-livy-$LIVY_VERSION-incubating-bin.zip && \
    rm apache-livy-$LIVY_VERSION-incubating-bin.zip && \
    ln -s /opt/apache-livy-$LIVY_VERSION-incubating-bin /opt/livy && \
    mkdir /var/log/livy && \
    ln -s /var/log/livy /opt/livy/logs && \
    cp /opt/livy/conf/log4j.properties.template /opt/livy/conf/log4j.properties

RUN wget -P ${SPARK_HOME}/jars http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/$HADOOP_AWS_VERSION/hadoop-aws-$HADOOP_AWS_VERSION.jar && \
    wget -P ${SPARK_HOME}/jars http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/$AWS_JAVA_SDK_VERSION/aws-java-sdk-$AWS_JAVA_SDK_VERSION.jar && \
    wget -P ${SPARK_HOME}/jars http://central.maven.org/maven2/com/microsoft/azure/azure-storage/7.0.0/azure-storage-7.0.0.jar && \
    wget -P ${SPARK_HOME}/jars http://central.maven.org/maven2/org/apache/hadoop/hadoop-azure/2.7.5/hadoop-azure-2.7.5.jar

EXPOSE 8998


ADD livy.conf /opt/livy/conf
ADD spark-defaults.conf /opt/spark/conf/spark-defaults.conf
ADD entrypoint.sh /entrypoint.sh

ENV PATH="/opt/livy/bin:${PATH}"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["livy-server"]
