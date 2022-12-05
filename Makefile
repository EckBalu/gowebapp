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
	kubectl delete service mywebapp-service
	kubectl delete deployment mywebapp

image:
	eval $(minikube docker-env)
	docker pull eckbalu/mywebapp

apply:
	kubectl apply -f deploy/mywebapp-deploy.yml
	kubectl get services | grep mywebapp

apply-keda:
	kubectl apply -f keda/keda-cpu-scaledobject.yml
	kubectl get hpa

test:
	curl 10.100.2.40:5001/

local-run:
	ENDPOINT=http://localhost:5001/ k6 run performance-test.js

local-influx-run:
	ENDPOINT=http://localhost:5001/ k6 run -o influxdb=http://localhost:8086/k6 performance-test.js

run:
	ENDPOINT=http://10.100.2.40:5001/ k6 run -o influxdb=http://localhost:8086/k6 performance-test.js
