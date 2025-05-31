# AWS Lambda Python Dependencies Packaging Makefile

This Makefile streamlines the process of building AWS Lambda-compatible Python dependencies using Docker, zipping them, and preparing them for deployment. It is especially useful for ensuring your dependencies are built in an environment compatible with AWS Lambda's runtime.

---

## Prerequisites

- **Docker** must be installed and running on your machine.
- A valid `requirements.txt` file in your project root.
- GNU Make installed.

---

## Usage

First, update the requirements.txt with the required Python libraries.

Next get the values for `FOLDER_NAME` and `OUTPUT_PATH`.

- `FOLDER_NAME`: The name of the folder to use for packaging (e.g., `package`).
- `OUTPUT_PATH`: The directory where the zipped package should be moved (e.g., `dist/`).

Example:

```bash
make all FOLDER_NAME=package OUTPUT_PATH=dist/
```

## Makefile Targets

### 1. `docker-install-requirements-txt`

- Creates the folder specified by `FOLDER_NAME`.
- Copies `requirements.txt` into `$(FOLDER_NAME)`.
- Uses the [public.ecr.aws/sam/build-python3.13](https://gallery.ecr.aws/sam/build-python3.13) Docker image to install dependencies into the correct directory structure for Lambda layers (`python/lib/python3.13/site-packages/`).
- Outputs "Done" when complete.


### 2. `zip-libraries`

- Navigates into the `src` directory.
- Zips the `python` directory into `$(FOLDER_NAME).zip`.
- Removes the `python` directory to clean up.
- Outputs "Done" when complete.


### 3. `move-libraries`

- Moves the zipped package (`$(FOLDER_NAME).zip`) from `src` to the output directory specified by `OUTPUT_PATH`.
- Outputs "Done" when complete.


### 4. `clean-up`

- Removes the `$(FOLDER_NAME)` directory and its contents.
- Skips if the folder does not exist.


### 5. `all`

- Runs all the above steps in sequence:
`docker-install-requirements-txt`, `zip-libraries`, `move-libraries`, and `clean-up`.

---

## Example Usage

To run the full workflow and output the zipped package to the `/Documents/sample-project/lambda/libraries/` directory with the folder name `google-cloud-library`:

## Example Workflow

```bash
make all FOLDER_NAME=google-cloud-library OUTPUT_PATH=~/Documents/sample-project/lambda/libraries
```

---

## Notes

- The zipped file (`dist/package.zip`) can be used as a Lambda Layer or included in your Lambda deployment package.
- The Docker build ensures your dependencies are compatible with AWS Lambda's Amazon Linux runtime.
- The `src` directory is used as a workspace for zipping and moving files.
- Adjust the Python version in the Docker image and paths if you are targeting a different Lambda Python runtime.

---

**Happy Lambda Layer Packaging!**