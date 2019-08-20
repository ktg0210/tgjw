deploy.sh
# 0. Edit Options
# 1. Build docker images and push to ECR
# 2. Create Task Definitions (ecs-task-definition.conf)
# 3. Update Service

echo `pwd`

# Edit Below Options
DATE=$(date '+%Y-%m-%d-%H-%M-%S')
echo $DATE
ECR_URL="xxxxxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com"
DOCKER_IMAGE_NAME="hodoo"
EXCUTE_ROLE_ARN="arn:aws:iam::551661122454:role\/ecsTaskExecutionRole"

DIR="$( cd "$( dirname "$0" )" && pwd )"
TASK_DEF_NAME="task_def"
TASK_DEF_CONF="ecs-task-definition.conf"

CLUSTER_NAME="cluster"
SERVICE_NAME="service"
SERVICE_CONF="ecs-service.conf"

MINIMUM_HEALTHY_PERCENT=100
MAXIMUM_PERCENT=200
SUBNETS='"subnet-xxxxxxxxxx","subnet-xxxxxxxxxx"'
SECURITY_GROUPS='"sg-xxxxxxx"'

DESIRED_COUNT=2
# ecr login
$(aws ecr get-login --no-include-email --region ap-northeast-1) && \
# docker build
docker build -t ${DOCKER_IMAGE_NAME}:${DATE} . && \
# docker tagging
docker tag ${DOCKER_IMAGE_NAME}:${DATE} ${ECR_URL}/${DOCKER_IMAGE_NAME}:latest&& \
# dockdr push
docker push ${ECR_URL}/${DOCKER_IMAGE_NAME}:latest && \
# add date to task def conf
cp ${TASK_DEF_CONF} ${TASK_DEF_CONF}-${DATE} && \
# task def conf modify
sed -i -e "s/EXCUTE_ROLE_ARN/${EXCUTE_ROLE_ARN}/g" ${TASK_DEF_CONF}-${DATE} && \
# task def conf modify
sed -i -e "s/DOCKER_IMAGE_NAME/${ECR_URL}\/${DOCKER_IMAGE_NAME}:latest/g" ${TASK_DEF_CONF}-${DATE} && \
# task def conf modify
sed -i -e "s/TASK_DEF_NAME/${TASK_DEF_NAME}/g" ${TASK_DEF_CONF}-${DATE} && \

# task def register
aws ecs register-task-definition --family ${TASK_DEF_NAME} --cli-input-json file://${DIR}/${TASK_DEF_CONF}-${DATE} && \

# delete date from task def conf
rm -f ${TASK_DEF_CONF}-${DATE} && \

# wait 10 sec
sleep 10 && \

# add date to serv conf
cp ${SERVICE_CONF} ${SERVICE_CONF}-${DATE} && \
# serv conf modify
sed -i -e "s/CLUSTER_NAME/${CLUSTER_NAME}/g" ${SERVICE_CONF}-${DATE} && \
# serv conf modify
sed -i -e "s/SERVICE_NAME/${SERVICE_NAME}/g" ${SERVICE_CONF}-${DATE} && \
# serv conf modify
sed -i -e "s/DESIRED_COUNT/${DESIRED_COUNT}/g" ${SERVICE_CONF}-${DATE} && \
# serv conf modify
sed -i -e "s/TASK_DEF_NAME/${TASK_DEF_NAME}/g" ${SERVICE_CONF}-${DATE} && \
# serv conf modify
sed -i -e "s/SUBNETS/${SUBNETS}/g" ${SERVICE_CONF}-${DATE} && \
# serv conf modify
sed -i -e "s/SECURITY_GROUPS/${SECURITY_GROUPS}/g" ${SERVICE_CONF}-${DATE} && \
# serv conf modify
sed -i -e "s/MAXIMUM_PERCENT/${MAXIMUM_PERCENT}/g" ${SERVICE_CONF}-${DATE} && \
# serv conf modify
sed -i -e "s/MINIMUM_HEALTHY_PERCENT/${MINIMUM_HEALTHY_PERCENT}/g" ${SERVICE_CONF}-${DATE} && \

# serv update
aws ecs update-service --cli-input-json file://${DIR}/${SERVICE_CONF}-${DATE}

# delete date from serv conf
rm -f ${SERVICE_CONF}-${DATE}
