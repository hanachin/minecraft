#!/bin/sh
# /etc/init.d/mc_twitter_bot
# version 0.1.0 2016-08-12 (YYYY-MM-DD)
#
### BEGIN INIT INFO
# Provides:       mc_twitter_bot
# Required-Start: $local_fs $network $remote_fs
# Required-Stop:  $local_fs $network $remote_fs
# Default-Start:  2 3 4 5
# Default-Stop:   0 1 6
# Short-Description: start mc twitter bot
# Description: mc twitter bot @hanachin_mc
### END INIT INFO

. /etc/rc.d/init.d/functions

prog="mc_twitter_bot"
user="mc"
pidfile="/home/mc/$prog.pid"
lockfile="/var/lock/subsys/$prog"
exec="/home/mc/$prog"

start() {
  daemon --check $prog --pidfile $pidfile --user $user $exec
  retval=$?
  [ $retval -eq 0 ] && touch $lockfile
  return $retval
}

stop() {
  killproc -p $pidfile $exec
  retval=$?
  [ $retval -eq 0 ] && rm -f $lockfile
  return $retval
}

restart() {
  stop
  start
}

case "$1" in
  start)
    echo -n "Starting $prog"
    start
    retval=$?
    echo
    ;;
  stop)
    echo -n "Shutting down $prog"
    stop
    retval=$?
    echo
    ;;
  status)
    status -p $pidfile -l $prog $exec
    retval=$?
    ;;
  restart)
    restart
    retval=$?
    ;;
  *)
    echo $"Usage: mc_twitter_bot (start|stop|status|restart)"
    retval=2
    ;;
esac

exit $retval
