## validate the deployment without saving 
sfdx force:mdapi:deploy --targetusername aa-partial --checkonly --zipfile releases/Spring20v5.zip --testlevel RunLocalTests --wait=-1

## check status
## sfdx force:mdapi:deploy:report --jobid=0Af1p00001Q45KkCAJ

## Deploy and skip validation using quick deploy with job ID returned in the previous step
sfdx force:mdapi:deploy --targetusername aa-partial --validateddeployrequestid=0Af3E00000q1qRrSAI --wait=-1

## Cancel deployment
##sfdx force:mdapi:deploy:cancel -i 0Af1p00001Q45KkCAJ

