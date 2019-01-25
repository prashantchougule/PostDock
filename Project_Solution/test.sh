#!/bin/bash
max=100
a=10
b=10
for i in `seq 1 $max`
do
if [ $a == $b ]
then
echo "delete the primary pod mysystem-db-node-0"
        kubectl delete pods mysystem-db-node-0
        sleep 450
        echo "print the status of repmgr cluster: $(kubectl get pod | grep db-node  | awk '{print $1}' | while read pod ; do echo "$pod": ; kubectl  exec $pod -- bash -c 'gosu postgres repmgr cluster show' ; done)"
        echo "attached node to pgpool:"
        kubectl exec mysystem-database-pgpool-c664cbd9c-mz5bm -- bash -c "pcp_attach_node -h localhost -U pcp_user -n 0 -w"
        kubectl exec mysystem-database-pgpool-c664cbd9c-zrq88 --  bash -c "pcp_attach_node -h localhost -U pcp_user -n 0 -w"
        sleep 10
        kubectl get pod | grep pgpool | awk '{print $1 }' | while read pod; do echo "$pod": ;kubectl exec $pod -- bash -c 'PGCONNECT_TIMEOUT=$CHECK_PGCONNECT_TIMEOUT  PGPASSWORD=$CHECK_PASSWORD psql -U $CHECK_USER -h 127.0.0.1 template1 -c "show pool_nodes"' ; done
        sleep 10
        echo "delete the primary pods mysystem-db-node-1"
        kubectl delete pods mysystem-db-node-1
        sleep 450
        echo "print the status of repmgr cluster: $(kubectl get pod | grep db-node  | awk '{print $1}' | while read pod ; do echo "$pod": ; kubectl  exec $pod -- bash -c 'gosu postgres repmgr cluster show' ; done)"
        echo "attached node to pgpool:"
        kubectl exec mysystem-database-pgpool-c664cbd9c-mz5bm -- bash -c "pcp_attach_node -h localhost -U pcp_user -n 1 -w"
        kubectl exec mysystem-database-pgpool-c664cbd9c-zrq88 --  bash -c "pcp_attach_node -h localhost -U pcp_user -n 1 -w"
        sleep 10
        kubectl get pod | grep pgpool | awk '{print $1 }' | while read pod; do echo "$pod": ;kubectl exec $pod -- bash -c 'PGCONNECT_TIMEOUT=$CHECK_PGCONNECT_TIMEOUT  PGPASSWORD=$CHECK_PASSWORD psql -U $CHECK_USER -h 127.0.0.1 template1 -c "show pool_nodes"' ; done
else
echo "nothing to do something has been wrong check the logs"
fi
done
