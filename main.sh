STACK_NAME="dynamodb-export-to-s3-and-query-with-athena-playground-v2"

MY_TABLE_ARN=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query "Stacks[0].Outputs[?OutputKey=='MyTableArn'].OutputValue" --output text)
EXPORT_BUCKET_NAME=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --query "Stacks[0].Outputs[?OutputKey=='ExportBucketName'].OutputValue" --output text)
CURRENT_EPOCH_TIME=$(date +%s)
SECONDS_IN_MINUTES=60
SECONDS_IN_HOUR=$(($SECONDS_IN_MINUTES * 60))
SECONDS_IN_DAY=$(($SECONDS_IN_HOUR * 24))
ONE_DAY_AGO_EPOCH_TIME=$(($CURRENT_EPOCH_TIME - $SECONDS_IN_DAY))

EXPORT_TIME="${CURRENT_EPOCH_TIME}"
S3_PREFIX="demo_prefix"

echo -n "MY_TABLE_ARN: ${MY_TABLE_ARN}\nEXPORT_BUCKET_NAME: ${EXPORT_BUCKET_NAME}\nEXPORT_TIME: ${EXPORT_TIME}\n"

aws dynamodb export-table-to-point-in-time \
    --table-arn "${MY_TABLE_ARN}" \
    --s3-bucket "${EXPORT_BUCKET_NAME}" \
    --export-time $EXPORT_TIME \
    --s3-prefix "${S3_PREFIX}" \
    --export-format DYNAMODB_JSON

aws dynamodb list-exports
