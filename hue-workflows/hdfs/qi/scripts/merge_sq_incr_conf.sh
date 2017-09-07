#! /bin/sh
tableName=$1
tablePrefix=$2
mergedFile=$1_$2
lastRun=$3
currentRun=$4
hdfs dfs -rm -f /user/clinicalinternal/tmp/sqoop/$mergedFile.merged.query

hdfs dfs -cat /user/clinicalinternal/projects/qi/conf/qi-qa.db.conf /user/clinicalinternal/projects/qi/sqoop/$tableName.incremental.query | sed -e "s/#TABLE_NAME#/$mergedFile/g" | sed -e "s/#LAST_RUN#/$lastRun/g" | sed -e "s/#CURRENT_RUN#/$currentRun/g" | hdfs dfs -put  -  /user/clinicalinternal/tmp/sqoop/$mergedFile.merged.query
