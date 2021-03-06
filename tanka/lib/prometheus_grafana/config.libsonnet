{
  _config+:: {
    promgrafana: {
      grafana: {
        port: 3000,
        name: "grafana",
      },
      prometheus: {
        port: 9090,
        name: "prometheus"
      }
    }
  },

  _configDataYAML:: {},

  _mounts:: {
    configMapMount: "/prometheus-config"
  },

  _configPath:: "",

  _images+:: {
    promgrafana: {
      grafana: "grafana/grafana",
      prometheus: "prom/prometheus",
    }
  }
}
