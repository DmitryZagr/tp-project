// script for running in zeppelin

import java.io.Serializable;
import org.apache.spark.sql.AnalysisException;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.spark.sql.SparkSession;
      
System.getenv().get("MASTER")
System.getenv().get("SPARK_YARN_JAR")
System.getenv().get("HADOOP_CONF_DIR")
System.getenv().get("JAVA_HOME")
System.getenv().get("SPARK_HOME")
System.getenv().get("PYSPARK_PYTHON")
System.getenv().get("PYTHONPATH")
System.getenv().get("ZEPPELIN_JAVA_OPTS")
println(System.getenv())

val sparkSession = SparkSession.builder.master("spark://spark-master:7077").appName("spark session example").enableHiveSupport().getOrCreate()
sparkSession.sql("show tables").show()

val textFile = spark.read.textFile("hdfs://namenode:8020/lol.txt")