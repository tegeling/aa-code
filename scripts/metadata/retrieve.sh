## clean up files in mdapi
cd mdapi && rm aa-code.zip && rm -r aa-code && cd ..

## Retrieve the changes from the developer sandbox.
## sfdx force:source:retrieve --manifest mdapi/package.xml

## Convert the source to metadata format
sfdx force:source:convert --rootdir force-app --outputdir mdapi/aa-code

## Create a .zip file of the contents in the tmp_convert directory.
cd mdapi && zip -r aa-code.zip *

## validate the deployment without saving 
sfdx force:mdapi:deploy --checkonly --zipfile aa-code.zip --testlevel RunLocalTests --wait=-1

## check status
sfdx force:mdapi:deploy:report --jobid=0Af5E00001BNYjISAX

## Deploy and skip validation using quick deploy with job ID returned in the previous step
sfdx force:mdapi:deploy --targetusername aa-release --validateddeployrequestid=0Af5E00001BNYjISAX --wait=-1

## Cancel deployment
sfdx force:mdapi:deploy:cancel -i <jobid>

