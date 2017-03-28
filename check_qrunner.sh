#! /bin/bash

# check_qrunner.sh: Nagios plugin that alerts if any mailman qrunner isn't active
#
# ashish@mozilla.com 
#
# v1.0
# - Initial release

check_runners() {
    code=0
    PROCS=$(/bin/mktemp)
    ps -eo cmd | grep qrunner > $PROCS

    for runner in ArchRunner BounceRunner CommandRunner IncomingRunner NewsRunner OutgoingRunner VirginRunner RetryRunner;
    do
        if [ $(grep -c $runner $PROCS) -eq 0 ];
        then
            message="$message $runner"
            code=2
        fi
   done

    rm -f $PROCS
}

check_runners
   
if [ $code -ne 0 ]
then
    echo "CRITICAL:$message aren't running"
else
    echo "OK: All qrunners active"
fi

exit $code
