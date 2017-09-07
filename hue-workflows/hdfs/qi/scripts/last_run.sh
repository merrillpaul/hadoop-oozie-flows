#! /bin/sh
echo lastRunTime=`hdfs dfs -tail /user/clinicalinternal/tmp/run_times/$1.log | shuf -n 1`