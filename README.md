# Buildifier Rules for Bazel

This repository contains Bazel rules and macros that format Bazel Starlark files (e.g. `.bzl`,
`BUILD`, `BUILD.bazel`) using
[Buildifier](https://github.com/bazelbuild/buildtools/tree/master/buildifier), test that the
formatted files exist in the workspace directory, and copy the formatted files to the workspace
directory.

## Quickstart

The following provides a quick introduction on how to use the rules in this repository. Also, check
out [the documentation](/doc/) and [the examples](/examples/) for more information.

### 1. Configure your workspace to use `rules_bzlformat`

Add the following to your `WORKSPACE` file to add this repository and its dependencies.

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "cgrindel_rules_bzlformat",
    sha256 = "",
    strip_prefix = "rules_bzlformat-0.1.0",
    urls = ["https://github.com/cgrindel/rules_bzlformat/archive/v0.1.0.tar.gz"],
)

load("@cgrindel_rules_bzlformat//bzlformat:deps.bzl", "bzlformat_rules_dependencies")

bzlformat_rules_dependencies()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

load("@cgrindel_bazel_starlib//:deps.bzl", "bazel_starlib_dependencies")

bazel_starlib_dependencies()

load("@cgrindel_rules_updatesrc//updatesrc:deps.bzl", "updatesrc_rules_dependencies")

updatesrc_rules_dependencies()

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains(version = "1.17.2")

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()
```

### 2. Update the `BUILD.bazel` at the root of your workspace

At the root of your workspace, create a `BUILD.bazel` file, if you don't have one. Add the
following:

```python
load(
    "@cgrindel_rules_updatesrc//updatesrc:updatesrc.bzl",
    "updatesrc_update_all",
)

# Define a runnable target to copy all of the formatted files to the workspace directory.
updatesrc_update_all(
    name = "update_all",
)
```

The
[`updatesrc_update_all`](https://github.com/cgrindel/rules_updatesrc/blob/main/doc/rules_and_macros_overview.md#updatesrc_update_all)
macro defines a runnable target that copies all of the formatted Swift source files to the workspace
directory.


```python
load(
    "@cgrindel_rules_updatesrc//updatesrc:updatesrc.bzl",
    "updatesrc_update_all",
)

updatesrc_update_all(name = "update_all")
```

### 3. Add `bzlformat_pkg` to every Bazel package

In every Bazel package, add a [`bzlformat_pkg`](/doc/rules_and_macros_overview.md#bzlformat_pkg)
declaration.

```python
load(
    "@cgrindel_rules_bzlformat//bzlformat:bzlformat.bzl",
    "bzlformat_pkg",
)

bzlformat_pkg(
    name = "bzlformat",
)
```

The [`bzlformat_pkg`](/doc/rules_and_macros_overview.md#bzlformat_pkg) macro defines targets for a
Bazel package which will format the Starlark source files, test that the formatted files are in the
workspace directory and copies the formatted files to the workspace directory.

A quick way to update all of your Bazel packages is to use
[Buildozer](https://github.com/bazelbuild/buildtools/blob/master/buildozer/README.md). The following
will add the `bzlformat_pkg` load statements and declarations:

```sh
# 
$ buildozer \
  'new_load @cgrindel_rules_bzlformat//bzlformat:bzlformat.bzl bzlformat_pkg' \
  'new bzlformat_pkg bzlformat' \
  //...:__pkg__
```

### 4. Format, Update, and Test

From the command-line, you can format the Starlark source files, copy them back to the workspace
directory and execute the tests that ensure the formatted soures are in the workspace directory.

```sh
# Format the Starlark source files and copy the formatted files back to the workspace directory
$ bazel run //:update_all

# Execute all of your tests including the formatting checks
$ bazel test //...
```
