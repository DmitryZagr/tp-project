
CREATE DATABASE IF NOT EXISTS BRO;

CREATE TABLE IF NOT EXISTS BRO.NOTICE (
                                        ts TIMESTAMP COMMENT 'Timstamp', uid STRING COMMENT 'Connection unique id',
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
                                        suppress_for INTERVAL COMMENT 'Length of time dupes should be suppressed',
                                        dropped BOOLEAN COMMENT 'If the src IP was blocked'
                                      )
ROW FORMAT DELIMITED FIELDS TERMINATED BY \"\t\" STORED AS TEXTFILE; 




CREATE TABLE IF NOT EXISTS BRO.CONN (duration DOUBLE, service STRING, Source_bytes INT,
								 Destination_bytes INT, count INT, Same_srv_rate FLOAT, Serror_rate FLOAT, 
								 Srv_serror_rate FLOAT, Dst_host_count INT, Dst_host_srv_count INT, 
								 Dst_host_same_src_port_rate FLOAT, Dst_host_serror_rate FLOAT, 
								 Dst_host_srv_serror_rate FLOAT, Flag STRING, IDS_detection INT, 
								 Malware_detection INT, Ashula_detection STRING, Label INT,
								 Source_IP_Address STRING, Source_Port_Number INT, 
							 	 Destination_IP_Address STRING, Destination_Port_Number INT, Start_Time STRING, 
								 Duration_session STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY \"\t\" STORED AS TEXTFILE; 