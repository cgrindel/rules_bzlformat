# Buildifier Rules for Bazel

This repository contains Bazel rules and macros that format Bazel Starlark files (e.g. `.bzl`,
`BUILD`, `BUILD.bazel`) using
[Buildifier](https://github.com/bazelbuild/buildtools/tree/master/buildifier), test that the
formatted files exist in the workspace directory, and copy the formatted files to the workspace
directory.

## Quickstart

