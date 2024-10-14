export YTT_GENERATED_OTEL_CONFIG_OUTPUT=`ytt -f /etc/otelcol-contrib/config.yaml \
--data-value-yaml otel_ecs_container_metrics_disabled=$OTEL_ECS_CONTAINER_METRICS_DISABLED \
--data-value otel_exporter_otlp_endpoint=$OTEL_EXPORTER_OTLP_ENDPOINT \
--data-value-yaml processor_resource_service_name_disabled=$PROCESSOR_RESOURCE_SERVICE_NAME_DISABLED \
`

if [ "$DEBUG_GENERATED_OTEL_CONFIG" = true ]; then
  echo "$YTT_GENERATED_OTEL_CONFIG_OUTPUT"
fi

if [ -n "$MERGED_OTEL_CONFIG" ]; then
  echo "Using MERGED_OTEL_CONFIG"
  /otelcol-contrib --config=env:YTT_GENERATED_OTEL_CONFIG_OUTPUT --config=env:MERGED_OTEL_CONFIG
else
  /otelcol-contrib --config=env:YTT_GENERATED_OTEL_CONFIG_OUTPUT
fi
