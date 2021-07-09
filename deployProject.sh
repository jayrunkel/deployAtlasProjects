#!/bin/bash

# Usage:
#
# Run script like: ./deployProject.sh <email> <firstName> <lastName> <teamName>
#
# - or -
#
# To process a list from a file:
#
#  xargs -n 4 ./deployProject.sh < file.txt


atlasUser=$1 #'jayrunkel3@gmail.com'
firstName=$2 #Jay
lastName=$3 #Runk
atlasProject=$4 #"Team1"

echo "Deploying Atlas project and cluster for:"
echo "[User] $atlasUser  [First] $firstName  [Last] $lastName  [Project] $atlasProject"


profile=NE_ECAN_EAST_POCS
awsRegion=US_EAST_1
mongoDBVersion=4.4
clusterName="${atlasProject}Cluster"
#orgId=5e384d56d5ec1312f4319e62
orgId=5cb4d399f2a30b7d0f8a928f

#create project
projectId=$(mongocli iam project create $atlasProject \
		     --profile=$profile \
		     --orgId=$orgId \
		     --output json | jq '.id' | sed "s/\"//g")
echo "Project $projectId created."

#delete project (maintenance only)
#set deleteProject (mongocli iam project list  --profile NE_ECAN_EAST_POCS --output json | jq '.results | .[] | select(.name=="Team1") | .id' | sed 's/\"//g')
#mongocli iam project delete $deleteProject  --profile NE_ECAN_EAST_POCS

#mongocli iam user invite
mongocli iam user invite \
	 --country=US \
	 --email=$atlasUser \
	 --username=$atlasUser \
	 --firstName=$firstName \
	 --lastName=$lastName \
	 --orgRole='5cb4d399f2a30b7d0f8a928f:ORG_MEMBER' \
	 --password=MongoDB_Rocks \
	 --profile=$profile \
	 --projectRole="$projectId:GROUP_DATA_ACCESS_ADMIN"

# Create db user for project
mongocli atlas dbuser create \
	 --username=$lastName \
	 --password="${firstName}Password" \
	 --projectId=$projectId \
	 --role=readWriteAnyDatabase \
	 --profile=$profile

# Deploy cluster
mongocli atlas cluster create $clusterName \
	 --backup=true\
	 --diskSizeGB=10  \
	 --mdbVersion=$mongoDBVersion \
	 --members=3 \
	 --projectId=$projectId \
         --provider=AWS \
	 --region=$awsRegion \
	 --tier=M10 \
         --type=REPLICASET \
         --profile=$profile

# Wait for deployment to be complete
mongocli atlas cluster watch $clusterName --projectId=$projectId --profile=$profile

# Get the connections string
mongocli atlas cluster connectionString get $clusterName --projectId=$projectId --profile=$profile


# # Delete the project and cluster
# mongocli atlas cluster delete $clusterName --projectId=$projectId --profile=$profile
# 
 
 
