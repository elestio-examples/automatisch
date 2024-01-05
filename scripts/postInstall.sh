# set env vars
set -o allexport; source .env; set +o allexport;

echo "Waiting..."
sleep 10s;

target=$(docker-compose port main 3000)


login=$(curl http://${target}/graphql \
  -H 'accept: */*' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6' \
  -H 'authorization;' \
  -H 'content-type: application/json' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  --data-raw '{"operationName":"Login","variables":{"input":{"email":"user@automatisch.io","password":"sample"}},"query":"mutation Login($input: LoginInput) {\n  login(input: $input) {\n    token\n    user {\n      id\n      email\n      __typename\n    }\n    __typename\n  }\n}\n"}' \
  --compressed)

  token=$(echo $login | jq -r '.data.login.token' )
  id=$(echo $login | jq -r '.data.login.user.id' )
  sleep 10s;


  curl http://${target}/graphql \
  -H 'accept: */*' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6' \
  -H 'authorization: '${token} \
  -H 'content-type: application/json' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  --data-raw '{"operationName":"UpdateUser","variables":{"input":{"email":"'${ADMIN_EMAIL}'","id":"'${id}'"}},"query":"mutation UpdateUser($input: UpdateUserInput) {\n  updateUser(input: $input) {\n    id\n    email\n    updatedAt\n    __typename\n  }\n}\n"}' \
  --compressed

  sleep 10s;

  curl http://${target}/graphql \
  -H 'accept: */*' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6' \
  -H 'authorization: '${token} \
  -H 'content-type: application/json' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36' \
  --data-raw '{"operationName":"UpdateUser","variables":{"input":{"password":"'${ADMIN_PASSWORD}'","id":"'${id}'"}},"query":"mutation UpdateUser($input: UpdateUserInput) {\n  updateUser(input: $input) {\n    id\n    email\n    updatedAt\n    __typename\n  }\n}\n"}' \
  --compressed
