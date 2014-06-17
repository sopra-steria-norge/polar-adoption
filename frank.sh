#!/usr/bin/env bash
set -e

cd `dirname $0`

info() { echo -e "\033[1;32m:) $1\033[0m"; }
warn() { echo -e "\033[1;33m:| $1\033[0m"; }
fail() {
	echo -e "\033[1;31m:( $1\033[0m";
	exit 1
}

if [ ! $# -eq 1 ]; then
	info "Bruk: ./frank.sh [start|stop|status|restart]"
	exit 1
fi

cmd=$1
if [[ $cmd != "start" && $cmd != "stop" && $cmd != "status" && $cmd != "restart" ]]; then
	fail "Kjenner ikke kommandoen '$cmd'. mente du 'start' eller 'stop'?"
fi

_start() {
	pidfile=pid
	if [ ! -f $pidfile ]; then
		nohup java -jar current/frank.jar current/frank.war 2>> logs/error.log >> logs/server.log &
		PID=$!
		echo $PID > /home/anders/frankapp/pid
		info "Startet app med PID $PID"
	else
      warn "Kjører allerede"
    fi
}

_stop() {
	pidfile=pid
	if [ -f $pidfile ]; then
		PID=`cat $pidfile`
		kill $PID || warn "PID $PID eksisterer ikke, sletter $pidfile ..."
		rm $pidfile
		info "Stoppet app med PID $PID"
	else
		warn "Fant ikke PID-fil. Ser ikke ut til at appen kjører."
	fi
}

if [ $cmd = "status" ]; then
	pidfile=pid
	if [ -f $pidfile ]; then
		pid=`cat $pidfile`
		info "Kjører (med PID $pid)"
	else
		warn "Det ser ikke ut til at appen kjører"
	fi
fi

if [ $cmd = "start" ]; then
	_start
fi

if [ $cmd = "stop" ]; then
	_stop
fi

if [ $cmd = "restart" ]; then
	_stop
	sleep 2
	_start
fi
