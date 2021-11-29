load("@cgrindel_bazel_shlib//rules:execute_binary.bzl", "execute_binary")

def bzlformat_missing_pkgs(name, exclude = []):
    exclude_args = []
    for pkg in exclude:
        exclude_args.extend(["--exclude", pkg])

    find_missing_name = name + "_find"
    test_missing_name = name + "_test"
    update_name = name + "_update"

    execute_binary(
        name = find_missing_name,
        binary = "@cgrindel_rules_bzlformat//tools/missing_pkgs:find",
        args = exclude_args,
    )

    execute_binary(
        name = test_missing_name,
        binary = "@cgrindel_rules_bzlformat//tools/missing_pkgs:find",
        args = exclude_args + [
            "--fail_on_missing_pkgs",
        ],
    )

    execute_binary(
        name = name + "_update_missing",
        binary = "@cgrindel_rules_bzlformat//tools/missing_pkgs:update",
        args = exclude_args,
    )
