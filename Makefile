all: help

help:
        @echo ----------------------------------
        @echo MYWEBAPP DEPLOYMENT COMMANDS
        @echo ----------------------------------
        @echo make image        - build and upload docker image to minikube environment
        @echo make apply        - deploy mywebapp and expose service
        @echo make test         - test deployment
        @echo make delete       - uninstall mywebapp deployment and service

delete:
        kubectl delete service myapp-service
        kubectl delete deployment myapp

image:
        eval $(minikube docker-env)
        docker pull eckbalu/mywebapp

apply:
        kubectl apply -f deploy/mywebapp-deploy.yml
        kubectl get services | grep mywebapp

test:
        curl 10.98.55.109:5001/crocodiles

local-run:
        ENDPOINT=http://localhost:5001/crocodiles k6 run performance-test.js

local-influx-run:
        ENDPOINT=http://localhost:5001/crocodiles k6 run -o influxdb=http://localhost:8086/k6 performance-test.js

run:
        ENDPOINT=http://10.98.55.109:5001/crocodiles k6 run -o influxdb=http://localhost:8086/k6 performance-test.js