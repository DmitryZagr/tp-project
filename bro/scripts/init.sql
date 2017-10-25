
-- EXTERNAL allows us not to copy data in hive location
-- Location should be defined (path to extracted data in HDFS)
-- Here is a template of how to create table using raw logs in HDFS:

CREATE EXTERNAL TABLE IF NOT EXISTS [TABLE_NAME] (
     [column_name] [data_type] COMMENT '[comment]'
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t" 
-- in your logs fields may be delimeted by \t or , or |. It should be known from log file
STORED AS TEXTFILE 
LOCATION "[path to extracted logs folder in HDFS]";

-- This command should be executed for ANY table using external HDFS data,
-- because log files could be located in subdirectories
-- WITHOUT this command hive WON'T search for logs in subdirectories

alter table [TABLE_NAME] set tblproperties ("hive.input.dir.recursive" = "TRUE",
     "hive.mapred.supports.subdirectories" = "TRUE",
     "hive.supports.subdirectories" = "TRUE",
     "mapred.input.dir.recursive" = "TRUE"
)

-- Here you can see example of tables structers for Bro log format:
-- (location paths are written for example)

CREATE DATABASE IF NOT EXISTS BRO;

CREATE EXTERNAL TABLE IF NOT EXISTS BRO.NOTICE (
                                        ts BIGINT COMMENT 'Timstamp', 
                                        uid STRING COMMENT 'Connection unique id',
                                        id_orig_h STRING COMMENT 'Originating endpoint’s IP address (AKA ORIG)',
                                        id_orig_p INT COMMENT 'Originating endpoint’s TCP/UDP port (or ICMP code)',
                                        id_resp_h STRING COMMENT 'Responding endpoint’s IP address (AKA RESP)',
                                        id_resp_p INT COMMENT 'Responding endpoint’s TCP/UDP port (or ICMP code)',
                                        fuid STRING COMMENT 'File unique identifier',
                                        file_mime_type STRING COMMENT 'Libmagic sniffed file type',
                                        file_desc STRING COMMENT 'Additional context for file, if available',
                                        proto STRING COMMENT 'Transport protocol',
                                        note STRING COMMENT 'The type of the notice',
                                        msg STRING COMMENT 'Human readable message for the notice',
                                        sub STRING COMMENT 'Sub-message for the notice',
                                        src STRING COMMENT 'Source address',
                                        dst STRING COMMENT 'Destination address',
                                        p INT COMMENT 'Associated port, if any',
                                        peer_descr STRING COMMENT 'Description for peer that raised this notice',
                                        actions STRING COMMENT 'Actions applied to this notice',
                                        suppress_for BIGINT COMMENT 'Length of time dupes should be suppressed',
                                        dropped STRING COMMENT 'If the src IP was blocked'
                                      )
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t" STORED AS TEXTFILE LOCATION "/user/hive/rawlogs/notice"

CREATE EXTERNAL TABLE IF NOT EXISTS BRO.CONNECTION (
                                        ts DOUBLE COMMENT 'Timstamp', ---TODO: fix timestamp type
                                        uid STRING COMMENT 'Unique ID of Connection',
                                        id_orig_h STRING COMMENT 'Originating endpoint’s IP address (AKA ORIG)',
                                        id_orig_p INT COMMENT 'Originating endpoint’s TCP/UDP port (or ICMP code)',
                                        id_resp_h STRING COMMENT 'Responding endpoint’s IP address (AKA RESP)',
                                        id_resp_p INT COMMENT 'Responding endpoint’s TCP/UDP port (or ICMP code)',
                                        proto STRING COMMENT 'Transport layer protocol of connection',
                                        service STRING COMMENT 'Dynamically detected application protocol, if any',
                                        duration DOUBLE COMMENT 'Time of last packet seen – time of first packet seen',
                                        orig_bytes INT COMMENT 'Originator payload bytes; from sequence numbers if TCP',
                                        resp_bytes INT COMMENT 'Responder payload bytes; from sequence numbers if TCP',
                                        conn_state STRING COMMENT 'Connection state (see conn.log:conn_state table)', ---all clear
                                        local_orig STRING COMMENT 'If conn originated locally T; if remotely F. If Site::local_nets empty, always unset.', ---unknown
                                        missed_bytes INT COMMENT 'Number of missing bytes in content gaps',
                                        history STRING COMMENT 'Connection state history (see conn.log:history table)',
                                        orig_pkts INT COMMENT 'Number of ORIG packets',
                                        orig_ip_bytes INT COMMENT 'Number of ORIG IP bytes (via IP total_length header field)',
                                        resp_pkts INT COMMENT 'Number of RESP packets',
                                        resp_ip_bytes INT COMMENT 'Number of RESP IP bytes (via IP total_length header field)',
                                        tunnel_parents STRING COMMENT 'If tunneled, connection UID of encapsulating parent (s)',
                                        orig_cc STRING COMMENT 'ORIG GeoIP Country Code',
                                        resp_cc STRING COMMENT 'RESP GeoIP Country Code'
                                      )
ROW FORMAT DELIMITED FIELDS TERMINATED BY "\t" STORED AS TEXTFILE LOCATION "/user/hive/rawlogs/conn" 