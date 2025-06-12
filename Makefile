# Using AWS SAM Lambda Python image with full path
lambda-image-full-path-docker-install-requirements-txt:
	mkdir -p $(FOLDER_NAME)
	mkdir -p $(FOLDER_NAME)/src
	@if [ -d $(FOLDER_NAME) ]; then \
		cp requirements.txt ./$(FOLDER_NAME)/src/requirements.txt; \
	else \
		echo "Folder $(FOLDER_NAME) does not exist"; \
	fi
	set -e ;\
	docker run -v "$(PWD)/$(FOLDER_NAME)/src":/var/task "public.ecr.aws/sam/build-python3.13" /bin/sh -c "rm -R python; pip install -r requirements.txt -t python/lib/python3.13/site-packages/; exit"
	echo "Done"

# Using AWS SAM Lambda Python image with python dir
lambda-image-python-dir-docker-install-requirements-txt:
	mkdir -p $(FOLDER_NAME)
	mkdir -p $(FOLDER_NAME)/src
	@if [ -d $(FOLDER_NAME) ]; then \
		cp requirements.txt ./$(FOLDER_NAME)/src/requirements.txt; \
	else \
		echo "Folder $(FOLDER_NAME) does not exist"; \
	fi
	set -e ;\
	docker run -v "$(PWD)/$(FOLDER_NAME)/src":/var/task "public.ecr.aws/sam/build-python3.13" /bin/sh -c "rm -R python; pip install -r requirements.txt -t python; exit"
	echo "Done"

# Using AL2 image with full path
al2-full-path-docker-install-requirements-txt:
	mkdir -p $(FOLDER_NAME)
	mkdir -p $(FOLDER_NAME)/src
	@if [ -d $(FOLDER_NAME) ]; then \
		cp requirements.txt ./$(FOLDER_NAME)/src/requirements.txt; \
	else \
		echo "Folder $(FOLDER_NAME) does not exist"; \
	fi
	set -e ;\
	docker run -v "$(PWD)/$(FOLDER_NAME)/src":/var/task "amazonlinux:2023" \
	/bin/sh -c "dnf update -y && \
	dnf install -y python3.13 python3.13-pip && \
	cd /var/task && \
	rm -rf python && \
	pip3.13 install -r requirements.txt -t python/lib/python3.13/site-packages"
	echo "Dependencies installed"

# Using AL2 image with python dir
al2-python-dir-docker-install-requirements-txt:
	mkdir -p $(FOLDER_NAME)/src
	cp requirements.txt $(FOLDER_NAME)/src/requirements.txt
	docker run -v "$(PWD)/$(FOLDER_NAME)/src":/var/task "amazonlinux:2023" \
	/bin/sh -c "dnf update -y && \
	dnf install -y python3.13 python3.13-pip && \
	cd /var/task && \
	rm -rf python && \
	pip3.13 install -r requirements.txt -t python"
	echo "Dependencies installed"

zip-libraries:
	cd $(FOLDER_NAME)/src && \
	zip -r $(FOLDER_NAME).zip python > /dev/null && \
	rm -R python
	echo "Done"

move-libraries:
	cd $(FOLDER_NAME)/src && \
	cp $(FOLDER_NAME).zip $(OUTPUT_PATH)/$(FOLDER_NAME).zip 
	echo "Done"

clean-up:
	@if [ -d $(FOLDER_NAME) ]; then \
		rm -r $(FOLDER_NAME); \
	else \
		echo "Folder $(FOLDER_NAME) does not exist"; \
	fi

all: docker-install-requirements-txt zip-libraries move-libraries clean-up

lambda-image-full-path: lambda-image-full-path-docker-install-requirements-txt zip-libraries move-libraries clean-up

lambda-image-python-dir: lambda-image-python-dir-docker-install-requirements-txt zip-libraries move-libraries clean-up

al2-full-path: al2-full-path-docker-install-requirements-txt zip-libraries move-libraries clean-up

al2-python-dir: al2-python-dir-docker-install-requirements-txt zip-libraries move-libraries clean-up