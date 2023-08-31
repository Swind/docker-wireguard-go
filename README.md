# Usage
```
docker run -it --rm \
--privileged \
-v $(pwd)/wg0.conf:/etc/wireguard/wg0.conf \
ghcr.io/swind/docker-wireguard-go:main \
bash
```

# Reference
[wireguard-go](https://github.com/WireGuard/wireguard-go)

[masipcat/wireguard-go-docker](https://github.com/masipcat/wireguard-go-docker/)
