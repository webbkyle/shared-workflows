# Docker Image Pusher

A bash script that tags and pushes a Docker image to a specified repository.

## Requirements

-   Docker must be installed on the system

## Usage

The script can be run by executing the following command in the terminal:

phpCopy code

`./scriptname.sh -n <image_name> -t <image_tag> -r <repository_url> -u <repo_username> -p <repo_password>` 

The script takes the following named command line arguments:

-   `-n`: The name of the Docker image.
-   `-t`: The tag of the Docker image.
-   `-r`: The URL of the repository where the image will be pushed.
-   `-u`: (Optional) The username of the repository.
-   `-p`: The password of the repository.

The script will then log into the specified repository, tag the image with the specified name and tag, and push the image to the repository.

## Example

bashCopy code

`./scriptname.sh -n myimage -t latest -r https://myrepo.com -u myusername -p mypassword`