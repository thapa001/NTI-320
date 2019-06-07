#!/bin/bash
status=$(apachectl configtest 2>&1)
status2=$(apachectl)

if [ "$status" == "Syntax OK"   ]; then
    echo "STATUS:OK"
    exit 0;

  elif [ "status" != "Syntax OK"  ]; then
    echo "STATUS:Critical"
    exit 2;

  elif [ "status2" != "Syntax Ok"  ] ; then
    echo "STATUS:Warning"
    exit 1;

else
   echo "STATUS:Unknown"
   exit 3;
fi
