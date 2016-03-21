#!/bin/sh
# ID of the volume
VOL_ID=$1
# Logical service name
DESC=$2
#How many last snapshot should be preserver
LAST_FOR=$3

if [ -z "$LAST_FOR" ]
then
	LAST_FOR=7
fi
#date in format , to append date in Description
d=`date +%F`

echo " Creating  snapshot for Volume Id $VOL_ID,  $DESC"
aws ec2 create-snapshot --description "$DESC-$d" --volume-id $VOLUME_ID
echo "Snapshot created for $VOLUME_ID $SERVICE_NAME with description $SERVICE_NAME $d"
aws ec2 describe-snapshots --filters Name=volume-id,Values=$VOL_ID > describerSnapshot.json
totalSnapshot=`jq '.[] | length' describerSnapshot.json`
echo "Total Snapshot available $totalSnapshot"
if [ "$totalSnapshot" -gt "$LAST_FOR" ];
then
	diff=`expr $totalSnapshot - $LAST_FOR`
	echo "Snapshot to be deleted $diff"
	i=0
	while [ $i -lt $diff ]
	do	
		snapshotID=`jq .Snapshots[$i].SnapshotId describerSnapshot.json |   tr -d '"'`
		echo "Deleteing snapshot with ID $snapshotID "
		aws ec2 delete-snapshot --snapshot-id $snapshotID
		i=`expr $i + 1`
	done	
fi
