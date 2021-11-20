load("@cgrindel_bazel_shlib//rules:execute_binary.bzl", "execute_binary")

def bzlformat_update_pkgs(name = "bzlformat_pkgs", exclude = []):
    exclude_args = []
    for pkg in exclude:
        exclude_args.extend(["--exclude", pkg])

    find_missing_name = name + "_find_missing"
    update_name = name + "_update_missing"

    execute_binary(
        name = find_missing_name,
        binary = "@cgrindel_rules_bzlformat//scripts:find_missing_pkgs",
        args = exclude_args,
    )

    execute_binary(
        name = name + "_update_missing",
        binary = "@cgrindel_rules_bzlformat//scripts:update_pkgs",
        args = exclude_args,
    )

    # native.sh_binary(
    #     name = "bzlformat_find_missing_pkgs",
    #     srcs = ["@cgrindel_rules_bzlformat//scripts:find_missing_pkgs.sh"],
    #     deps = [
    #         "@bazel_tools//tools/bash/runfiles",
    #         "@cgrindel_bazel_shlib//lib:arrays",
    #     ],
    # )

    # native.sh_binary(
    #     name = "bzlformat_update_pkgs",
    #     srcs = ["@cgrindel_rules_bzlformat//scripts:update_pkgs.sh"],
    #     data = [
    #         # "@com_github_bazelbuild_buildtools//buildifier",
    #         "@com_github_bazelbuild_buildtools//buildozer",
    #         ":bzlformat_find_missing_pkgs",
    #     ],
    #     deps = [
    #         "@bazel_tools//tools/bash/runfiles",
    #         "@cgrindel_bazel_shlib//lib:arrays",
    #     ],
    # )
