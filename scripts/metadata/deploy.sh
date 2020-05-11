## validate the deployment without saving 
sfdx force:mdapi:deploy --targetusername aa-production --checkonly --zipfile releases/Spring20v1.zip --testlevel RunLocalTests --wait=-1

## check status
## sfdx force:mdapi:deploy:report --jobid=0Af1p00001Q3yyTCAR

## Deploy and skip validation using quick deploy with job ID returned in the previous step
sfdx force:mdapi:deploy --targetusername aa-production --validateddeployrequestid=0Af1p00001Q3yyTCAR --wait=-1

## Cancel deployment
##sfdx force:mdapi:deploy:cancel -i 0Af1p00001Q3yyTCAR

