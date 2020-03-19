.PHONY: up

up:
	docker build --pull -t ernestas/terraform:$$(date +%Y%m%d) .
	docker tag ernestas/terraform:$$(date +%Y%m%d) ernestas/terraform:latest
	docker push ernestas/terraform:$$(date +%Y%m%d)
	docker push ernestas/terraform:latest
