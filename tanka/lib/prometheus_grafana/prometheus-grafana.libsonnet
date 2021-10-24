(import "ksonnet-util/kausal.libsonnet") +
(import "./config.libsonnet") +
{
  local deployment = $.apps.v1.deployment,
  local container = $.core.v1.container,
  local port = $.core.v1.containerPort,
  local service = $.core.v1.service,
  local configMap = $.core.v1.configMap,

  local config = $._config.promgrafana,

  configData:: $._configDataYAML,

  configMap: configMap.new("prometheus-config") +
             configMap.withData($.configData),

  promgrafana: {
    prometheus: {
      deployment: deployment.new(
        name = config.prometheus.name, replicas = 1,
        containers = [
          container.new(config.prometheus.name, $._images.promgrafana.prometheus)
          + container.withPorts([port.new("api", config.prometheus.port)])
          + container.withArgs($._configPath),
        ],
      ) + $.util.configMapVolumeMount($.configMap, $._mounts.configMapMount),
      service: $.util.serviceFor(self.deployment),
    },

    grafana: {
      deployment: deployment.new(
        name = config.grafana.name, replicas = 1,
        containers = [
          container.new(config.grafana.name, $._images.promgrafana.grafana)
          + container.withPorts([port.new("ui", config.grafana.port)]),
        ],
      ),
      service: $.util.serviceFor(self.deployment) + service.mixin.spec.withType("NodePort"),
    }
  }
}
