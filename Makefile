docker: 
	docker build -t k8s-thing-backend backend
	docker build -t k8s-thing-frontend frontend

load: 
	docker save k8s-thing-backend | (eval $(minikube docker-env) && docker load)
	docker save k8s-thing-frontend | (eval $(minikube docker-env) && docker load)

deploy: 
	kubectl create secret generic k8s-thing-redis-password --from-literal=k8s-thing-redis-password=password123
	kubectl apply -f cache/deployment.yml
	kubectl apply -f cache/service.yml
	kubectl apply -f backend/k8s/configmap.yml
	kubectl apply -f backend/k8s/deployment.yml
	kubectl apply -f backend/k8s/service.yml
	kubectl apply -f frontend/k8s/deployment.yml
	kubectl apply -f frontend/k8s/service.yml
	kubectl apply -f k8s/ingress.yml

delete: 
	kubectl delete deployment k8s-thing-backend
	kubectl delete deployment k8s-thing-frontend
	kubectl delete deployment k8s-thing-redis
	kubectl delete configmap k8s-thing-backend-config
	kubectl delete service k8s-thing-backend-service
	kubectl delete service k8s-thing-frontend-service
	kubectl delete service k8s-thing-redis-service
	kubectl delete ingress k8s-thing-ingress
	kubectl delete secret k8s-thing-redis-password

clean:
	docker image prune
	rm -rf backend/node_modules
	rm -rf frontend/node_modules
	rm -rf frontend/.nuxt
