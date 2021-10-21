(import "prometheus_grafana/prometheus-grafana.libsonnet") +
{
  _images+:: {
    promgrafana: {
      prometheus: "prom/prometheus:v2.30.3",
      grafana: "grafana/grafana:8.2.2"
    }
  }
}
