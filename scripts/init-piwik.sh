#!/bin/bash

CONFIG_FILE=/usr/share/nginx/html/config/config.ini.php

if [ ! -f $CONFIG_FILE ]; then
  echo "; <?php exit; ?> DO NOT REMOVE THIS LINE
; file automatically generated or modified by Piwik; you can manually override the default values in global.ini.php by redefining them in this file.
[database]
host =
port = 3306
username =
password =
dbname = \"piwik\"
tables_prefix = \"piwik_\"
adapter = \"PDO\MYSQL\"
type = \"InnoDB\"
schema = \"Mysql\"" > $CONFIG_FILE
fi

# MySQL database host
if [ ! -z $DB_1_PORT_3306_TCP_ADDR ]; then
  DB_HOST=$DB_1_PORT_3306_TCP_ADDR
fi

if [ ! -z $DB_HOST ]; then
  sed -i "/host =/c\host = \"$DB_HOST\"" $CONFIG_FILE
fi

if [ ! -z $DB_1_PORT_3306_TCP_PORT ]; then
  DB_PORT=$DB_1_PORT_3306_TCP_PORT
fi

if [ ! -z $DB_PORT ]; then
  sed -i "/port =/c\port = \"$DB_PORT\"" $CONFIG_FILE
else
  DB_PORT=3306
fi

# MySQL database username
if [ ! -z $DB_USER ]; then
  sed -i "/username =/c\username = \"$DB_USER\"" $CONFIG_FILE
fi

# MySQL database password
if [ ! -z $DB_PASSWORD ]; then
  sed -i "/password =/c\password = \"$DB_PASSWORD\"" $CONFIG_FILE
fi

# The name of the database for Piwik
if [ ! -z $DB_NAME ]; then
  sed -i "/dbname =/c\dbname = \"$DB_NAME\"" $CONFIG_FILE
fi

# The table name prefix for Piwik
if [ ! -z $DB_TABLES_PREFIX ]; then
  sed -i "/tables_prefix =/c\tables_prefix = \"$DB_TABLES_PREFIX\"" $CONFIG_FILE
fi

# The charset of the database for Piwik
if [ ! -z $DB_CHARSET ]; then
  sed -i "/charset =/c\charset = \"$DB_CHARSET\"" $CONFIG_FILE
fi

echo "Done setting up piwik config..."
cat $CONFIG_FILE
chown www-data:www-data $CONFIG_FILE

if [ ! -z $PIWIK_SEED_DATABASE ]; then
  mysql --user=$DB_USER --password=$DB_PASSWORD --host=$DB_HOST \
        --port=$DB_PORT -D $DB_NAME < /usr/share/nginx/html/config/base-schema.sql
  SITE_SQL=$(cat <<EOF
        INSERT INTO \`piwik_site\`
        VALUES (1,
                'Example Piwik Site',
                'http://www.example.com',
                '2014-11-01 12:00:00',
                0,
                1,
                '',
                '',
                'UTC',
                'USD',
                '',
                '',
                '',
                '',
                'website',
                0);
EOF
)
  echo $SITE_SQL | mysql --user=$DB_USER --password=$DB_PASSWORD --host=$DB_HOST \
        --port=$DB_PORT -D $DB_NAME
fi

if [ ! -z $PIWIK_USER ] && [ ! -z $PIWIK_PASSWORD ]; then
  HASHED_PW=$(php -r 'print(md5("'"${PIWIK_PASSWORD}"'"));')
  USER_SQL=$(cat <<EOF
        INSERT INTO \`piwik_user\`
        VALUES ('$PIWIK_USER',
                '$HASHED_PW',
                '$PIWIK_USER',
                '${PIWIK_USER}@example.com',
                '$HASHED_PW',
                1,
                '2014-11-01 12:00:00');
EOF
)
  echo $USER_SQL;
  echo $USER_SQL | mysql --user=$DB_USER --password=$DB_PASSWORD --host=$DB_HOST \
        --port=$DB_PORT -D $DB_NAME
fi
