#!/usr/bin/env bash

headless=true
path=$(pwd)
image=robotframework

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

		# echo "Would you like to pull it or build it?"
		# select yn in "[P]ull" "[B]uild"; do
		# 	case $yn in
		# 		P ) docker pull $image; break;;
		# 		B ) docker build -t $image .; break;;
		# 	esac
		# done
	fi
}

check_image

 docker run -it --rm \
	 -v $path:/home/pwuser/test_suites \
	 -w /home/pwuser/test_suites robotframework:latest robot \
		--variable HEADLESS:$headless .
