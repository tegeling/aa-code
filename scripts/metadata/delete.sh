## validate the deployment without saving 
sfdx force:mdapi:deploy --checkonly --deploydir mdapidestructive --testlevel RunLocalTests --wait=-1

## check status
## sfdx force:mdapi:deploy:report --jobid=0Af5E00001BPGJVSA5

## Deploy and skip validation using quick deploy with job ID returned in the previous step
sfdx force:mdapi:deploy --targetusername aa-release --validateddeployrequestid=0Af5E00001BPGMKSA5 --wait=-1

## Cancel deployment
##sfdx force:mdapi:deploy:cancel -i <jobid>

