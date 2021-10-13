#!/bin/bash

cat `pwd`"/VERSION"

#################################################
##Functions and vars for actions results printing
#################################################

RES_COL=80
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
SETCOLOR_INFO="echo -en \\033[1;38m"
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"
SETCOLOR_WARNING="echo -en \\033[1;33m"

function  echo_success() {
    echo -n "$1"
    $MOVE_TO_COL
    $SETCOLOR_SUCCESS
    echo -n "$2"
    $SETCOLOR_NORMAL
    echo -e "\r"
    echo ""
}

function echo_failure() {
    echo -n "$1"
    $MOVE_TO_COL
    $SETCOLOR_FAILURE
    echo -n "$2"
    $SETCOLOR_NORMAL
    echo -e "\r"
    echo ""
}

function echo_passed() {
    echo -n "$1"
    $MOVE_TO_COL
    $SETCOLOR_WARNING
    echo -n "$2"
    $SETCOLOR_NORMAL
    echo -e "\r"
    echo ""
}

##################
##Static variables
##################

INIT_FOLDER="init-script/"
INIT_FILE="connector-as400"

CONNECTOR_HOME="/usr/share/centreon-connector-as400/"
CONNECTOR_LOG="/var/log/centreon-connector-as400/"
CONNECTOR_ETC="/etc/centreon-connector-as400/"
LOG_ETC_FILE="log4j.xml"

CONNECTOR_USER="centreonConnectorAS400"
CONNECTOR_GROUP="centreonConnectorAS400"

JAVA_BIN=""

ETC_PASSWD="/etc/passwd"
ETC_GROUP="/etc/group"
ETC_INITD="/etc/init.d/"

######
##INIT
######

$SETCOLOR_WARNING
echo "Starting setup..."
$SETCOLOR_NORMAL
echo ""

##############################
##Getting modules install path
##############################
DONE="no"
CREATE_HOME="no"
temp_folder="$CONNECTOR_HOME"
while [ "$DONE" = "no" ]; do
	echo  "Centreon CONNECTOR home Directory [$CONNECTOR_HOME]? "
	echo -n ">"
	read temp_folder
	if [ -z "$temp_folder" ]; then
		temp_folder="$CONNECTOR_HOME"
	fi
	temp_folder=`echo "$temp_folder" | sed "s/$/\//"`
	
	if [ -d "$temp_folder" ]; then
		DONE="yes"
	else
	    echo_failure "$temp does not exists" "CRITICAL"
	    echo  "Specified path does not exists, do you want to create it ?[Y/n]"
	    echo -n ">"
	    read temp
	    if [ -z "$temp" ]; then
		temp="Y"
	    fi
	    while [ "$temp" != "Y" ] && [ "$temp" != "y" ] && [ "$temp" != "n" ] && [ "$temp" != "N" ]; do
			echo  "Specified path does not exists, do you want to create it ?[Y/n]"
			echo -n ">"
			read temp
			if [ -z "$temp" ]; then
			    temp="Y"
			fi
	    done
	    if [ "$temp" = "Y" ] || [ "$temp" = "y" ]; then
			DONE="yes"
			CREATE_HOME="yes"
	    fi
 	fi
done
CONNECTOR_HOME=${temp_folder}
echo_success "Centreon CONNECTOR home directory" "$CONNECTOR_HOME"

#############################
##Getting java home directory
#############################

JAVA_HOME="/usr/java/"
temp=$JAVA_HOME
while [ ! -x "$temp/bin/java" ]; do
    echo_failure "Cannot find java binary" "FAILURE"
    echo "Java home directory?"
    echo -n ">"
    read temp
    if [ -z "$temp" ]; then
        temp="$JAVA_HOME"
    fi
done
temp=`echo "$temp" | sed "s/$/\//"`
JAVA_BIN=`echo $temp | sed "s/\/\/$/\//"`"bin/java"
echo_success "Java bin path :" "$JAVA_BIN"

###################
# CONNECTOR INIT SCRIPT
###################

echo "Do you want to install CONNECTOR init script [y/N]?"
echo -n ">"
read response
if [ -z "$response" ]; then
    response="N"
