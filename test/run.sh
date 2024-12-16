#!/usr/bin/env bash

headless=true
path=$(pwd)
pull_image=false

# image=robotframework
# version=latest
image=ghcr.io/marketsquare/robotframework-browser/rfbrowser-stable
version=19.1.1

help() {
		echo ""
    echo "Usage: ./run.sh [-p <path>] [--no-headless] [-h|--help]"
    echo ""
    echo "Options:"
    echo "  -p, --path <path>     Specify the directory containing the test suites."
    echo ""
    echo "  --no-headless         Run the tests in the browser (non-headless mode)."
    echo "                        Note: This requires a graphical environment."
    echo ""
    echo "  -P, --pull            Automatically pull docker image without asking for confirmatio."
    echo ""
    echo "  -h, --help            Display this help message."
    echo ""
    echo "Examples:"
    echo "  ./run.sh -p /path/to/tests          Run tests in headless mode (default)."
    echo "  ./run.sh -p /path/to/tests --no-headless"
    echo "                                      Run tests with a browser (non-headless)."
		echo ""
}

if [[ $# -eq 0 ]]
then
	help
	exit 1
fi

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
			help
    exit 0
    ;;
    -p|--path)
    path="$2"
    shift # argument
    shift # value
    ;;
		-P | --pull)
		pull_image=true
    shift # argument
		;;
    --no-headless)
    headless=false
    shift # argument
    ;;
    *)
			help
    exit 1
    ;;
esac
done

check_image() {
	if ! docker images --format "{{.Repository}}" | grep -q "^$image$"; then
		echo "Image $image not found."
		if (( $pull_image )); then
			docker pull $image:$version
		else
			echo "Would you like to pull it? [Y]es or [N]o"
			read -r answer 
			case $answer in 
				[Yy]) 
					docker pull $image 
					check_image
					;; 
				[Nn])
					exit 1 
					;; 
				*)
					echo "Invalid input. Please enter Y/y or N/n." 
					exit 1
					;; 
			esac
		fi
	fi
}

check_image

 docker run -it --rm \
	 -v $path:/home/pwuser/test_suites \
	 -w /home/pwuser/test_suites $image:$version robot \
		--variable HEADLESS:$headless .
