#!/bin/bash

pid=`ps -aef | grep "Dsling.run.modes=publish" | grep -v grep | awk '{print $2}'`          # required
user=`ps -aef | grep "Dsling.run.modes=publish" | grep -v grep | awk '{print $1}'`          # required
date=`date +"%Y-%m-%d_%H-%M-%S"`
Thread_threshold=250     #Set according to your application trend
Current_thread_count=`top -H -b -n1 -p $pid | wc -l`
Dump_Archive="/opt/dump-archive"
ADMIN_EMAIL="EMAIL1, EMAIL2"

if [ $Current_thread_count -gt $Thread_threshold ]
then
  echo "Total Number of JAVA threads : $Current_thread_count" >>top.$pid
  echo -e '\n*****************************************************\n' >> top.$pid
  top -H -b -n1 -p $pid >>top.$pid
  /usr/bin/jstack -l $pid >Thread-dump.$pid
  mail -r thread-stats@domain.com -s "JAVA Thread Count is high on `hostname`" -a Thread-dump.$pid "${ADMIN_EMAIL}" < top.$pid
  mv top.$pid $Dump_Archive/top.$pid-$date
  mv Thread-dump.$pid $Dump_Archive/Thread-Dump.$pid-$date
fi
