#!/usr/bin/env bash

# exit when any command fails
# set -e

# Treat src as read only
# Copy src content to tmp
# Check for archives and extract those

BASE_PATH="/project"
TMP_PATH="$BASE_PATH/tmp"
SRC_PATH="$BASE_PATH/src"
REPORTS_PATH="$BASE_PATH/reports"
DECOMPLIED_PATH="$BASE_PATH/decompiled"

cp -r "$SRC_PATH/"* "$TMP_PATH"
cd $TMP_PATH


function extract_files(){

    P=$(pwd)
    for file in $(find $P -name "*.rpm"); do rpm2cpio ${file} | cpio -idmv -D "${file}.src" && rm -rf ${file}; done
    for file in $(find $P -name "*.deb"); do dpkg -x ${file} "${file}.src" && rm -rf ${file}; done
    for file in $(find $P -name "*.tar.bz2"); do mkdir "${file}.src"; tar xjf ${file} -C "${file}.src" && rm -rf ${file}; done
    for file in $(find $P -name "*.tar.gz"); do mkdir "${file}.src"; tar xzf ${file} -C "${file}.src" && rm -rf ${file}; done
    for file in $(find $P -name "*.tar.xz"); do mkdir "${file}.src"; tar xf ${file} -C "${file}.src" && rm -rf ${file}; done
    for file in $(find $P -name "*.bz2"); do mkdir -p "${file}.src"; mv ${file} ${file}.src; cd "${file}.src"; bzip2 -d $(basename ${file}); cd $TMP_PATH; done
    for file in $(find $P -name "*.rar"); do mkdir "${file}.src"; unrar -x ${file} "${file}.src" && rm -rf ${file}; done
    for file in $(find $P -name "*.gz"); do mkdir -p "${file}.src"; mv ${file} ${file}.src; cd "${file}.src"; gunzip $(basename ${file}); cd $TMP_PATH; done
    for file in $(find $P -name "*.tar"); do mkdir "${file}.src"; tar xf ${file} -C "${file}.src" && rm -rf ${file}; done
    for file in $(find $P -name "*.tbz2"); do mkdir "${file}.src"; tar xjf ${file} -C "${file}.src" && rm -rf ${file}; done
    for file in $(find $P -name "*.tgz"); do mkdir "${file}.src"; tar xzf ${file} -C "${file}.src" && rm -rf ${file}; done
    for file in $(find $P -name "*.zip"); do unzip ${file} -d "${file}.src" && rm -rf ${file}; done
    for file in $(find $P -name "*.7z"); do mkdir "${file}.src"; 7z x ${file} -o"${file}.src" && rm -rf ${file}; done
}

function findsecbugs(){
    # $1 extensions, like *.war
    # $2 report name, like war-report.htm

    cd $TMP_PATH
    files=$(find $PWD -name "$1" | tr "\n" " ")
    if [ ! -z "$files" ]; then
        findsecbugs.sh -progress -html -output "$REPORTS_PATH/$2" $files
    fi
}

function findAllSecbugs(){
    findsecbugs "*.war" "war-report.html"
    findsecbugs "*.jar" "jar-report.html"
    findsecbugs "*.class" "class-report.html"
    findsecbugs "*.js" "js-report.html"
}

function decompile(){
    cd $TMP_PATH
    for war in $(find $PWD -name "*.war"); do jd-cli -n -od "$war.src" $war; rm -rf $war; done
    for jar in $(find $PWD -name "*.jar"); do jd-cli -n -od "$jar.src" $jar; rm -rf $jar; done
}

function main(){

    for (( i = 0; i <= 5; i++ )); do
        extract_files
    done

    findAllSecbugs

    decompile
    
    mv "$TMP_PATH/"* "$DECOMPLIED_PATH/".

    chown -R $USERID:$USERID "$DECOMPLIED_PATH/"
    chown -R $USERID:$USERID "$REPORTS_PATH/"

    /bin/bash
}
main

