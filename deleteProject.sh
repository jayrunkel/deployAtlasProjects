#!/bin/bash

# Usage:
#
# Run script like: ./deleteProject.sh <projectName>
projectName=$1
profile=NE_ECAN_EAST_POCS
clusterName="${projectName}Cluster"

#deleteProject=$(mongocli iam project list  --profile NE_ECAN_EAST_POCS --output json | jq '.results | .[] | select(.name=="Team1A") | .id' | sed 's/\"//g')
deleteProject=$(mongocli iam project list  --profile $profile --output json | jq ".results | .[] | select(.name==\"$projectName\") | .id" | sed 's/\"//g')
mongocli atlas cluster delete $clusterName --projectId=$deleteProject --profile=$profile --force
mongocli atlas cluster watch $clusterName --projectId=$deleteProject --profile=$profile
mongocli iam project delete $deleteProject  --profile=$profile --force

