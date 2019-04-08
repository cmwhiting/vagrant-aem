#!/bin/bash

# dependencies
  # mvn
  # vagrant
  # virtualbox

CLIENT_NAME="clientname";

GROUP_ID="com.intouchsol.aem";
ARTIFACT_ID="aem-quickstart";
VERSION="6.2.0";

ARTIFACT="$GROUP_ID:$ARTIFACT_ID:$VERSION";
FILES_PATH="setup/files";
OUTPUT_DIR="$( dirname ${BASH_SOURCE[0]} )/$FILES_PATH";
PARAMETERS_JSON="parameters.json";

if [ ! -e $OUTPUT_DIR/aem-quickstart-$VERSION.jar ]
then
  echo "Getting AEM jar ($VERSION)";

  mvn dependency:get -Dartifact=$ARTIFACT
  mvn dependency:copy -Dartifact=$ARTIFACT -DoutputDirectory=$OUTPUT_DIR
fi

cat <<EOF > $OUTPUT_DIR/$PARAMETERS_JSON
{
  "client": "$CLIENT_NAME",
  "aem_jar": "$FILES_PATH/$ARTIFACT_ID-$VERSION.jar",
  "aem_license": "THIS_DOESNT_WORK",
  "dispatcher_mod": "$FILES_PATH/linux-dispatcher-apache2.4-4.2.3.so",
  "jdk_pkg": "",
  "dispatcher_any": ""
}
EOF

echo "Starting setup...";
./setup/setup.rb $FILES_PATH/$PARAMETERS_JSON

echo "Starting Vagrant Box...";
vagrant up