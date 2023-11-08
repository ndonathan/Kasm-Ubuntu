#!/bin/bash

## Parse input ##
NAME=$(echo $1| awk -F'|' '{print $1}')
BASE=$(echo $1| awk -F'|' '{print $2}')
DOCKERFILE=$(echo $1| awk -F'|' '{print $3}')

# Determine if we are using private images
if [ ${USE_PRIVATE_IMAGES} -eq 1 ]; then
  BASE=${BASE}-private
fi

# Determine if this is a rolling build
if [ "${CI_PIPELINE_SOURCE}" == "schedule" ]; then
  BASE_TAG=${BASE_TAG}-rolling
fi

## Build/Push image to cache endpoint by pipeline ID ##
docker build \
  -t ${ORG_NAME}/image-cache-private:$(arch)-${NAME}-${SANITIZED_BRANCH}-${CI_PIPELINE_ID} \
  --build-arg BASE_IMAGE="${BASE}" \
  --build-arg BASE_TAG="${BASE_TAG}" \
  -f ${DOCKERFILE} .
docker push ${ORG_NAME}/image-cache-private:$(arch)-${NAME}-${SANITIZED_BRANCH}-${CI_PIPELINE_ID}
