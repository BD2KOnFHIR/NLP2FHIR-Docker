#!/bin/bash

#*****************************************************************
# Main script to build BD2KOnFHIR/NLP2FHIR.
# https://github.com/BD2KOnFHIR/NLP2FHIR
# This script will create a Docker container to pull and build the
# multiple software projects required and place them in a ./target
# diretory.
#
# Requirement:  UMLS requires a user license.  As such, it is
# the responsibility of the user to manually download the UMLS and
# and SNOMEDCT_US.
#
#  - The MRCONSO.RRF file from a copy of the UMLS (placed in ./UMLS)
#  - SNOMEDCT US Edition resource files (downloadable with a UMLS
#    license, placed in ./SNOMEDCT_US)
#
#*****************************************************************

ROOT_DIR=$(pwd)

# Environment Variables
UMLS_VTS_BRANCH=master
UMLS_VTS_REPO=https://github.com/OHNLPIR/UMLS_VTS.git
UMLS_VTS_TAG=458ea9aa011d80422811619207e513224e3cb9d4

MED_TAGGER_BRANCH=master
MED_TAGGER_REPO=https://github.com/OHNLPIR/MedTagger.git
MED_TAGGER_TAG=v1.0.3

MED_TIME_BRANCH=master
MED_TIME_REPO=https://github.com/OHNLPIR/MedTime.git
MED_TIME_TAG=78b4e6f1dc756c340aaad6002c0d37dae57fc23c

MED_XN_BRANCH=master
MED_XN_REPO=https://github.com/ohnlp/MedXN.git
MED_XN_TAG=9d178b32fc17426a7c92311a39907cb95a601e58

NLP2FHIR_BRANCH=master
NLP2FHIR_REPO=https://github.com/BD2KOnFHIR/NLP2FHIR.git
NLP2FHIR_TAG=6521d5dfb0e6536d4c532a15ebafe3802797dd52

UIMA_STREAM_SERVER_BRANCH=master
UIMA_STREAM_SERVER_REPO=https://github.com/OHNLPIR/UIMA-Stream-Server.git
UIMA_STREAM_SERVER_TAG=785a233c4b692633a9ed026cf0415849faa19341

#*****************************************************************
# Output the variables being used
#*****************************************************************
echo
echo "*** Environment Variables ***"
echo
echo UMLS_VTS_BRANCH : $UMLS_VTS_BRANCH
echo UMLS_VTS_REPO   : $UMLS_VTS_REPO
echo UMLS_VTS_TAG    : $UMLS_VTS_TAG
echo
echo MED_TAGGER_BRANCH : $MED_TAGGER_BRANCH
echo MED_TAGGER_REPO   : $MED_TAGGER_REPO
echo MED_TAGGER_TAG    : $MED_TAGGER_TAG
echo
echo MED_TIME_BRANCH : $MED_TIME_BRANCH
echo MED_TIME_REPO   : $MED_TIME_REPO
echo MED_TIME_TAG    : $MED_TIME_TAG
echo
echo MED_XN_BRANCH : $MED_XN_BRANCH
echo MED_XN_REPO   : $MED_XN_REPO
echo MED_XN_TAG    : $MED_XN_TAG
echo
echo UIMA_STREAM_SERVER_BRANCH: $UIMA_STREAM_SERVER_BRANCH
echo UIMA_STREAM_SERVER_REPO  : $UIMA_STREAM_SERVER_REPO
echo UIMA_STREAM_SERVER_TAG   : $UIMA_STREAM_SERVER_TAG
echo
echo NLP2FHIR_BRANCH : $NLP2FHIR_BRANCH
echo NLP2FHIR_REPO   : $NLP2FHIR_REPO
echo NLP2FHIR_TAG    : $NLP2FHIR_TAG
echo

#*****************************************************************
# Verify that the ./UMLS and ./SNOMEDCT_US directories exist
# and are populated.
#*****************************************************************
FILE=""
DIR_UMLS="UMLS"
DIR_SNOMED="SNOMEDCT_US"

