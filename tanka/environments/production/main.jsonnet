(import "prometheus_grafana/prometheus-grafana.libsonnet") +
{
  _configDataYAML:: {
    "prometheus-config.yaml": std.manifestYamlDoc({
      global: {
        scrape_interval: "15s",
        evaluation_interval: "15s",

      scrape_configs: [
        {
          job_name: "prometheus",
          scrape_interval: "5s",
          static_configs: { targets: ["localhost:9090"] }
        },
        {
          job_name: "grafana",
          static_configs: { targets: ["10.105.99.115:3000"] }
        },
        {
          job_name: "argocd",
          static_configs: { targets: ["10.106.49.6:80"] }
        }
      ]
      }
    })
  },

  _mounts+:: {
    configMapMount: "/prometheus-config"
  },

  _configPath:: "--config.file=" + $._mounts.configMapMount + "/prometheus-config.yaml",

  _images+:: {
    promgrafana: {
      prometheus: "prom/prometheus:v2.30.3",
      grafana: "grafana/grafana:8.2.2"
    }
  }
}
