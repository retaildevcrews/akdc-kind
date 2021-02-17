.PHONY: clone pre-kind set-kind deploy clean all

clone :
	git clone https://github.com/retaildevcrews/ngsa ~/ngsa
	cd ~/ngsa/IaC/DevCluster

pre-kind :
	sudo mkdir -p /prometheus
	sudo chown -R 65534:65534 /prometheus

	sudo mkdir -p /grafana
	sudo cp -R ~/ngsa/IaC/DevCluster/grafanadata/grafana.db /grafana
	sudo chown -R 472:472 /grafana

set-kind : pre-kind
	kind create cluster --name akdc --config kind.yaml
	kubectl wait node --for condition=ready --all --timeout=60s

deploy :
	kubectl apply -f ~/ngsa/IaC/DevCluster/ngsa-memory
	kubectl apply -f ~/ngsa/IaC/DevCluster/prometheus
	kubectl apply -f ~/ngsa/IaC/DevCluster/loderunner/loderunner.yaml
	kubectl apply -f ~/ngsa/IaC/DevCluster/grafana

clean :
	kind delete clusters akdc

all : clean set-kind deploy
