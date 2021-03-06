#!/bin/bash
#
# Copyright O Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

# Importing useful functions for cc testing
if [ -f ./func.sh ]; then
 source ./func.sh
elif [ -f scripts/func.sh ]; then
 source scripts/func.sh
fi

echo_b "Channel name: "${APP_CHANNEL}

echo_b "Query the existing value of a"
chaincodeQuery ${APP_CHANNEL} 0 ${CC_02_NAME} ${CC_02_QUERY_ARGS} 100

sleep 1

echo_b "Invoke a transaction to transfer 10 from a to b"
chaincodeInvoke ${APP_CHANNEL} 0 ${CC_02_NAME} ${CC_02_INVOKE_ARGS}

sleep 1

echo_b "Check if the result of a is 90"
chaincodeQuery ${APP_CHANNEL} 0 ${CC_02_NAME} ${CC_02_QUERY_ARGS} 90

echo
echo_g "All GOOD, MVE Test completed"
echo
exit 0
