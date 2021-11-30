load("@cgrindel_bazel_shlib//rules:execute_binary.bzl", "execute_binary")

def bzlformat_missing_pkgs(name, exclude = []):
    exclude_args = []
    for pkg in exclude:
        exclude_args.extend(["--exclude", pkg])

    find_name = name + "_find"
    test_name = name + "_test"
    fix_name = name + "_fix"

    execute_binary(
        name = find_name,
        binary = "@cgrindel_rules_bzlformat//tools/missing_pkgs:find",
        args = exclude_args,
    )

    execute_binary(
        name = test_name,
        binary = "@cgrindel_rules_bzlformat//tools/missing_pkgs:find",
        args = exclude_args + [
            "--fail_on_missing_pkgs",
        ],
    )

    execute_binary(
        name = fix_name,
        binary = "@cgrindel_rules_bzlformat//tools/missing_pkgs:fix",
        args = exclude_args,
    )
