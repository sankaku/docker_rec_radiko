#!/bin/sh

/usr/local/bin/run.sh $1 $2 $3

BUCKET=$BucketName
S3DIR=`date +%Y%m`

# send to S3
RECORDED=$WORKING_DIR/`ls -1t $WORKING_DIR | head -n 1`
S3="s3://$BUCKET/$S3DIR/"
echo "copying $RECORDED to $S3"
aws s3 cp --no-progress $RECORDED $S3
if [ $? -eq 0 ];then
  echo "Done"
else
  echo "Failed"
fi

