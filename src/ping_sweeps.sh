#!/bin/bash

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# assigns a hard code value for the default value for the base ip
DEFAULT_BASE_IP=192.168.1
# reads standard text and prompts user to enter a value for base_ip
read -p "Enter base ip address (default: $DEFAULT_BASE_IP): " base_ip
# sets user input to BASE_IP, otherwise use default value
BASE_IP=${base_ip:-$DEFAULT_BASE_IP}
# displays the value for BASE_IP
echo $BASE_IP

# assigns a file for the default file for the results
DEFAULT_RESULTS_FILE=$SCRIPT_PATH/../tmp/results.txt
# standard text asks user to enter a filename for result_filename
read -p "Enter results filename (default: $DEFAULT_RESULTS_FILE): " results_filename
# sets user input to RESULTS_FILE, otherwise use default value
RESULTS_FILE=${results_filename:-$DEFAULT_RESULTS_FILE}
# displays the text file stored in RESULTS_FILE
echo $RESULTS_FILE

# for loop to see which out of the 254 host are active
for i in {1..254}
do
  # sets PING_IP to value of BASE_IP and replace last octet with "i"
  PING_IP=$BASE_IP.$i

  # 'nohup' runs the process even after logging out from the shell/terminal
  # 'ping -c 1' attempts to ping the $PING_IP once
  # '| grep "bytes from"' will return something to STDOUT if ping was successful
  # '>> $RESULTS_FILE' will output results to text file
  # '&' runs as a background process so it launches all pings in parallel
  nohup ping -c 1 $PING_IP | grep "bytes from" >> $RESULTS_FILE &
done

echo ""
echo "Tailing results in '$RESULTS_FILE', enter 'ctrl+c' to exit."
echo ""
# 'tail -f' displays output as ping results are written to file
tail -f $RESULTS_FILE
