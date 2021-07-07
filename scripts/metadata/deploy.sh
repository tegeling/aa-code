## validate the deployment without saving 
sfdx force:mdapi:deploy --verbose --soapdeploy --targetusername=aa-production --checkonly --zipfile releases/Summer21v1.zip --testlevel RunLocalTests --wait=-1

## check status
## sfdx force:mdapi:deploy:report --jobid=0Af0E00001oJiG0SAK

## Deploy and skip validation using quick deploy with job ID returned in the previous step
sfdx force:mdapi:deploy --verbose --soapdeploy --targetusername=aa-production --validateddeployrequestid=0Af0800001UJX0yCAH --wait=-1

## Cancel deployment
##sfdx force:mdapi:deploy:cancel -i 0Af1p00001Q45KkCAJ

