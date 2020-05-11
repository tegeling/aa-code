## validate the deployment without saving 
sfdx force:mdapi:deploy --checkonly --deploydir mdapidestructive --testlevel RunLocalTests --wait=-1

## check status
## sfdx force:mdapi:deploy:report --jobid=0Af1p00001Q3z3sCAB

## Deploy and skip validation using quick deploy with job ID returned in the previous step
sfdx force:mdapi:deploy --targetusername aa-production --validateddeployrequestid=0Af1p00001Q3z3sCAB --wait=-1

## Cancel deployment
##sfdx force:mdapi:deploy:cancel -i <jobid>

