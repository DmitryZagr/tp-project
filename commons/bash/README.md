# Archive to HDFS extracters
This document describes how to load data to HDFS
##### NOTICE:
In hive you should use EXTERNAL tables and specify path to data in HDFS to work with, see examples here: 
https://github.com/DmitryZagr/tp-project/blob/master/bro/scripts/init.sql
## Scripts to load data in HDFS:
### Internal datanode's script
Located in '/bin/' of datanode's docker container
Can be started only from datanode's docker container
```sh
$ loadArchiveToHDFS [path to any format archive]
```
Script will extract files from archive and than put them at HDFS path: 
'/user/hive/rawlogs/[folder of the name of the archive]'
Path to extracted data in HDFS will be printed in the last line of script's output
### Local machine script
Located in 'docker-spark-hive-zeppelin/archives' folder
```sh
$ extractArchiveInHDFS
```
The script will read all the archives in its folder and will ask to select one to extract it in HDFS
Path to extracted data in HDFS will be printed in the last line of script's output