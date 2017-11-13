setup_all() # to compose all the services
{
	cd ../../..

	#Build all the modules
	mvn clean package
	# Enter docker-compose folder

	cd docker/

	# Deploy
	docker-compose up -d

}


setup_service() # to recompose a specific service
{
	echo "Stopping container $1"
	docker stop $1

	echo "Removing previous $1 container"
	docker rm  $1

	echo "Removing previous $1 image"
	docker rmi docker_$1

	#setting up docker for service
	#build_up
	service_name=$1-microservice
	cd ../../../$service_name

	mvn clean package

	cd ../docker

	docker-compose build $1

	docker-compose up -d
}

usage_info()
{
echo "
Usage

	1) deploy.sh -p <profile_name>				: To deploy all images and containers of a docker profile
										for e.x deploy.sh -p docker
	2) deploy.sh -p <profile_name> -i <service name> 	: To stop, remove, build & deploy a specific image/service
										for e.x deploy.sh -p docker -i tracker-ui"
exit 1
}

if [ $# == 0 ]; then
	usage_info
else
	flag1=0
	flag2=0
	function flag_1()
	{
		flag1=$((flag1+1))
	}
	function flag_2()
	{
		flag2=$((flag2+1))
	}


	while getopts ":p:i:" opt; do
		case ${opt} in
			p)
				if [ ${OPTARG} == "docker" ]; then
					export profile=$(OPTARG)
					flag_1
				else
					echo "Option -$OPTARG requires an argument."
				fi
			;;
			i)
				service="$OPTARG"
				flag_2
			;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				exit 1
			;;
			:)
				echo "Option -$OPTARG requires an argument." >&2
				exit 1
			;;
		esac

	done
	if [ $flag1 == 1 ] && [ $flag2 == 1 ]; then
		case ${service} in
			[service_1])
				setup_service $service
				;;
			[service_2])
				setup_service $service
				;;
			[service_3])
				setup_service $service
				;;
			# you may use an array if you have a lot of services
			*)
				echo "This Container cannot be modified"
				exit 1
				""
		esac
		exit 1

	elif [ $flag1 == 1 ]; then
		setup_all
		exit 1

	else
		usage_info
	fi
fi
