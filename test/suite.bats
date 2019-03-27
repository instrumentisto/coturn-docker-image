#!/usr/bin/env bats


@test "post_push hook is up-to-date" {
  run sh -c "cat Makefile | grep 'TAGS ?= ' | cut -d ' ' -f 3"
  [ "$status" -eq 0 ]
  [ ! "$output" = '' ]
  expected="$output"

  run sh -c "cat hooks/post_push | grep 'for tag in' \
                                 | cut -d '{' -f 2 \
                                 | cut -d '}' -f 1"
  [ "$status" -eq 0 ]
  [ ! "$output" = '' ]
  actual="$output"

  [ "$actual" = "$expected" ]
}


@test "Coturn is installed" {
  run docker run --rm --entrypoint sh $IMAGE -c 'which turnserver'
  [ "$status" -eq 0 ]
}

@test "Coturn runs ok" {
  run docker run --rm --entrypoint sh $IMAGE -c 'turnserver -h'
  [ "$status" -eq 0 ]
}

# TODO(#2): check on new version
@test "Coturn has correct version" {
  run sh -c "cat Makefile | grep 'VERSION ?= ' | cut -d ' ' -f 3"
  [ "$status" -eq 0 ]
  [ ! "$output" = '' ]
  expected="$output"

  run docker run --rm --entrypoint sh $IMAGE -c \
    "turnserver -o | grep 'Version Coturn' | cut -d ' ' -f2 \
                                           | cut -d '-' -f2"
  [ "$status" -eq 0 ]
  [ ! "$output" = '' ]
  actual="$output"


  [ "$actual" = "$expected" ]
}
