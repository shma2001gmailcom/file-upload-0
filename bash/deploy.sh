#!/bin/bash
##
## script for comfortable developing with tomcat and maven
##
## 1. cd to appfolder dir
## 2. run mvn clean install
## 3. stop server
## 4. remove old war and deployment
## 5. copy new war from target dir to server webapp dir
## 6. start server
## 7. open project home page
appname="file-upload-0"
############### properties ####################

################ AT HOME ######################
###############################################
#appfolder="/home/msha/workspace/"${appname}"-assembla"
#tomcatfolder="/home/msha/workspace/tomcat6"
#javahome="/usr/lib/jvm/jdk-6-oracle"

################################################
################ AT WORK #######################
################################################
appfolder="D:/work/my-prj/file-upload-0/"${appname}
warName='uploadFile'
tomcatfolder="D:/work/tomcat6"
javahome="C:/work/Java/jdk1.6.0_45"
M2_HOME='D:/work/maven/'
export M2_HOME
M2=${M2_HOME}/bin
export M2
mvn='D:/work/maven/bin/mvn.bat'
export JAVA_HOME=${javahome}

################################################
tomcatbin=${tomcatfolder}/bin
tomcatwebapps=${tomcatfolder}/webapps
if [ ! -e ${appfolder} ]; then echo 'ERROR: no appfolder' ${appfolder} 'found';exit 1; fi
if [ ! -e ${tomcatbin} ]; then echo 'ERROR: no tomcatbin found';exit 1; fi
cd ${appfolder}
${mvn} clean install $@ | tee out.txt ; test ${PIPESTATUS[0]} -eq 0
if [ ${PIPESTATUS[0]} -ne "0" ]; then
    echo ===================================================
    echo maven build failed, see output for details;exit 1;
    echo ===================================================
fi
cd ${tomcatbin}
if [ "$(ps axf | grep catalina | grep -v grep)" ]; then
    echo ///////////////////////////
    echo        stopping tomcat...
    bash shutdown.sh
    sleep 5
    echo ///////////////////////////
    echo        tomcat has been stopped
fi
cd ${tomcatwebapps}
if [ -e ${tomcatwebapps}/${warName} ]; then
    echo ///////////////////////////
    echo      remove old deployment...
    rm -rf -- ${tomcatwebapps}/${warName}
fi
if [ -e  ${tomcatwebapps}/${warName}.war ]; then
    echo ///////////////////////////
    echo      remove old war...
    rm -rf -- ${tomcatwebapps}/${warName}.war
fi
echo ///////////////////////////
echo      deploying new version...
cp  ${appfolder}/target/${warName}.war ${tomcatwebapps}/${warName}.war
cd ${tomcatbin}
echo ///////////////////////////
echo         starting tomcat...
echo ///////////////////////////
bash startup.sh
sleep 5
#firefox "http://localhost:8080/"${appname}
"C:\Program Files (x86)\Mozilla Firefox\firefox.exe" "http://localhost:8080/"${warName}/UploadPage.do
