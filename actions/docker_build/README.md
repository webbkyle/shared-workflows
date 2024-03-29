Docker Build
============

Description
-----------

This Github Action builds a Docker Image.

Inputs
------

| Input | Description | Required |
| --- | --- | --- |
| environment | Running Environment | true |
| system | System | true |
| sub_system | Sub_System | true |
| stack | Stack | true |
| dockerfile_path | Path of the Docker File | true |
| docker\_image\_tag | tag of the docker image | true |
| docker\_image\_name | name of the docker image | true |

Runs
----

The action uses a composite approach and consists of the following steps:

1.  Checkout of the Github repository.
2.  Build of the Docker image. The build is performed by running the `src/main.sh` script and passing the necessary inputs.

Outputs
-------

| Output | Description |
| --- | --- |
| docker\_image\_name | Name of the docker image |
| docker\_image\_tag | Tag of the docker image |
| docker\_image\_details | Details of the docker image |