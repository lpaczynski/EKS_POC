resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-hello-world"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx-hello-world"
      }
    }

    template {
      metadata {
        labels = merge(
          {
            app = "nginx-hello-world"
          },
          local.tags
        )
      }

      spec {
        container {
          image = "nginx"
          name  = "nginx-hello-world"

          port {
            container_port = 80
          }

          env {
            name  = "MESSAGE"
            value = "hello world"
          }

          command = ["/bin/sh", "-c", "echo $MESSAGE | nc -l -p 80"]
        }
        node_selector = {
          role = "worker"
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-hello-world-service"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"            = "external"
      "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
    }
  }

  spec {
    selector = {
      app = "nginx-hello-world"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}