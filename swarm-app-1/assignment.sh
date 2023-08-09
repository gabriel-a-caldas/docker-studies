# Create the frontend network
docker network create --driver overlay frontend 

# Create the backend network
docker network create --driver overlay backend

# Create the voting app create 
docker service create --name voting-app --replicas 2 --publish published=80,target=80 --network frontend bretfisher/examplevotingapp_vote

docker service create --name redis --replicas 1 --network frontend redis:3.2

docker service create --name worker --replicas 1 --network frontend --network backend bretfisher/examplevotingapp_worker

docker service create --name db --replicas 1 --network backend -e POSTGRES_HOST_AUTH_METHOD=trust --mount type=volume,source=db-data,destination=/var/lib/postgres/data

docker service create --name result --replicas 1 --publish published=5001,target=80 --network backend bretfisher/examplevotingapp_result