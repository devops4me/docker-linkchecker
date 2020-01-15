
# link checker docker machine

This docker machine will link check any local or public website, git repository and wiki all with a simple docker run statement. You can also place it within a CI (Continuous Integration) pipeline, to ensure a quality bar is always exceeded.

By default everything is checked including images, css files, favicons, downloadable files and even external websites. You can configure the crawl depth within the source website.

The results can be viewed in HTML, JSON, YAML and XML formats.

## how to run the link checker

Let the **[devopswiki.co.uk](https://www.devopswiki.co.uk)** website be the guinea pig to link check.

```
docker run \
    --detach \
    --network host \
    --name vm.linkchecker \
    devops4me/linkchecker
docker logs vm.linkchecker
```

Just one command and the website links are thoroughly checked. Simple as pie.


## docker build | linkchecker

For development, you may want to build the **linkchecker docker image locally** and then `docker run` the just-built image.

```
git clone https://github.com/devops4me/docker-linkchecker
cd docker-linkchecker
docker build --no-cache --rm --tag img.linkchecker .
docker run                \
    --network host        \
    --name vm.linkchecker \
    img.linkchecker
docker logs vm.linkchecker
```
