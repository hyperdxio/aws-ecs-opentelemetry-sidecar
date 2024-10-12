# Development Notes

## Building

```
docker build .
```

## Running

With a few flags for example:

```
docker run \
  -e DEBUG_GENERATED_OTEL_CONFIG=true \
  -e PROCESSOR_RESOURCE_SERVICE_NAME_DISABLED=true \
  -e OTEL_ECS_CONTAINER_METRICS_DISABLED=true \
  -e CUSTOM_OTEL_CONFIG='{"processors":{"resource":{"attributes":{"service.name":"my_service"}}}}' \
  <image_here>
```

## Adding New Variables

If adding a new boolean flag, make sure to use `--data-value-yaml` over
`--data-value` to ensure the value is correctly interpreted as a boolean.

All values are mapped into `ytt` via `entry.sh`. Use
`DEBUG_GENERATED_OTEL_CONFIG` to debug the `ytt` output.

`ytt`, the template generator, can be installed locally on Mac via Brew
([ref](https://github.com/carvel-dev/homebrew/tree/develop?tab=readme-ov-file)):

```
brew tap carvel-dev/carvel
brew install ytt
```
