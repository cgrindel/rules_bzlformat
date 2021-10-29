load("@bazel_skylib//lib:paths.bzl", "paths")
load(
    "@cgrindel_rules_updatesrc//updatesrc:updatesrc.bzl",
    "UpdateSrcsInfo",
    "update_srcs",
)

def _bzlformat_format_impl(ctx):
    updsrcs = []
    for src in ctx.files.srcs:
        out = ctx.actions.declare_file(src.basename + ctx.attr.output_suffix)
        updsrcs.append(update_srcs.create(src = src, out = out))
        inputs = [src]

        args = ctx.actions.args()
        args.add_all([
        ])
        ctx.actions.run(
            outputs = [out],
            inputs = inputs,
            executable = ctx.executable._buildifier,
            arguments = [args],
        )

    return [
        DefaultInfo(files = depset([updsrc.out for updsrc in updsrcs])),
        UpdateSrcsInfo(update_srcs = depset(updsrcs)),
    ]

bzlformat_format = rule(
    implementation = _bzlformat_format_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
            doc = "The Starlark source files to format.",
        ),
        "_buildifier": attr.label(
            default = "@com_github_bazelbuild_buildtools//buildifier",
            executable = True,
            cfg = "host",
            allow_files = True,
            doc = "The `buildifier` executable.",
        ),
    },
    doc = "Formats Starlark source files using buildifier.",
)
