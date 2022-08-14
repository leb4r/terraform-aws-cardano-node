---
version: "3.8"

services:
  cardano-node:
    image: ${cardano_node_image}:${cardano_node_version}
    container_name: cardano-node
    restart: unless-stopped
    ports:
      - ${cardano_node_port}:${cardano_node_port}
      - 12798:12798
      - 4444:4444
    volumes:
      - $CARDANO_ROOT/data:/opt/cardano/data
      - $CARDANO_ROOT/ipc:/opt/cardano/ipc
      - $CARDANO_ROOT/config/${cardano_network}-topology.json:/opt/cardano/config/${cardano_network}-topology.json
    environment:
      CARDANO_SOCKET_PATH: /opt/cardano/ipc/socket
      CARDANO_NODE_SOCKET_PATH: /opt/cardano/ipc/socket
      CARDANO_NETWORK: ${cardano_network}
      CARDANO_CONFIG: /opt/cardano/config/${cardano_network}-config.json
      CARDANO_TOPOLOGY: /opt/cardano/config/${cardano_network}-topology.json
      CARDANO_BIND_ADDR: "0.0.0.0"
      CARDANO_PORT: ${cardano_node_port}
    command:
      - run
    logging:
      driver: awslogs
      options:
        awslogs-group: ${log_group_name}
        awslogs-region: ${region}
