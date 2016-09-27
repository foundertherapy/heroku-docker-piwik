#!/bin/sh

regex="([^:]+):\/\/([^:]+):([^@]+)@([^:]+):?([0-9]+)?\/(.*)"
if [[ $DATABASE_URL =~ $regex ]]; then
  DB_USERNAME=${BASH_REMATCH[2]}
  DB_PASSWORD=${BASH_REMATCH[3]}
  DB_HOST=${BASH_REMATCH[4]}
  DB_PORT=${BASH_REMATCH[5]:-3306}
  DB_NAME=${BASH_REMATCH[6]}
fi

PIWIK_PATH=./vendor/piwik/piwik/
CONFIG_PATH="$PIWIK_PATH"config/config.ini.php
PLUGINS_PATH="$PIWIK_PATH"/plugins/

cp config.ini.php "$CONFIG_PATH"

sed -i s/#DB_HOST/$DB_HOST/ $CONFIG_PATH
sed -i s/#DB_USERNAME/$DB_USERNAME/ $CONFIG_PATH
sed -i s/#DB_PASSWORD/$DB_PASSWORD/ $CONFIG_PATH
sed -i s/#DB_NAME/$DB_NAME/ $CONFIG_PATH
sed -i s/#DB_PORT/$DB_PORT/ $CONFIG_PATH
sed -i s/#DB_PREFIX/$DB_PREFIX/ $CONFIG_PATH
sed -i s/#SECRET_TOKEN/$SECRET_TOKEN/ $CONFIG_PATH
sed -i s/#DOMAIN/$DOMAIN/ $CONFIG_PATH

curl -o "$PLUGINS_PATH"CustomDimensions.zip  'https://plugins.piwik.org/api/2.0/plugins/CustomDimensions/download/0.1.6'
unzip -a "$PLUGINS_PATH"CustomDimensions.zip
rm "$PLUGINS_PATH"CustomDimensions.zip
mv CustomDimensions "$PLUGINS_PATH"CustomDimensions
"$PIWIK_PATH"console plugin:activate CustomDimensions
