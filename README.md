# swarm-glue
A docker container that allows Docker swarms to be migrated between networks

## Basics
* swarm-glue is a container for the included "glue" script. With little to no modifications it will probably also work natively
* swarm-glue should run on every manager node in the swarm
* SSH keys are automatically generated and stored in a volume for each swarm-glue container. Through the Docker socket, the key is distributed to the root user of every other node in the swarm.
* When the IP addresses of the manager nodes change, the new IP's are discovered with mDNS/Avahi. Through the established SSH login, IPTables rules are automatically added to each node in order to redirect the old IP addresses to the new ones and resurrect the swarm.
* After the swarm is back online, the managers will leave and re-join one by one so Docker catches up with the changes
* No user interaction should be necessary after the initial deploy

## Requirements
* All host machines must run Avahi, in order to facilitate network discovery in their old environment, as well as the new
* An SSH server must be running and reachable on each host. Swarm-glue attempts to establish SSH login to each node in the network.
* Just like tools such as Portainer, swarm-glue must be allowed to freely access the Docker socket, which is used to establish distributed locks as well as for SSH key propagation
* Currently only tested on Debian Linux. Probably compatible with at least some derivatives

## **IMPORTANT**
* DEPLOY ON EVERY MANAGER NODE
* PLEASE TEST THIS THOROUGHLY BEFORE DEPLOYING IN ANY PRODUCTION ENVIRONMENT

## Deployment

### x86_64
```
docker run -d --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/run/dbus:/var/run/dbus \
  -v /run/avahi-daemon:/run/avahi-daemon \
  -v /var/run/systemd:/var/run/systemd \
  --hostname "$(hostname -s)" \
  -v swarm-glue:/mnt/data \
  --network host \
  --name swarm-glue \
  b01t/swarm-glue
```

### armhf
```
docker run -d --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/run/dbus:/var/run/dbus \
  -v /run/avahi-daemon:/run/avahi-daemon \
  -v /var/run/systemd:/var/run/systemd \
  --hostname "$(hostname -s)" \
  -v swarm-glue:/mnt/data \
  --network host \
  --name swarm-glue \
  b01t/swarm-glue:armhf
```
