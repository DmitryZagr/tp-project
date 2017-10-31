# Hive

## Новый сценарий

### Создание таблицы для данных в HDFS
При таком подходе данные представляют собой набор файлов, никак не обработанных после разархивации. Hive сделает абстракцию над ними и не будет лишний раз копировать в свою локацию для работы с ними
```sh
%hive
CREATE EXTERNAL TABLE IF NOT EXISTS [TABLE_NAME] (
     [column_name] [data_type] COMMENT '[comment]'
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t" 
STORED AS TEXTFILE 
LOCATION "[path to extracted logs folder in HDFS]"; 
```
Параметр TERMINATED BY "\t" показывает нам, каким символом разделены данные между собой
LOCATION - указываем папку, которая содержит все интересующие нас данные

### Организация рекурсивного поиска

Для того, чтобы указанные в HDFS данные, имеющие вложенную структуру папок, были найдены hive, у него должны быть выставлены определенные глобальные параметры с помощью следующих команд:
```sh
%hive
SET mapred.input.dir.recursive=true;
SET hive.mapred.supports.subdirectories=true;
SET hive.supports.subdirectories=true;
```

## Старый сценарий

### Создание таблицы для данных Kyoto
```sh
%hive
CREATE TABLE IF NOT EXISTS Kyoto (duration DOUBLE, service STRING, Source_bytes INT, Destination_bytes INT, count INT, Same_srv_rate FLOAT, Serror_rate FLOAT, Srv_serror_rate FLOAT, Dst_host_count INT, Dst_host_srv_count INT, Dst_host_same_src_port_rate FLOAT, Dst_host_serror_rate FLOAT, Dst_host_srv_serror_rate FLOAT, Flag STRING, IDS_detection INT, Malware_detection INT, Ashula_detection STRING, Label INT, Source_IP_Address STRING, Source_Port_Number INT, Destination_IP_Address STRING, Destination_Port_Number INT, Start_Time STRING, Duration_session STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY \"\t\" STORED AS TEXTFILE; 
```

### Заполнение таблицы. Параметр OVERWRITE перезапишет все данные
```sh
%hive
LOAD DATA INPATH '/user/Kyoto2016/2006/11/20061101.txt' OVERWRITE INTO TABLE Kyoto;
```

### Просмотр всех данных из полученной таблицы. В Zeppelin можно настраивать получаемый график, нажав на settings и выставив там значения Keys, Values и, при необходимости, Group (который, как выяснилось, может выделять в данных подкатегории). Наглядно смотрятся графики:
```sh
Keys			Group		Values				Что показывает график?
service			-		destination_ip_address COUNT	Наиболее используемые протоколы
destination_ip_address	-		destination_bytes SUM		Траффик, переданный каждому клиенту
```

### Сама команда для параграфа, чтобы получить данные из таблицы
```sh
%hive
SELECT * FROM Kyoto;
```

### Каждую из вышеперечисленных команд так же можно запустить (на случай неработающего интерпретатора hive) через обвязку spark следующим образом (вместо "show tables" - любая команда для hive):
```sh
%spark
import org.apache.spark.sql.SparkSession;
val sparkSession = SparkSession.builder.master("spark://spark-master:7077").appName("spark session example").enableHiveSupport().getOrCreate()
sparkSession.sql("show tables").show()nano 
```

