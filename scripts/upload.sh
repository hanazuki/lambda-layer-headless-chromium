#!/bin/bash

cd

if [[ -n ${S3_BUCKET:-} ]]; then
    aws s3 sync dist/ s3://${S3_BUCKET}/${CR_CHANNEL:-master}/
fi
