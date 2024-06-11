# Guide to Run Robot Tests in a Docker Container

This guide provides instructions on how to build a Docker image and run Robot Framework tests in a Docker container.

## Prerequisites

- Docker must be installed and running on your system.

## Steps

### 1. Build the Docker Image

To build the Docker image, navigate to the root directory of your project and run the following script:

```sh
$ ./docker/build_img.sh
```

### 2. Run the Test

To execute a Robot Framework test, use the following script and specify the path to the test file relative to the root directory:

```sh
$ ./docker/run_test.sh <robot_test_file_from_root>
```

### Example

Here is an example of how to run a specific test file:

```sh
$ ./docker/run_test.sh MEC029/SRV/FAIS/PlatFixedAcessInfo.robot
```

## Notes

- Ensure that the specified test file path is correct and accessible from the root directory.

## Troubleshooting

- If you encounter any issues with Docker, ensure that your Docker service is running and that you have the necessary permissions to execute Docker commands.
- Verify that the test file exists and that the path is correct.

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Robot Framework Documentation](https://robotframework.org/)