#run a new container named postgres
#specify db name, username and password via environment variables
#allows apps to conenct to db on default port 5432 
#run server in background as a daemon
#user docker image named postgres for this container
#if the image is not present Docker downloads it
docker run --name postgres -e POSTGRES_DB=vapor -e POSTGRES_USER=vapor -e POSTGRES_PASSWORD=password -p 5432:5432 -d postgres
