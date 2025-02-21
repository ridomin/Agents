#!/bin/bash

tunnel_id="ridomin-dev"
tunnel_details=$(devtunnel show $tunnel_id -j -v)
tunnelUrl=$(echo $tunnel_details | grep -oP '(?<=\[ ")[^"]+(?=" \])')
echo $tunnelUrl