# look for empty ./UMLS dir
if [ "$(ls -A $DIR_UMLS)" ]; then
     echo "$DIR_UMLS directory is not Empty"
     echo ""
else
    echo "The $DIR_UMLS directory is Empty"
    echo "The MRCONSO.RRF file from a copy of the UMLS needs to be placed in the ./UMLS directory."
    echo ""
    exit
fi

# look for empty ./SNOMEDCT_US dir
if [ "$(ls -A $DIR_SNOMED)" ]; then
     echo "$DIR_SNOMED directory is not Empty"
     echo ""
else
    echo "The $DIR_SNOMED directory is Empty"
    echo "The SNOMEDCT US Edition resource files (downloadable with a UMLS license), need to be placed in the ./SNOMEDCT_US directory."
    echo ""
    exit
fi

#*****************************************************************
# Remove target directories and recreate them fresh.
#*****************************************************************
rm -rf $ROOT_DIR/target

mkdir $ROOT_DIR/target
mkdir $ROOT_DIR/target/$DIR_UMLS
mkdir $ROOT_DIR/target/$DIR_SNOMED
mkdir $ROOT_DIR/target/artifacts
mkdir $ROOT_DIR/target/artifacts/lib
mkdir $ROOT_DIR/target/artifacts/resources
mkdir $ROOT_DIR/target/resources


#*****************************************************************
# Create a maven container
#*****************************************************************
MAVEN_CONTAINER=$(docker run -d -P --name maven -v ~/.m2:/root/.m2:rw ubuntu)

#*****************************************************************
# Artifact builder will build MedTagger, cTAKES, MedTime,
# MedXN, and UMLS_VTS
#*****************************************************************
cd artifact-builder
#docker build -t artifact-builder .
docker run --rm \
  -v $ROOT_DIR/:/root \
  -v $ROOT_DIR/target:/target \
  -v $ROOT_DIR/target/artifacts/lib:/nlp2fhir_lib \
  -v $ROOT_DIR/target/artifacts/resources:/resources \
  -e DIR_UMLS=$DIR_UMLS -e DIR_SNOMED=$DIR_SNOMED \
  -e UMLS_VTS_BRANCH=$UMLS_VTS_BRANCH -e UMLS_VTS_REPO=$UMLS_VTS_REPO -e UMLS_VTS_TAG=$UMLS_VTS_TAG\
  -e MED_TAGGER_BRANCH=$MED_TAGGER_BRANCH -e MED_TAGGER_REPO=$MED_TAGGER_REPO -e MED_TAGGER_TAG=$MED_TAGGER_TAG \
  -e MED_TIME_BRANCH=$MED_TIME_BRANCH -e MED_TIME_REPO=$MED_TIME_REPO -e MED_TIME_TAG=$MED_TIME_TAG \
  -e MED_XN_BRANCH=$MED_XN_BRANCH -e MED_XN_REPO=$MED_XN_REPO -e MED_XN_TAG=$MED_XN_TAG \
  -e UIMA_STREAM_SERVER_BRANCH=$UIMA_STREAM_SERVER_BRANCH -e UIMA_STREAM_SERVER_REPO=$UIMA_STREAM_SERVER_REPO -e UIMA_STREAM_SERVER_TAG=$UIMA_STREAM_SERVER_TAG \
  -e NLP2FHIR_BRANCH=$NLP2FHIR_BRANCH -e NLP2FHIR_REPO=$NLP2FHIR_REPO  -e NLP2FHIR_TAG=$NLP2FHIR_TAG \
  --volumes-from maven endlecm/artifact-builder:1.0.7.SNAPSHOT
#  --volumes-from maven artifact-builder

cd ..

#*****************************************************************
# Remove maven container
#*****************************************************************
docker stop $MAVEN_CONTAINER
docker rm $MAVEN_CONTAINER
