#!/bin/bash

# Define the target (hostname or IP)
TARGET="8.8.8.8"  # Change this to the desired IP or hostname
COUNT=5            # Number of pings to send in each check

while true; do
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Run ping and extract packet loss percentage
    PING_OUTPUT=$(ping -c $COUNT -W 2 $TARGET)
    PACKET_LOSS=$(echo "$PING_OUTPUT" | grep -oP '\d+(?=% packet loss)')
    
    # Get the average round-trip time (RTT)
    AVG_RTT=$(echo "$PING_OUTPUT" | grep -oP '(?<=rtt min/avg/max/mdev = )[^ ]+' | awk -F'/' '{print $2}')

    if [[ -z "$PACKET_LOSS" ]]; then
        echo "$TIMESTAMP - No response from $TARGET"
    else
        echo "$TIMESTAMP - Packet Loss: $PACKET_LOSS% | Avg RTT: ${AVG_RTT:-N/A} ms"
    fi

    sleep 1  # Adjust the delay if needed
done

