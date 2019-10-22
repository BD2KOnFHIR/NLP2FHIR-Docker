#!/bin/bash

# Set the PATH env. variable
export PATH=${PATH}:/nlp2fhir_lib:/resources

# Copy the UMLS and SNOMEDCT_US directories to the target directory.
echo "*************************************************************************"
echo "Copying the UMLS and SNOMEDCT_US directories to the target directory."
echo "*************************************************************************"
cp  -R root/$DIR_UMLS/* /target/$DIR_UMLS
cp  -R root/$DIR_SNOMED/* /target/$DIR_SNOMED

# MedTagger
echo "*************************************************************************"
echo "Cloning git repository $MED_TAGGER_REPO from branch $MED_TAGGER_BRANCH"
echo "*************************************************************************"

git clone -b $MED_TAGGER_BRANCH $MED_TAGGER_REPO && \
    cd MedTagger/ && \
    git checkout $MED_TAGGER_TAG && \
    mvn clean install && \
    # Copy artifacts of build to /nlp2fhir_lib directory
    cp target/*.jar /nlp2fhir_lib && \
    # Copy resources to the resources and root directories
    cp -R src/main/resources/* /resources
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
    cp target/*.jar /nlp2fhir_lib && \
    # Copy resources to the resources and root directories
    cp -R src/main/resources/* /resources
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
    cp target/*.jar /nlp2fhir_lib && \
    # Copy resources to the resources and root directories
    cp -R src/main/resources/* /resources
    cp -R src/main/resources/* /target
    cd ..

# Copy all desc directories to the main level.  This will fix classpath issues.
cp -R /resources/desc/* /target

# UMLS_VTS
echo "*************************************************************************"
echo "Cloning git epository $UMLS_VTS_REPO from branch $UMLS_VTS_BRANCH"
echo "*************************************************************************"

git clone -b $UMLS_VTS_BRANCH $UMLS_VTS_REPO && \
    cd UMLS_VTS/ && \
    git checkout $UMLS_VTS_TAG && \
    mvn clean install && \
    # Copy artifacts of build to /nlp2fhir_lib directory
    cp target/*.jar /nlp2fhir_lib
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
    cp UIMA-Server-Core/target/*.jar /nlp2fhir_lib && \
    cp UIMA-Server-Plugins/ExampleServerPlugin/target/*.jar /nlp2fhir_lib && \
    cp UIMA-Server-REST/target/*.jar /nlp2fhir_lib && \
    cd ..

# cTAKES
echo "*************************************************************************"
echo "Downloading cTAKES reources package... this will take a few minutes."
echo "*************************************************************************"
CTAKES_DIR='cTAKES'
mkdir $CTAKES_DIR && cd $CTAKES_DIR && \
    wget http://sourceforge.net/projects/ctakesresources/files/ctakes-resources-4.0-bin.zip && \
    unzip ctakes-resources-4.0-bin.zip
    cp -r resources/* /resources
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
      # Copy artifacts of build to /nlp2fhir_lib directory
      cp AnnotationUtils/target/*.jar /nlp2fhir_lib
      cp FHIR-Typesystem-UIMA/target/*.jar /nlp2fhir_lib
      cp NLP2FHIR-GUI/target/*.jar /nlp2fhir_lib
      cp NLP2FHIR-STREAM/target/*.jar /nlp2fhir_lib
      cp NLP2FHIR-WEB/target/*.war /nlp2fhir_lib
      cd ..

cp -R /resources/desc/* /target/resources
cp -R /resources/* /target/resources

cp -R /resources/desc/* /nlp2fhir_lib
cp -R /resources/* /nlp2fhir_lib

#*****************************************************************
# Copy the snomeddictionaryfhirner directory contents to
# two different places
#*****************************************************************
unzip snomeddictionaryfhir.zip && \
cp -a /snomeddictionaryfhir/. /resources/org/apache/ctakes/dictionary/lookup/fast/
cp -a /snomeddictionaryfhir/. /target/org/apache/ctakes/dictionary/lookup/fast/

#*****************************************************************
# Copy the NLP2FHIR GUI run commands to the target directory.
#*****************************************************************
cp run_nlp2fir-gui_linux.sh /target/
cp run_nlp2fir-gui_windows.bat /target/

#*****************************************************************
# Change permission of /nlp2fhir_lib jars and /resources
# to be executable.
#*****************************************************************
chmod -R 755 /nlp2fhir_lib
chmod -R 755 /resources
