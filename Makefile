docker-install-requirements-txt:
	mkdir -p $(FOLDER_NAME)
	mkdir -p $(FOLDER_NAME)/src
	@if [ -d $(FOLDER_NAME) ]; then \
		cp requirements.txt ./$(FOLDER_NAME)/src/requirements.txt; \
	else \
		echo "Folder $(FOLDER_NAME) does not exist"; \
	fi
	set -e ;\
	docker run -v "$(PWD)/$(FOLDER_NAME)/src":/var/task "public.ecr.aws/sam/build-python3.13" /bin/sh -c "rm -R python; pip install -r requirements.txt -t python/lib/python3.6/site-packages/; exit"
	echo "Done"

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