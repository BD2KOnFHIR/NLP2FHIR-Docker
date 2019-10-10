@echo off
REM *****************************************************************
REM  Main script to build BD2KOnFHIR/NLP2FHIR.
REM  https://github.com/BD2KOnFHIR/NLP2FHIR
REM  This script will create a Docker container to pull and build the
REM  multiple software projects required and place them in a ./target
REM  diretory.
REM
REM  Requirement:  UMLS requires a user license.  As such, it is
REM  the responsibility of the user to manually download the UMLS and
REM  and SNOMEDCT_US.
REM
REM   - The MRCONSO.RRF file from a copy of the UMLS (placed in ./UMLS)
REM   - SNOMEDCT US Edition resource files (downloadable with a UMLS
REM     license, placed in ./SNOMEDCT_US)
REM
REM *****************************************************************

set "ROOT_DIR=%cd%"

REM *****************************************************************
REM  Environment Variables
REM *****************************************************************
set UMLS_VTS_BRANCH=master
set UMLS_VTS_REPO=https://github.com/OHNLPIR/UMLS_VTS.git
set UMLS_VTS_TAG=458ea9aa011d80422811619207e513224e3cb9d4

set MED_TAGGER_BRANCH=master
set MED_TAGGER_REPO=https://github.com/OHNLPIR/MedTagger.git
set MED_TAGGER_TAG=v1.0.3

set MED_TIME_BRANCH=master
set MED_TIME_REPO=https://github.com/OHNLPIR/MedTime.git
set MED_TIME_TAG=78b4e6f1dc756c340aaad6002c0d37dae57fc23c

set MED_XN_BRANCH=master
set MED_XN_REPO=https://github.com/ohnlp/MedXN.git
set MED_XN_TAG=9d178b32fc17426a7c92311a39907cb95a601e58

set NLP2FHIR_BRANCH=master
set NLP2FHIR_REPO=https://github.com/BD2KOnFHIR/NLP2FHIR.git
set NLP2FHIR_TAG=6521d5dfb0e6536d4c532a15ebafe3802797dd52

set UIMA_STREAM_SERVER_BRANCH=master
set UIMA_STREAM_SERVER_REPO=https://github.com/OHNLPIR/UIMA-Stream-Server.git
set UIMA_STREAM_SERVER_TAG=785a233c4b692633a9ed026cf0415849faa19341

REM *****************************************************************
REM  Output the variables being used
REM *****************************************************************
echo
echo "*** Environment Variables ***"
echo
echo UMLS_VTS_BRANCH : %UMLS_VTS_BRANCH%
echo UMLS_VTS_REPO   : %UMLS_VTS_REPO%
echo UMLS_VTS_TAG    : %UMLS_VTS_TAG%
echo
echo MED_TAGGER_BRANCH : %MED_TAGGER_BRANCH%
echo MED_TAGGER_REPO   : %MED_TAGGER_REPO%
echo MED_TAGGER_TAG    : %MED_TAGGER_TAG%
echo
echo MED_TIME_BRANCH : %MED_TIME_BRANCH%
echo MED_TIME_REPO   : %MED_TIME_REPO%
echo MED_TIME_TAG    : %MED_TIME_TAG%
echo
echo MED_XN_BRANCH : %MED_XN_BRANCH%
echo MED_XN_REPO   : %MED_XN_REPO%
echo MED_XN_TAG    : %MED_XN_TAG%
echo
echo UIMA_STREAM_SERVER_BRANCH: %UIMA_STREAM_SERVER_BRANCH%
echo UIMA_STREAM_SERVER_REPO  : %UIMA_STREAM_SERVER_REPO%
echo UIMA_STREAM_SERVER_TAG   : %UIMA_STREAM_SERVER_TAG%
echo
echo NLP2FHIR_BRANCH : %NLP2FHIR_BRANCH%
echo NLP2FHIR_REPO   : %NLP2FHIR_REPO%
echo NLP2FHIR_TAG    : %NLP2FHIR_TAG%
echo

REM *****************************************************************
REM  Verify that the ./UMLS and ./SNOMEDCT_US directories exist
REM  and are populated.
REM *****************************************************************
set FILE=""
set DIR_UMLS="UMLS"
set DIR_SNOMED="SNOMEDCT_US"


REM *****************************************************************
REM  look for empty ./UMLS dir
REM *****************************************************************

