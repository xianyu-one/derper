# derper

Tailscale derper的容器化构建


## 使用方法

下面是一个`docker-compose`的示例

```yaml
version: '3'
services:
  derper:
    image: 'mrxianyu/derper:latest'
    restart: unless-stopped
    container_name: derper
    environment:
      DERP_DOMAIN: 'derper.xxx.com'
      DERP_ADDR: ':18001'
    ports:
      - 3478:3478/udp
      - 80:80
      - 18001:18001
    volumes:
      - ./derper/ssl:/app/certs
    networks:
      app_net:
        ipv4_address: 10.20.0.10

networks:
  app_net:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 10.20.0.0/24
          gateway: 10.20.0.1
```