Coturn TURN server Docker image
===============================

[![GitHub release](https://img.shields.io/github/release/instrumentisto/coturn-docker-image.svg)](https://hub.docker.com/r/instrumentisto/coturn/tags) [![Build Status](https://travis-ci.org/instrumentisto/coturn-docker-image.svg?branch=master)](https://travis-ci.org/instrumentisto/coturn-docker-image) [![Docker Pulls](https://img.shields.io/docker/pulls/instrumentisto/coturn.svg)](https://hub.docker.com/r/instrumentisto/coturn)




## What is Coturn TURN server?

The TURN Server is a VoIP media traffic NAT traversal server and gateway. It can be used as a general-purpose network traffic TURN server and gateway, too.

> [github.com/coturn/coturn](https://github.com/coturn/coturn)




## How to use this image

To run Coturn TURN server just start the container: 
```bash
docker run -d -p 3478:3478 -p 49152-65535:49152-65535/udp instrumentisto/coturn
```


### Why so many ports opened?

As per [RFC 5766 Section 6.2], these are the ports that the TURN server will use to exchange media.

You can change them with `min-port` and `max-port` Coturn configuration options:
```bash
docker run -d -p 3478:3478 -p 49160-49200:49160-49200/udp \
       instrumentisto/coturn -n --log-file=stdout \
                             --external-ip=$(detect-external-ip) \
                             --min-port=49160 --max-port=49200
```

Or just use host network directly(Recommended):
```bash
docker run -d --network=host instrumentisto/coturn
```


### Configuration

By default, default Coturn configuration and CLI options provided in `CMD` [Dockerfile] instruction are used.

1. You may either specify your own configuration file instead.

    ```bash
    docker run -d --network=host \
               -v $(pwd)/my.conf:/etc/coturn/turnserver.conf \
           instrumentisto/coturn
    ```

2. Or specify command line options directly.

    ```bash
    docker run -d --network=host instrumentisto/coturn \
               -n --log-file=stdout \
               --min-port=49160 --max-port=49200 \
               --lt-cred-mech --fingerprint \
               --no-multicast-peers --no-cli \
               --no-tlsv1 --no-tlsv1_1 \
               --realm=my.realm.org \  
    ```
    
3. Or even specify another configuration file.

    ```bash
    docker run -d --network=host  \
               -v $(pwd)/my.conf:/my/coturn.conf \
           instrumentisto/coturn -c /my/coturn.conf
    ```

#### Automatic detection of external IP

`detect-external-ip` binary may be used to automatically detect external IP of TURN server in runtime. It's okay to use it multiple times (the value will be evaluated only once).
```bash
docker run -d --network=host instrumentisto/coturn \
           -n --log-file=stdout \
           --external-ip=$(detect-external-ip) \
           --relay-ip=$(detect-external-ip)
```


### Persistence

By default, Coturn Docker image persists its data in `/var/lib/coturn` directory.

You can speedup Coturn simply by using tmpfs for that:
```bash
docker run -d --network=host --mount type=tmpfs,destination=/var/lib/coturn \
       instrumentisto/coturn
```




## Image versions

This image is based on the popular [Alpine Linux project][1], available in [the alpine official image][2]. Alpine Linux is much smaller than most distribution base images (~5MB), and thus leads to much slimmer images in general.

This variant is highly recommended when final image size being as small as possible is desired. The main caveat to note is that it does use [musl libc][4] instead of [glibc and friends][5], so certain software might run into issues depending on the depth of their libc requirements. However, most software doesn't have an issue with this, so this variant is usually a very safe choice. See [this Hacker News comment thread][6] for more discussion of the issues that might arise and some pro/con comparisons of using Alpine-based images.


### `X`

Latest version of `X` Coturn major version.


### `X.Y`

Latest version of `X.Y` Coturn minor version.


### `X.Y.Z`

Latest version of `X.Y.Z` Coturn version.


### `X.Y.Z.W`

Concrete `X.Y.Z.W` version of Coturn.




## License

Coturn itself is licensed under [this license][91].

Coturn Docker image is licensed under [MIT license][92].




## Issues

We can't notice comments in the DockerHub so don't use them for reporting issue or asking question.

If you have any problems with or questions about this image, please contact us through a [GitHub issue][3].





[1]: http://alpinelinux.org
[2]: https://hub.docker.com/_/alpine
[3]: https://github.com/instrumentisto/coturn-docker-image/issues
[4]: http://www.musl-libc.org
[5]: http://www.etalabs.net/compare_libcs.html
[6]: https://news.ycombinator.com/item?id=10782897
[91]: https://github.com/coturn/coturn/blob/master/LICENSE
[92]: https://github.com/instrumentisto/coturn-docker-image/blob/master/LICENSE.md

[Dockerfile]: https://github.com/instrumentisto/coturn-docker-image/blob/master/Dockerfile
[RFC 5766 Section 6.2]: https://tools.ietf.org/html/rfc5766.html#section-6.2
