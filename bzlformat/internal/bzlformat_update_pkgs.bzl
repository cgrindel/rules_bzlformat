load("@cgrindel_bazel_shlib//rules:execute_binary.bzl", "execute_binary")

# TODO: Fix the names of these targets

def bzlformat_update_pkgs(name, exclude = []):
    exclude_args = []
    for pkg in exclude:
        exclude_args.extend(["--exclude", pkg])

    find_missing_name = name + "_find_missing"
    test_missing_name = name + "_test_missing"
    update_name = name + "_update_missing"

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
