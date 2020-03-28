# before we start, we should have built the sample web app with
dotnet publish -c Release -o out

# build our docker image and tag it
docker build -t samplewebapp:v4 .

# run our image
docker run -d -p 8080:80 samplewebapp:v4 --name myappv4

# test it
http://localhost:8080

# delete the container v2
docker rm -f myapp