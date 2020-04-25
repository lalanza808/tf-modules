format:
	docker run -it --rm -e HOME=/home -v $(PWD):/home/tf -w /home/tf hashicorp/terraform:light fmt -recursive

release:
	bash release.sh
