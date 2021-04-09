## validate the deployment without saving 
sfdx force:mdapi:deploy --targetusername aa-production --checkonly --zipfile releases/Winter21v16.zip --testlevel RunLocalTests

## check status
## sfdx force:mdapi:deploy:report --jobid=0Af0E00001oJiG0SAK

## Deploy and skip validation using quick deploy with job ID returned in the previous step
sfdx force:mdapi:deploy --targetusername aa-production --validateddeployrequestid=0Af0800001THIiBCAX

## Cancel deployment
##sfdx force:mdapi:deploy:cancel -i 0Af1p00001Q45KkCAJ

