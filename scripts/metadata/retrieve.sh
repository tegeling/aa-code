## Retrieve the changes from the developer sandbox.
sfdx force:source:retrieve --manifest mdapi/package.xml

## Convert the source to metadata format
sfdx force:source:convert --rootdir force-app --outputdir mdapi

## Create a .zip file of the contents in the tmp_convert directory.
cd mdapi
rm aa-code.zip && zip -r aa-code.zip *

## Run the deploy command
## sfdx force:mdapi:deploy --zipfile mdapi/aa-code.zip --testlevel RunSpecifiedTests --runtests TestMyCode

## validate the deployment without saving 
sfdx force:mdapi:deploy --checkonly --zipfile aa-code.zip --testlevel RunLocalTests --wait=-1

## check status
sfdx force:mdapi:deploy:report --jobid=0Af5E00001BMXiqSAH


## Test the actual production deployment
sfdx force:mdapi:deploy --checkonly --zipfile mdapi_output/winter19.zip --targetusername full-sandbox --testlevel RunSpecifiedTests TestLanguageCourseTrigger

## test the quick deploy using the job ID returned in the previous step
sfdx force:mdapi:deploy --targetusername full-sandbox --validateddeployrequestid jobID

## convert your files from source format to metadata format
sfdx force:source:convert

## quick deploy using source
sfdx force:source:deploy --checkonly \
--sourcepath force-app --targetusername production-org \
--testlevel RunLocalTests

## quick deploy using mdapi
sfdx force:mdapi:deploy --checkonly \
--zipfile winter19.zip --targetusername production-org \
--testlevel RunLocalTests

## Run the quick deploy using source
sfdx force:source:deploy \
--targetusername production-org \
--validateddeployrequestid jobID

## run the quick deploy using mdapi
sfdx force:mdapi:deploy \
--targetusername production-org \
--validateddeployrequestid jobID

## Cancel deployment
sfdx force:mdapi:deploy:cancel -i <jobid>

