load("@cgrindel_bazel_starlib//lib:src_utils.bzl", "src_utils")
load(":bzlformat_format.bzl", "bzlformat_format")
load(
    "@cgrindel_rules_updatesrc//updatesrc:updatesrc.bzl",
    "updatesrc_update",
)
load("@bazel_skylib//rules:diff_test.bzl", "diff_test")

def bzlformat_pkg(name = None, srcs = None, include_update = True):
    if name == None:
        name = "bzlformat"

    if srcs == None:
        srcs = native.glob(["*.bzl", "BUILD", "BUILD.bazel"])

    # Only process paths; ignore labels
    src_paths = [src for src in srcs if src_utils.is_path(src)]

    name_prefix = name + "_"
    format_names = []
    for src in src_paths:
        src_name = src.replace("/", "_")
        format_name = name_prefix + src_name + "_fmt"
        format_names.append(":" + format_name)

        bzlformat_format(
            name = format_name,
            srcs = [src],
        )
        diff_test(
            name = name_prefix + src_name + "_fmttest",
            file1 = src,
            file2 = ":" + format_name,
        )

    if include_update:
        updatesrc_update(
            name = name + "_update",
            deps = format_names,
        )
