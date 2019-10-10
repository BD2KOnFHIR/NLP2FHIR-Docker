#!/bin/bash

rm -rf /target

mkdir /target
mkdir /target/artifacts
mkdir /target/artifacts/lib
mkdir /target/artifacts/resources
mkdir /target/resources

# Set the PATH env. variable
export PATH=${PATH}:/nlp2fhir_lib:/resources

# MedTagger
echo "*************************************************************************"
echo "Cloning git repository $MED_TAGGER_REPO from branch $MED_TAGGER_BRANCH"
echo "*************************************************************************"

git clone -b $MED_TAGGER_BRANCH $MED_TAGGER_REPO && \
    cd MedTagger/ && \
    git checkout $MED_TAGGER_TAG && \
    mvn clean install && \
    # Copy artifacts of build to /nlp2fhir_lib directory
    cp target/*.jar /target/artifacts/lib && \
    # Copy resources to the resources and root directories
    cp -R src/main/resources/* /target/artifacts/resources
    cp -R src/main/resources/* /target
    cd ..

# MedTIME
echo "*************************************************************************"
echo "Cloning git repository $MED_TIME_REPO from branch $MED_TIME_BRANCH"
echo "*************************************************************************"

git clone -b $MED_TIME_BRANCH $MED_TIME_REPO && \
    cd MedTime/ && \
    git checkout $MED_TIME_TAG && \
    mvn clean install && \
    # Copy artifacts of build to /nlp2fhir_lib directory
    cp target/*.jar /target/artifacts/lib && \
    # Copy resources to the resources and root directories
    cp -R src/main/resources/* /target/artifacts/resources
    cp -R src/main/resources/* /target
    cp -R resources/* /target/resources
    cd ..

# MedXN
echo "*************************************************************************"
echo "Cloning git repository $MED_XN_REPO from branch $MED_XN_BRANCH"
echo "*************************************************************************"

git clone -b $MED_XN_BRANCH $MED_XN_REPO && \
    cd MedXN/ && \
    git checkout $MED_XN_TAG && \
    mvn clean install && \
    # Copy artifacts of build to /nlp2fhir_lib directory
    cp target/*.jar /target/artifacts/lib && \
    # Copy resources to the resources and root directories
    cp -R src/main/resources/* /target/artifacts/resources
    cp -R src/main/resources/* /target
    cd ..

# Copy all desc directories to the main level.  This will fix classpath issues.
cp -R /target/artifacts/resources/desc/* /target

# UMLS_VTS
echo "*************************************************************************"
echo "Cloning git epository $UMLS_VTS_REPO from branch $UMLS_VTS_BRANCH"
echo "*************************************************************************"

git clone -b $UMLS_VTS_BRANCH $UMLS_VTS_REPO && \
    cd UMLS_VTS/ && \
    git checkout $UMLS_VTS_TAG && \
    mvn clean install && \
    # Copy artifacts of build to /nlp2fhir_lib directory
    cp target/*.jar /target/artifacts/lib
    cd ..

# UIMA_STREAM_SERVER
echo "*************************************************************************"
echo "Cloning git repository $UIMA_STREAM_SERVER_REPO from branch $UIMA_STREAM_SERVER_BRANCH"
echo "*************************************************************************"
git clone -b $UIMA_STREAM_SERVER_BRANCH $UIMA_STREAM_SERVER_REPO && \
    cd UIMA-Stream-Server/ && \
    git checkout $UIMA_STREAM_SERVER_TAG && \
    mvn clean install && \
    # Copy artifacts of build to /nlp2fhir_lib directory
    cp UIMA-Server-Core/target/*.jar /target/artifacts/lib && \
    cp UIMA-Server-Plugins/ExampleServerPlugin/target/*.jar /target/artifacts/lib && \
    cp UIMA-Server-REST/target/*.jar /target/artifacts/lib && \
    cd ..

# cTAKES
echo "*************************************************************************"
echo "Downloading cTAKES reources package... this will take a few minutes."
echo "*************************************************************************"
CTAKES_DIR='cTAKES'
mkdir $CTAKES_DIR && cd $CTAKES_DIR && \
    wget http://sourceforge.net/projects/ctakesresources/files/ctakes-resources-4.0-bin.zip && \
    unzip ctakes-resources-4.0-bin.zip
    cp -r resources/* /target/artifacts/resources
    # Copy resource to additional directory for classpath issues at runtime.
    cp -r resources/org/apache /target/org/
    cd ..

# NLP2FHIR
echo "*************************************************************************"
echo "Cloning git repository $NLP2FHIR_REPO from branch $NLP2FHIR_BRANCH"
echo "*************************************************************************"
echo "path =  $PATH"

git clone -b $NLP2FHIR_BRANCH $NLP2FHIR_REPO && \
      cd NLP2FHIR/ && \
      git checkout $NLP2FHIR_TAG && \
      mvn clean install && \
      # Copy artifacts of build to /target/artifacts/lib directory
      cp AnnotationUtils/target/*.jar /target/artifacts/lib
      cp FHIR-Typesystem-UIMA/target/*.jar /target/artifacts/lib
      cp NLP2FHIR-GUI/target/*.jar /target/artifacts/lib
      cp NLP2FHIR-STREAM/target/*.jar /target/artifacts/lib
      cp NLP2FHIR-WEB/target/*.war /target/artifacts/lib
      cd ..

cp -R /target/artifacts/resources/desc/* /target/resources
cp -R /target/artifacts/resources/* /target/resources

cp -R /target/artifacts/resources/desc/* /target/artifacts/lib
cp -R /target/artifacts/resources/* /target/artifacts/lib

#*****************************************************************
# Copy the snomeddictionaryfhirner directory contents to
# two different places
#*****************************************************************
unzip snomeddictionaryfhir.zip && \
cp -a /snomeddictionaryfhir/. /target/artifacts/resources/org/apache/ctakes/dictionary/lookup/fast/
cp -a /snomeddictionaryfhir/. /target/org/apache/ctakes/dictionary/lookup/fast/

#*****************************************************************
# Copy the NLP2FHIR GUI run commands to the target directory.
#*****************************************************************
cp run_nlp2fir-gui_linux.sh /target/

#*****************************************************************
# Change permission of /nlp2fhir_lib jars and /resources
# to be executable.
#*****************************************************************
chmod -R 755 /target/artifacts/lib
chmod -R 755 /target/artifacts/resources
