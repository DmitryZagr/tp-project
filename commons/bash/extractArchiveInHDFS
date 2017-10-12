#!/bin/bash

set -e

# archivepath="/hadoop/dfs/data/Archives/"
archivepath="/root/hadoop_data/"

# echo "Enter archive name: "
# read archivename

dockerinfo="$(docker ps -f name=datanode)"
datanodeinfo=${dockerinfo##*$'\n'}
datanodeid=${datanodeinfo%%$' '*}

array=()
while IFS=  read -r -d $'\0'; do
	case "${REPLY##*.}" in
                *tar.bz2|*tar.gz|*tar.xz|*tbz2|*tgz|*txz|*tar)
                array+=("$REPLY");;
                *lzma)      array+=("$REPLY");;
                *bz2)       array+=("$REPLY");;
                *rar)       array+=("$REPLY");;
                *gz)        array+=("$REPLY");;
                *zip)       array+=("$REPLY");;
                *z)         array+=("$REPLY");;
                *7z|*arj|*cab|*chm|*deb|*dmg|*iso|*lzh|*msi|*rpm|*udf|*wim|*xar)
                array+=("$REPLY");;
                *xz)        array+=("$REPLY");;
                *exe)       array+=("$REPLY");;
                *)
                ;;
            esac
done < <(docker exec -it $datanodeid find $archivepath -print0)

len=0
len=${#array[@]}

i=0

if [ $i -lt $len ]
then
	# clear the screen
	tput clear

	# Move cursor to screen location X,Y (top left is 0,0)
	tput cup 3 15

	# Set a foreground colour using ANSI escape
	tput setaf 3
	echo "Archive to HDFS extracter"
	tput sgr0

	while [ $i -lt $len ]
	do
		filepath=${array[i]}
		tput sgr0
 
 		offset=$((5+$i*2))
		tput cup $offset 15
	    echo "$((i+1)). ${filepath##*/}"

	    i=$(($i+1))
	done

	offset=$((5+$i*2))
	# Set bold mode
	tput bold
	tput cup $offset 15
	read -p "Enter your choice [1-$i] " choice
	 
	nointeger=1

	if [[ "$choice" =~ ^[0-9]+$ ]]
    then
    	if ((choice <= i && choice >= 1))
    	then
    		nointeger=0;
	    fi
	fi

	while [ $nointeger -eq 1 ] ; do
		# [$choice -le $i] && [$choice -ge 1]
		# position=$(($position+1))
		offset=$((5+$i*2))
		tput cup $(($offset-1)) 15
	    echo "Please, enter correct number!"
	    # tput cup $offset 0
	    # printf "%${COLUMNS}s" ""
	    tput cup $offset 15
	    read -p "Enter your choice again [1-$i] " choice
	    if [[ "$choice" =~ ^[0-9]+$ ]]
	    then
	    	if ((choice <= i && choice >= 1))
	    	then
	    		nointeger=0;
		    fi
		fi
	done
	# fi
	# tput clear
	tput sgr0
	# tput rc

	offset=$((7+$i*2))
	tput cup $offset 15

	docker exec -it $datanodeid /bin/loadArchiveToHDFS ${array[$(($choice-1))]}

fi

# docker exec -it datanodeid /bin/loadArchiveToHDFS $archivepath$archivename
