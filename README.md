
# link checker docker machine

With **one simple docker run statement** you can link check any website, git repository or wiki.

## robots.txt | link check pre-conditions

Before running the linkchecker ensure that a **robots.txt** file exists at the website root otherwise link checking will not happen (to prevent abuse of the link checker).

Follow **[instructions here](https://www.robotstxt.org/robotstxt.html)** configure robots.txt to accept just some robots (like Google) or allow link checking from a sub location tree.

```
User-agent: *
Disallow:
```

## how to run the link checker

Let the **[devopswiki.co.uk](https://www.devopswiki.co.uk)** website be the guinea pig to link check.

```
docker run \
    --network host \
    --env LINK_CHECKER_SITE_URL=http://10.152.183.167/ \
    img.linkchecker:latest

docker run \
    --detach \
    --network host \
    --name vm.linkchecker \
    devops4me/linkchecker


docker logs vm.linkchecker
```

You can link check other websites with the below statements.

```
linkchecker https://dzone.com/articles/kafka-producer-and-consumer-example
linkchecker https://www.devopswiki.co.uk/wiki/openvpn/openvpn
linkchecker https://devopswiki.co.uk/Home
```


## docker build | linkchecker

For development, you may want to build the **linkchecker docker image locally** and then `docker run` the just-built image.

```
git clone https://github.com/devops4me/docker-linkchecker
cd docker-linkchecker
docker build --no-cache --rm --tag img.linkchecker .
docker exec               \
    --interactive         \
    --tty         \
    --tag img.linkchecker \
    linkchecker http://10.152.183.167/
docker logs vm.linkchecker
```
    --name vm.linkchecker \
    --network host        \

## Link Checker Configuration

The [linkcheckerrc configuration file](linkcheckerrc) is placed in the .linkchecker folder off the home directory and drives the primary checking behaviour.