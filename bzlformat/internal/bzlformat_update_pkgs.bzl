def bzlformat_update_pkgs():
    native.sh_binary(
        name = "bzlformat_find_missing_pkgs",
        srcs = ["@cgrindel_rules_bzlformat//scripts:find_missing_pkgs.sh"],
        deps = [
            "@bazel_tools//tools/bash/runfiles",
            "@cgrindel_bazel_shlib//lib:arrays",
        ],
    )

    native.sh_binary(
        name = "bzlformat_update_pkgs",
        srcs = ["@cgrindel_rules_bzlformat//scripts:update_pkgs.sh"],
        data = [
            # "@com_github_bazelbuild_buildtools//buildifier",
            "@com_github_bazelbuild_buildtools//buildozer",
            ":bzlformat_find_missing_pkgs",
        ],
        deps = [
            "@bazel_tools//tools/bash/runfiles",
            "@cgrindel_bazel_shlib//lib:arrays",
        ],
    )