fi
while [ "$response" != "Y" ] && [ "$response" != "y" ] &&  [ "$response" != "N" ] && [ "$response" != "n" ]; do
    echo "Do you want to install CONNECTOR init script [y/N]?"
    echo -n ">"
    read response
    if [ -z "$response" ]; then
	response="N"
    fi
done
INSTALL_CONNECTOR_INIT=$response
echo_success "CONNECTOR init script :" "$ETC_INITD/$INIT_FILE"

########################
## Centreon BI user and Group
########################
exists=`cat $ETC_PASSWD | grep "^$CONNECTOR_USER:"`
if [ -z "$exists" ]; then
    useradd -m $CONNECTOR_USER -d $CONNECTOR_HOME
fi
echo_success "CONNECTOR run user :" "$CONNECTOR_USER"

exists=`cat $ETC_GROUP | grep "^$CONNECTOR_GROUP:"`
if [ -z "$exists" ]; then
	groupadd $CONNECTOR_GROUP
fi
echo_success "CONNECTOR run group :" "$CONNECTOR_GROUP"

#######################
# DEPLOYING CENTREON BI
#######################
echo ""
echo_success "Creating directories and moving binaries..." "OK"
if [ ! -d "${CONNECTOR_HOME}" ]; then
     mkdir -p $CONNECTOR_HOME
fi
 
cp -R bin/ ${CONNECTOR_HOME}
 
if [ ! -d "${CONNECTOR_LOG}" ]; then
     mkdir -p ${CONNECTOR_LOG}
fi
if [ ! -d "${CONNECTOR_ETC}" ]; then
     mkdir -p ${CONNECTOR_ETC}
fi

cp etc/log4j.xml ${CONNECTOR_ETC}
 
###################
##Macro replacement
###################

ETC_FILE=${CONNECTOR_ETC}${CONNECTOR_ETC_FILE}

if [ "$INSTALL_CONNECTOR_INIT" = "y" ] || [ "$INSTALL_CONNECTOR_INIT" = "Y" ]; then
    echo_success "Copying CONNECTOR init script..." "OK"
    if [ -x "$ETC_INITD/$INIT_FILE" ]; then
		mv $ETC_INITD/$INIT_FILE $ETC_INITD/$INIT_FILE.bkp
    fi
    sed -e 's|@CONNECTOR_HOME@|'"$CONNECTOR_HOME"'|g' \
    -e 's|@JAVA_BIN@|'"$JAVA_BIN"'|g' \
    -e 's|@CONNECTOR_USER@|'"$CONNECTOR_USER"'|g' \
    -e 's|@CONNECTOR_ETC@|'"${CONNECTOR_ETC}"'|g' \
    -e 's|@CONNECTOR_LOG@|'"${CONNECTOR_LOG}"'|g' \
    $INIT_FOLDER/$INIT_FILE > $ETC_INITD/$INIT_FILE
    chmod +x $ETC_INITD/$INIT_FILE
fi
echo_success "Deploying Centreon-Connector..." "OK"

###################################################
##Rights settings on install directory and binaries
###################################################

chown -R $CONNECTOR_USER.$CONNECTOR_GROUP $CONNECTOR_HOME
chown -R $CONNECTOR_USER.$CONNECTOR_GROUP $CONNECTOR_LOG
chown -R $CONNECTOR_USER.$CONNECTOR_GROUP $CONNECTOR_ETC
chmod -R 775 $CONNECTOR_HOME

echo_success "Rights settings..." "OK"


COMMAND=`whereis -b update-rc.d | sed -e 's|^update-rc:||'`
if [ ! -z "$COMMAND" ]; then
	echo_success "Creating daemon connector" "OK"
	update-rc.d connector  start 20 3 5 . stop 20 0 1 6 .
fi
COMMAND=`whereis -b chkconfig | sed -e 's|^chkconfig:||'`
if [ ! -z "$COMMAND" ]; then
	echo_success "Creating daemon Connector" "OK"
	chkconfig --add connector
	chkconfig --level 345 connector on
fi
#$ETC_INITD/$INIT_FILE restart

#########
# THE END
#########

echo ""
$SETCOLOR_WARNING
echo "Setup finished."
echo ""
$SETCOLOR_FAILURE
echo "Compile and manually copy plugins to %nagios%/libexec/"
$SETCOLOR_NORMAL
echo "Use : cmake ./plugins"
echo "Use : cd ./plugins"
echo "Use : make"
echo ""