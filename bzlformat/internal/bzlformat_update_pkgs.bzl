def bzlformat_update_pkgs(name = "bzlformat_update_pkgs"):
    native.sh_binary(
        name = name,
        srcs = [
            "@cgrindel_rules_bzlformat//scripts:update_pkgs.sh",
        ],
        deps = [
            "@bazel_tools//tools/bash/runfiles",
            "@cgrindel_bazel_shlib//lib:arrays",
        ],
    )
