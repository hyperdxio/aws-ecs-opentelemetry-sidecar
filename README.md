# AWS ECS OpenTelemetry Sidecar

This repository contains a Docker image that can be used as a sidecar container
in an AWS ECS task definition to collect metrics and logs from the application
container. The sidecar container runs an OpenTelemetry collector that collects
ECS task and container metrics and logs via Firelens from the application
container and sends them to [HyperDX](https://hyperdx.io) or another 
OpenTelemetry collector endpoint.

## Usage

To use this sidecar container in an ECS task definition, you'll need to create a
new task definition with two containers: the application container and the
OpenTelemetry sidecar container. The application container should be configured
to use the `awsfirelens` log driver to forward the logs to the sidecar.

Task definition example:

```json
{
  "family": "firelens-example-otel",
  "containerDefinitions": [
    {
      "name": "app",
      "image": "chentex/random-logger:latest",
      "essential": true,
      "logConfiguration": {
        "logDriver": "awsfirelens"
      }
    },
    {
      "name": "otel-sidecar",
      "image": "public.ecr.aws/h9w3r7r7/aws-ecs-opentelemetry-sidecar:latest",
      "essential": true,
      "environment": [
        {
          "name": "HYPERDX_API_KEY",
          "value": "YOUR_HYPERDX_API_KEY"
        }
      ],
      "firelensConfiguration": {
        "type": "fluentbit"
      }
    }
  ],
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "512",
  "memory": "1024"
}
```

View the `examples` folder for more task definition examples and configuration
options.

## Configuration

You'll need to set the `HYPERDX_API_KEY` environment variable in the sidecar
container to your HyperDX API key. You can get an API key by signing up for an
account at [HyperDX](https://hyperdx.io).

By default, the `service.name` is populated by the ECS task definition family
name, but this can be overridden by setting the
`OTEL_RESOURCE_ATTRIBUTES="service.name=my_service"`.

To disable the collection of ECS metrics, set the
`OTEL_ECS_CONTAINER_METRICS_DISABLED` environment variable to `true`.

To disable the collection of ECS logs, ensure that the `awsfirelens` log driver
is not set on the application container.

To send to a different OpenTelemetry endpoint or collector, set the
`OTEL_EXPORTER_OTLP_ENDPOINT` environment variable to the desired endpoint.

To debug the generated configuration, set the `DEBUG_GENERATED_OTEL_CONFIG`
environment variable to `true`.

## Collected ECS Metrics

The OpenTelemetry collector in the sidecar container collects the following
metrics from the ECS task and container via the
[`awsecscontainermetrics` receiver](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/awsecscontainermetricsreceiver/README.md)
at a 1 minute interval:

| Task Level Metrics                   | Container Level Metrics               | Unit         |
| ------------------------------------ | ------------------------------------- | ------------ |
| ecs.task.memory.usage                | container.memory.usage                | Bytes        |
| ecs.task.memory.usage.max            | container.memory.usage.max            | Bytes        |
| ecs.task.memory.usage.limit          | container.memory.usage.limit          | Bytes        |
| ecs.task.memory.reserved             | container.memory.reserved             | Megabytes    |
| ecs.task.memory.utilized             | container.memory.utilized             | Megabytes    |
| ecs.task.cpu.usage.total             | container.cpu.usage.total             | Nanoseconds  |
| ecs.task.cpu.usage.kernelmode        | container.cpu.usage.kernelmode        | Nanoseconds  |
| ecs.task.cpu.usage.usermode          | container.cpu.usage.usermode          | Nanoseconds  |
| ecs.task.cpu.usage.system            | container.cpu.usage.system            | Nanoseconds  |
| ecs.task.cpu.usage.vcpu              | container.cpu.usage.vcpu              | vCPU         |
| ecs.task.cpu.cores                   | container.cpu.cores                   | Count        |
| ecs.task.cpu.onlines                 | container.cpu.onlines                 | Count        |
| ecs.task.cpu.reserved                | container.cpu.reserved                | vCPU         |
| ecs.task.cpu.utilized                | container.cpu.utilized                | Percent      |
| ecs.task.network.rate.rx             | container.network.rate.rx             | Bytes/Second |
| ecs.task.network.rate.tx             | container.network.rate.tx             | Bytes/Second |
| ecs.task.network.io.usage.rx_bytes   | container.network.io.usage.rx_bytes   | Bytes        |
| ecs.task.network.io.usage.rx_packets | container.network.io.usage.rx_packets | Count        |
| ecs.task.network.io.usage.rx_errors  | container.network.io.usage.rx_errors  | Count        |
| ecs.task.network.io.usage.rx_dropped | container.network.io.usage.rx_dropped | Count        |
| ecs.task.network.io.usage.tx_bytes   | container.network.io.usage.tx_bytes   | Bytes        |
| ecs.task.network.io.usage.tx_packets | container.network.io.usage.tx_packets | Count        |
| ecs.task.network.io.usage.tx_errors  | container.network.io.usage.tx_errors  | Count        |
| ecs.task.network.io.usage.tx_dropped | container.network.io.usage.tx_dropped | Count        |
| ecs.task.storage.read_bytes          | container.storage.read_bytes          | Bytes        |
| ecs.task.storage.write_bytes         | container.storage.write_bytes         | Bytes        |

### Thanks

Thanks to
[project0/aws-ecs-firelens-opentelemetry](https://github.com/project0/aws-ecs-firelens-opentelemetry)
for sharing their ECS Firelens configuration for OpenTelemetry that formed the
basis of the Firelens configuration in this repository.
