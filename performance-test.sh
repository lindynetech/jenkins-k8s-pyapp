#!/bin/bash
# ENDPOINT=$1
NODE_IP=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="InternalIP")].address }')
NODE_PORT=$(kubectl get svc calculator-service -o=jsonpath='{.spec.ports[0].nodePort}')
ENDPOINT=${NODE_IP}:${NODE_PORT}
N=100

START=$(date +%s)
for i in $(seq ${N}); do
	echo "curl http://${ENDPOINT}"
	curl http://${ENDPOINT}/
done
END=$(date +%s)

RUNTIME=$((END-START))
AVG=$((RUNTIME/N))

# echo $RUNTIME
# echo $AVG

test ${AVG} -lt 1