# Bash scripts

## NOTICE: this script versions load unarchived data to HDFS WITHOUT merging
## In hive you should use EXTERNAL tables, see examples in bro/scripts/init.sql

## Scripts to load data in HDFS:

### Internal script (runs in datanode's docker container)

Should be located in /bin/ of datanode's docker container

```sh
$ loadArchiveToHDFS [path to any format archive]
```
Script will extract files from archive and than put them at HDFS path: 
"/user/hive/rawlogs/[folder of the name of the archive]".
For example, we have archive 200611.zip.
Than we'll have extracted files at HDFS path:
/user/hive/rawlogs/200611

### Local machine script (runs out of docker container, but needs the container to be running)

Just call the script from 'archives' folder, that is located
in 'docker-spark-hive-zeppelin' folder

```sh
$ extractArchiveInHDFS
```

The script will read all the archives you've added to 'archives'
Then you'll be guided through some sort of interface to extract your archive and make it to be ready for Hadoop proccessing 