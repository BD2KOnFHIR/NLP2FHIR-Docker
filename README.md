# NLP2FHIR-Docker

The NLP2FHIR-Docker project was created to ease the burden of building the [NLP2FHIR](https://github.com/BD2KOnFHIR/NLP2FHIR) project.  This project builds the multiple software projects required as dependencies for running the GUI in the [NLP2FHIR](https://github.com/BD2KOnFHIR/NLP2FHIR) project.  This is done by creating a Docker container to build the projects and place the resources and artifacts on a volume (directory) on the user’s system.  Additionally, there is a script that is produced to start the NLP2FHIR-GUI using the correct classpath. 


## Details

### Prerequisites
To run this project, you will need Docker installed. 
This project also requires you to have a [UMLS license](https://uts.nlm.nih.gov/license.html).


After cloning the project, cd to the NLP2FHIR-Docker directory.  In this directory, you will need to supply two additional directories (**UMLS** and **SNOMEDCT_US**).  Both of these resources require you to have a [UMLS license](https://uts.nlm.nih.gov/license.html).  As such, it is the responsibility of the user to manually download the UMLS and SNOMEDCT_US.
* UMLS  - The MRCONSO.RRF file from a copy of the UMLS must be placed in the ./UMLS directory.
* SNOMEDCT_US - The SNOMEDCT US Edition resource files (located at <SNOWMEDCT_US download dir>/Full/Terminology/*) must be placed in ./SNOMEDCT_US.

### Build
Run the ./build.sh command to start the build process.

The Docker container will do the following tasks:
- Verify that the user has the directory NLP2FHIR-Docker/UMLS.
- Verify that the user has the directory NLP2FHIR-Docker/SNOMEDCT_US.
- Create an NLP2FHIR-Docker/target directory that will contain all of the necessary build resources, build artifacts and run scripts.
- Build the [MedTagger](https://github.com/ohnlp/MedTagger) project and gather the artifacts and resources.
- Build the [MedTime](https://github.com/ohnlp/MedTime) project and gather the artifacts and resources.  
- Build the [MedXN](https://github.com/ohnlp/MedXN) project and gather the artifacts and resources.
- Build the [UMLS_VTS](https://github.com/OHNLPIR/UMLS_VTS) project and gather the artifacts and resources.
- Build the [UIMA-Stream-Server](https://github.com/OHNLPIR/UIMA-Stream-Server) project and gather the artifacts and resources.
- Download the [cTAKES](http://ctakes.apache.org/downloads.html) project, unzip it and gather the resources.
- Build the [NLP2FHIR](https://github.com/BD2KOnFHIR/NLP2FHIR) project and gather the artifacts.
- Create a run script to run the NLP2FHIR-GUI.

### Run
After the build.sh command has completed, there will be a target directory.  
cd to this target directory.
Run the **run_nlp2fir-gui_linux.sh** command to launch the NLP2FHIR-GUI.
