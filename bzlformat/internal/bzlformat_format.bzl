load("@bazel_skylib//lib:paths.bzl", "paths")
load(
    "@cgrindel_rules_updatesrc//updatesrc:updatesrc.bzl",
    "UpdateSrcsInfo",
    "update_srcs",
)

def _bzlformat_format_impl(ctx):
    pass

bzlformat_format = rule(
    implementation = _bzlformat_format_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
            doc = "The Starlark source files to format.",
        ),
        "_buildifier": attr.label(
            default = "@cgrindel_rules_bzlformat//bzlformat:buildifier",
            executable = True,
            cfg = "host",
            allow_files = True,
            doc = "The `buildifier` executable.",
        ),
    },
    doc = "Formats Starlark source files using buildifier.",
)
