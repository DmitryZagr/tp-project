#!/bin/bash

function extract {
    if [ -z "$1" ]; then
        # display usage if no parameters given
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
        echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    else
        for n in $@
        do
        if [ -f "$n" ] ; then
            case "${n%,}" in
                *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                tar xvf "$n"       ;;
                *.lzma)      unlzma "$n"      ;;
                *.bz2)       bunzip2 "$n"     ;;
                *.rar)       unrar x -ad "$n" ;;
                *.gz)        gunzip "$n"      ;;
                *.zip)       unzip "$n"       ;;
                *.z)         uncompress "$n"  ;;
                *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                7z x ./"$n"        ;;
                *.xz)        unxz "$n"        ;;
                *.exe)       cabextract "$n"  ;;
                *)
                echo "extract: '$n' - unknown archive method"
                return 1
                ;;
            esac
        else
            echo "'$n' - file does not exist"
            return 1
        fi
    done
fi
}

abspath() {
    local thePath
    if [[ ! "$1" =~ ^/ ]];then
        thePath="$PWD/$1"
    else
        thePath="$1"
    fi
    echo "$thePath"|(
    IFS=/
    read -a parr
    declare -a outp
    for i in "${parr[@]}";do
        case "$i" in
            ''|.) continue ;;
            ..)
                len=${#outp[@]}
                if ((len==0));then
                    continue
                else
                    unset outp[$((len-1))]
                fi
                ;;
            *)
            len=${#outp[@]}
            outp[$len]="$i"
            ;;
        esac
    done
    echo /"${outp[*]}"
    )
}

help="Usage: just pass archive with a path for it to be loaded in HDFS as first argument."

#Logic of the script starts
#This command won't allow continue if an error occures during run
set -e

if [ $# -eq 0 ]
then
    echo "$help"
    exit 0
fi
DOCUMENT_PATH="$1"

#Prepare all the paths needed for work
truepath=$(abspath $DOCUMENT_PATH)
archivepath=`dirname "$truepath"`
archivename=`basename "$truepath"`
archivenamenoformat=${archivename%%.*}
wascurpath="$PWD"

#Go to archive directory
cd "$archivepath"

#Make special dir for unarchived data (named as the archive)
mkdir -p "$archivenamenoformat"
#Update paths to archive
oldtruepath="$truepath"
archivepath="$archivepath/$archivenamenoformat"
truepath="$archivepath/$archivename"
#Move archive to its new place
mv "$oldtruepath" "$truepath"

#Go to new archive directory
cd "$archivepath"

#echo "---$truepath---"

#Made extracting here
extract "$truepath"

#Get file type
echo ${archivename##*.}
#Get only name of the archive
echo ${archivename%%.*}

echo "$archivepath"
#echo $(find "$archivepath" -name '*.txt')

#Search for all .txt, .log and .csv files in extracted directory
array=()
while IFS=  read -r -d $'\0'; do
    array+=("$REPLY")
done < <(find "$archivepath" -name '*.txt' -print0 -o -name '*.csv' -print0 -o -name '*.log' -print0)

len=0
len=${#array[@]}
echo "Found : ${len}"

#Iterate over founded files
i=0
while [ $i -lt $len ]
do
    echo ${array[i++]}
done

#Go back to directory command have been called from
cd "$wascurpath"
