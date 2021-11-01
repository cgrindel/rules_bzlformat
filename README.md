# Buildifier Rules for Bazel

This repository contains Bazel rules and macros that format Bazel Starlark files (e.g. `.bzl`,
`BUILD`, `BUILD.bazel`) using
[Buildifier](https://github.com/bazelbuild/buildtools/tree/master/buildifier), test that the
formatted files exist in the workspace directory, and copy the formatted files to the workspace
directory.

## Quickstart



## Add bzlformat_pkg to all packages using Buildozer

```sh

# Recommended by Buildozer doc
$ buildozer 'fix movePackageToTop' //...:__pkg__

# Add load statement to all of the packages.
$ buildozer 'new_load @cgrindel_rules_bzlformat//bzlformat:bzlformat.bzl bzlformat_pkg' //...:__pkg__

# Add the bzlformat_pkg() to all of the packages.
$ buildozer 'new bzlformat_pkg bzlformat' //...:__pkg__

```

