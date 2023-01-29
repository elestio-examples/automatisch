#set env vars
#set -o allexport; source .env; set +o allexport;

mkdir -p ./automatisch_storage
mkdir -p ./postgres_data
mkdir -p ./redis_data
chown -R 1000:1000 ./automatisch_storage
chown -R 1000:1000 ./postgres_data
chown -R 1000:1000 ./redis_data
