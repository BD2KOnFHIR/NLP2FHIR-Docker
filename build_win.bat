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

set MED_TAGGER_BRANCH=master
set MED_TAGGER_REPO=https://github.com/OHNLPIR/MedTagger.git

set MED_TIME_BRANCH=master
set MED_TIME_REPO=https://github.com/OHNLPIR/MedTime.git

set MED_XN_BRANCH=master
set MED_XN_REPO=https://github.com/ohnlp/MedXN.git

set NLP2FHIR_BRANCH=master
set NLP2FHIR_REPO=https://github.com/BD2KOnFHIR/NLP2FHIR.git

set UIMA_STREAM_SERVER_BRANCH=master
set UIMA_STREAM_SERVER_REPO=https://github.com/OHNLPIR/UIMA-Stream-Server.git

REM *****************************************************************
REM  Output the variables being used
REM *****************************************************************
echo
echo "*** Environment Variables ***"
echo
echo UMLS_VTS_BRANCH : %UMLS_VTS_BRANCH%
echo UMLS_VTS_REPO   : %UMLS_VTS_REPO%
echo
echo MED_TAGGER_BRANCH : %MED_TAGGER_BRANCH%
echo MED_TAGGER_REPO   : %MED_TAGGER_REPO%
echo
echo MED_TIME_BRANCH : %MED_TIME_BRANCH%
echo MED_TIME_REPO   : %MED_TIME_REPO%
echo
echo MED_XN_BRANCH : %MED_XN_BRANCH%
echo MED_XN_REPO   : %MED_XN_REPO%
echo
echo UIMA_STREAM_SERVER_BRANCH: %UIMA_STREAM_SERVER_BRANCH%
echo UIMA_STREAM_SERVER_REPO  : %UIMA_STREAM_SERVER_REPO%
echo
echo NLP2FHIR_BRANCH : %NLP2FHIR_BRANCH%
echo NLP2FHIR_REPO   : %NLP2FHIR_REPO%
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
rd /s /q %ROOT_DIR%\target

mkdir %ROOT_DIR%\target
mkdir %ROOT_DIR%\target\%DIR_UMLS%
mkdir %ROOT_DIR%\target\%DIR_SNOMED%
mkdir %ROOT_DIR%\target\artifacts
mkdir %ROOT_DIR%\target\artifacts\lib
mkdir %ROOT_DIR%\target\artifacts\resources


#*****************************************************************
# Create a maven container
#*****************************************************************
set MAVEN_CONTAINER=(docker run -d -P --name maven -v ~\.m2:\root\.m2:rw ubuntu)


#*****************************************************************
# Remove maven container
#*****************************************************************
docker stop $MAVEN_CONTAINER
docker rm $MAVEN_CONTAINER
:Exit
echo END OF PROGRAM
