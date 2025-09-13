# Docker

- `docker`, `docker-compose` packages available in `pacman`

## Remarks

Docker daemon **NEEDS TO BE RUNNING**
- up through `docker.service` in `systemctl` (status, enable, start)
- **Important:** user must be in `docker` group for the service to be enabled and started
  - through `sudo usermod -aG docker username`
- could also need inside `/etc/docker/daemon.js` this:
```json
{
  ['8.8.8.8', '8.8.4.4']
}
```


