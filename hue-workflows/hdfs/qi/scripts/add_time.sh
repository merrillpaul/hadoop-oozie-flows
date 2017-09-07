#! /bin/sh
echo $1 | hdfs dfs -appendToFile - /user/clinicalinternal/tmp/run_times/$2.log