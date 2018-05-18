Coturn TURN server Docker image
===============================

[![GitHub release](https://img.shields.io/github/release/instrumentisto/coturn-docker-image.svg)](https://hub.docker.com/r/instrumentisto/coturn/tags) [![Build Status](https://travis-ci.org/instrumentisto/coturn-docker-image.svg?branch=master)](https://travis-ci.org/instrumentisto/coturn-docker-image) [![Docker Pulls](https://img.shields.io/docker/pulls/instrumentisto/coturn.svg)](https://hub.docker.com/r/instrumentisto/coturn)




## What is Coturn TURN server?

The TURN Server is a VoIP media traffic NAT traversal server and gateway. It can be used as a general-purpose network traffic TURN server and gateway, too.

> [github.com/coturn/coturn](https://github.com/coturn/coturn)




## How to use this image

To run Coturn TURN server just start the container: 
```bash
docker run -d instrumentisto/coturn
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
