# Bash scripts

## Scripts to load data in HDFS:

### Internal script (runs in datanode's docker container)

```sh
$ loadArchiveToHDFS [path to any format archive]
```
Script will create merged file with the content of the archive at HDFS path: 
"/user/hive/rawlogs".
Supports .txt, .log and .csv files to be in the archives.
File will be named as the archive and will be of its content format.
For example, we have archive 200611.zip and it contains files of .txt format.
Than we'll have a file in HDFS named 200611.txt.

SHOULD BE PLACED IN /bin/ !!! (in datanode's docker container)

### Local machine script (runs out of docker container, but needs the container to be running)

Just call the script from its folder:

```sh
$ extractArchiveInHDFS
```
Then you'll be guided through some sort of interface to extract your archive and make it to be ready for Hadoop proccessing 