( dir /b /a "%DIR_UMLS%" | findstr . ) > nul && (
  echo %DIR_UMLS% non-empty
) || (
  echo %DIR_UMLS% empty
  echo The UMLS directory is Empty
  echo The MRCONSO.RRF file from a copy of the UMLS needs to be placed in the ./UMLS directory.
  goto :Exit
)


REM *****************************************************************
REM  look for empty ./SNOMEDCT_US dir
REM *****************************************************************

( dir /b /a "%DIR_SNOMED%" | findstr . ) > nul && (
  echo %DIR_SNOMED% non-empty
) || (
  echo %DIR_SNOMED% empty
  echo The SNOMEDCT_US directory is Empty
  echo "The SNOMEDCT US Edition resource files (downloadable with a UMLS license), need to be placed in the ./SNOMEDCT_US directory."
  goto :Exit
)


REM *****************************************************************
REM  Remove target directories and recreate them fresh.
REM *****************************************************************
echo creating clean artifact directory
echo %ROOT_DIR%\target
rd /s /q %ROOT_DIR%\target

REM *****************************************************************
REM  Create a maven container
REM *****************************************************************
FOR /F "delims=" %%A IN ('docker run -d -P --name maven -v ~\.m2:/root/.m2:rw ubuntu') do SET "MAVEN_CONTAINER=%%A"
echo MAVEN_CONTAINER= %MAVEN_CONTAINER%

REM *****************************************************************
REM  Artifact builder will build MedTagger, cTAKES, MedTime,
REM  MedXN, and UMLS_VTS
REM *****************************************************************
cd artifact-builder
REM ## docker run --rm ^
docker run --name artifactBuilder ^
  -e DIR_UMLS=%DIR_UMLS% -e DIR_SNOMED=%DIR_SNOMED% ^
  -e UMLS_VTS_BRANCH=%UMLS_VTS_BRANCH% -e UMLS_VTS_REPO=%UMLS_VTS_REPO% -e %UMLS_VTS_TAG=$UMLS_VTS_TAG% ^
  -e MED_TAGGER_BRANCH=%MED_TAGGER_BRANCH% -e MED_TAGGER_REPO=%MED_TAGGER_REPO% -e %MED_TAGGER_TAG=$MED_TAGGER_TAG% ^
  -e MED_TIME_BRANCH=%MED_TIME_BRANCH% -e MED_TIME_REPO=%MED_TIME_REPO% -e %MED_TIME_TAG=$MED_TIME_TAG% ^
  -e MED_XN_BRANCH=%MED_XN_BRANCH% -e MED_XN_REPO=%MED_XN_REPO% -e %MED_XN_TAG=$MED_XN_TAG% ^
  -e UIMA_STREAM_SERVER_BRANCH=%UIMA_STREAM_SERVER_BRANCH% -e UIMA_STREAM_SERVER_REPO=%UIMA_STREAM_SERVER_REPO% -e %UIMA_STREAM_SERVER_TAG=$UIMA_STREAM_SERVER_TAG% ^
  -e NLP2FHIR_BRANCH=%NLP2FHIR_BRANCH% -e NLP2FHIR_REPO=%NLP2FHIR_REPO% -e %NLP2FHIR_TAG=$NLP2FHIR_TAG% ^
  --volumes-from maven artifact-builder
REM ## --volumes-from maven endlecm/artifact-builder:1.0.1.SNAPSHOT
cd ..

echo Build complete, copying files to the target directory...
docker cp artifactBuilder:target/ target

REM Copy the UMLS and SNOMEDCT_US directories to the target directory.
echo "*************************************************************************"
echo "Copying the UMLS and SNOMEDCT_US directories to the target directory."
echo "*************************************************************************"
mkdir %ROOT_DIR%\target\%DIR_UMLS%
mkdir %ROOT_DIR%\target\%DIR_SNOMED%

Xcopy  %ROOT_DIR%\target\%DIR_UMLS%\* target\%DIR_UMLS%
Xcopy  %ROOT_DIR%\target\%DIR_SNOMED%\* target\%DIR_SNOMED%

REM *****************************************************************
REM  Remove maven container
REM *****************************************************************
docker stop %MAVEN_CONTAINER%
docker rm %MAVEN_CONTAINER%

#*****************************************************************
# Remove artifactBuilder container
#*****************************************************************
docker rm artifactBuilder

:Exit
echo END OF PROGRAM
