export YTT_GENERATED_OTEL_CONFIG_OUTPUT=`ytt -f /etc/otelcol-contrib/config.yaml --data-value-yaml otel_ecs_container_metrics_disabled=$OTEL_ECS_CONTAINER_METRICS_DISABLED --data-value otel_exporter_otlp_endpoint=$OTEL_EXPORTER_OTLP_ENDPOINT`

if [ "$DEBUG_GENERATED_OTEL_CONFIG" = true ]; then
  echo "$YTT_GENERATED_OTEL_CONFIG_OUTPUT"
fi

/otelcol-contrib --config=env:YTT_GENERATED_OTEL_CONFIG_OUTPUT
