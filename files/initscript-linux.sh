#!/bin/sh
# Managed by the puppet-pupistry module. If you are a distribution developer
# and have packaged Pupistry for your platform, let me know and we can stop
# injecting this bootscript.


### BEGIN INIT INFO
# Provides:          pupistry
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# chkconfig:         - 98 02
# Short-Description: Pupistry Daemon
# Description:       Runs a daemon for applying masterless Puppet configurations
### END INIT INFO

## BEGIN DEVELOPER'S RANT
#
# I hate writing sysvvinit files, the sooner we get systemd everywhere the
# better as far as I'm concerned. I based this sysvinit file off an example
# at https://github.com/fhd/init-script-template/blob/master/template to cater
# for older Linux distributions .

# It has to make use of some scary stuff like subshells and pipes in order to
# actually get log into syslog and still return the PID for managing the process.
#
# Better versions are welcome via pull request.
#
# END DEVELOPER'S RANT

PATH=$PATH:/usr/local/bin

dir="/tmp"
cmd_app="pupistry apply --daemon"
cmd_log="logger -s -t pupistry"

name=`basename $0`
pid_file="/var/run/$name.pid"

get_pid() {
    cat "$pid_file"
}

is_running() {
    [ -f "$pid_file" ] && ps `get_pid` > /dev/null 2>&1
}

case "$1" in
    start)
    if is_running; then
        echo "Already started"
    else
        echo "Starting $name"
        cd "$dir"
	( $cmd_app & echo $! > "$pid_file") 2>&1 | logger -t pupistry &
        echo "Running as PID `get_pid`"

	if ! is_running; then
            echo "Unable to start, see syslog for details"
            exit 1
        fi
    fi
    ;;
    stop)
    if is_running; then
        echo -n "Stopping $name.."
        kill `get_pid`
        for i in {1..10}
        do
            if ! is_running; then
                break
            fi

            echo -n "."
            sleep 1
        done
        echo

        if is_running; then
            echo "Not stopped; may still be shutting down or shutdown may have failed"
            exit 1
        else
            echo "Stopped"
            if [ -f "$pid_file" ]; then
                rm "$pid_file"
            fi
        fi
    else
        echo "Not running"
    fi
    ;;
    restart)
    $0 stop
    if is_running; then
        echo "Unable to stop, will not attempt to start"
        exit 1
    fi
    $0 start
    ;;
    status)
    if is_running; then
        echo "Running"
    else
        echo "Stopped"
        exit 1
    fi
    ;;
    *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac

exit 0
