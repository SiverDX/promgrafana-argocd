(import "ksonnet-util/kausal.libsonnet") +
(import "./config.libsonnet") +
{
  local deployment = $.apps.v1.deployment,
  local container = $.core.v1.container,
  local port = $.core.v1.containerPort,
  local service = $.core.v1.service,

  local config = $._config.promgrafana,

  promgrafana: {
    prometheus: {
      deployment: deployment.new(
        name = config.prometheus.name, replicas = 1,
        containers = [
          container.new(config.prometheus.name, $._images.promgrafana.prometheus)
          + container.withPorts([port.new("api", config.prometheus.port)]),
        ],
      ),
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
