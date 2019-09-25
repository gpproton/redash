REDASH_BASE_PATH=/opt/redash
sudo mkdir -p $REDASH_BASE_PATH
sudo chown $USER:$USER $REDASH_BASE_PATH

sudo mkdir $REDASH_BASE_PATH/postgres-data
rm $REDASH_BASE_PATH/env 2>/dev/null
touch $REDASH_BASE_PATH/env
COOKIE_SECRET=$(pwgen -1s 32)
POSTGRES_PASSWORD=$(pwgen -1s 32)
REDASH_DATABASE_URL="postgresql://postgres:${POSTGRES_PASSWORD}@postgres/postgres"
echo "PYTHONUNBUFFERED=0" >> $REDASH_BASE_PATH/env
echo "REDASH_LOG_LEVEL=INFO" >> $REDASH_BASE_PATH/env
echo "REDASH_REDIS_URL=redis://redis:6379/0" >> $REDASH_BASE_PATH/env
echo "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" >> $REDASH_BASE_PATH/env
echo "REDASH_COOKIE_SECRET=$COOKIE_SECRET" >> $REDASH_BASE_PATH/env
echo "REDASH_DATABASE_URL=$REDASH_DATABASE_URL" >> $REDASH_BASE_PATH/env

cat $REDASH_BASE_PATH/env

REQUESTED_CHANNEL=stable
LATEST_VERSION=`curl -s "https://version.redash.io/api/releases?channel=$REQUESTED_CHANNEL"  | json_pp  | grep "docker_image" | head -n 1 | awk 'BEGIN{FS=":"}{print $3}' | awk 'BEGIN{FS="\""}{print $1}'`

cd $REDASH_BASE_PATH
REDASH_BRANCH="${REDASH_BRANCH:-master}" # Default branch/version to master if not specified in REDASH_BRANCH env var
wget https://raw.githubusercontent.com/getredash/redash/${REDASH_BRANCH}/setup/docker-compose.yml
sed -ri "s/image: redash\/redash:([A-Za-z0-9.-]*)/image: redash\/redash:$LATEST_VERSION/" docker-compose.yml
echo "export COMPOSE_PROJECT_NAME=redash" >> ~/.profile
echo "export COMPOSE_FILE=/opt/redash/docker-compose.yml" >> ~/.profile
source ~/.profile
docker-compose run --rm server create_db





