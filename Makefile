BUILD_PLATFORMS = linux/arm64,linux/amd64
TAG = 1.0.0
REPO = public.ecr.aws/hyperdx
IMAGE_NAME = aws-ecs-opentelemetry-sidecar

.PHONY: build
build:
	docker build -t ${IMAGE_NAME} .

.PHONY: release
release:
	docker buildx build \
		--platform ${BUILD_PLATFORMS} \
		-t ${REPO}/${IMAGE_NAME}:${TAG} \
		-t ${REPO}/${IMAGE_NAME}:latest \
		. --push

