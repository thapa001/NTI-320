#!bin/bash
status=$(ps aux | grep -c "")  # c means count # Change the status to test different alert states

if [ $status -le "100" ]; then
    echo "STATUS:OK"
    exit 0;

  elif [ $status -ge "150" ]; then
    echo "STATUS:CRITICAL"
    exit 2;

  elif [ $status -ge "101" ] ; then
    echo "STATUS:WARNING"
    exit 1;

else
   echo "STATUS:UNKNOWN"
   exit 3;
fi
