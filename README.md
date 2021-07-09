# Deploy Atlas Projects

This repository contains a bash script for using the mongocli to deploying a large number of Atlas projects and clusters as defined in a text file. The input text file has the following format:

```
user1@email.com user1FirstName user1LastName project1Name
user2@email.com user2FirstName user2LastName project2Name
user3@email.com user3FirstName user3LastName project3Name
user4@email.com user4FirstName user4LastName project4Name
```

See testDeploy.txt for an example.

For each line of the input file the script will:

1. Create a project with the name of the 4th argument
2. Create a user in the project with the user name of the 1st argument and send them an Atlas email invite to join the project. (Their initial password will be `MongoDB_Rocks`). The user is a member of the organization and data access admin on the project.
3. Create a DB user in the project with the name of the 3rd argument and the password "${secondArgument}Password"
4. Deploy a M10 cluster in the project with the name "${fourthArgument}Cluster"
5. Once the cluster has been deployed, the script will print the connection string to the cluster.

# Required Software

The following software components may need to be installed

* [mongocli](https://docs.mongodb.com/mongocli/stable/) - Scripts were developed using version 1.18
* [jq](https://stedolan.github.io/jq/)

These scripts also rely on bash, sed, and xargs.

# Installation

Installation steps:

1. Install jq (if necessary)
2. [Install mongocli](https://docs.mongodb.com/mongocli/stable/install/#std-label-mcli-install) (if necessary)
3. [Configure mongocli](https://docs.mongodb.com/mongocli/stable/configure/) - Note, you will need to have the Organization Owner role for your Atlas organization, create an organization level Atlas API key, and possibly configure the access lists.
4. [Update mongocli configuration file](https://docs.mongodb.com/mongocli/stable/configure/configuration-file/#std-label-mcli-config-file) - Create (or use default) a section in the mongocli.toml file to define the profile for the organization into which all the projects and users
5. Set the appropriate values for the 4 variables at the top of the deployProject.sh script
  
  * profile - The name of the mongocli profile created in Step 4.
  * awsRegion - The AWS region into which the MongoDB clusters should be deployed
  * mongoDBVersion - The MongoDB version to be deployed
  * orgId - The id of the Atlas org into which the clusters and projects should be deployed


# Execution

To deploy a single project and cluster, execute the script like:

```./deployProject.sh user2@email.com user2FirstName user2LastName project2Name```

To process a file containing a set of project definitions use xargs like:

```xargs -n 4 ./deployProject.sh < testDeploy.txt```


