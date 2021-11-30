load("@cgrindel_bazel_shlib//rules:execute_binary.bzl", "execute_binary")

def bzlformat_missing_pkgs(name, exclude = []):
    """Defines executable targets that find, test and fix any Bazel packages that are missing `bzlformat_pkg` declarations.

    Args:
        name: A `string` that acts as the prefix for the target names that are
              defined.
        exclude: A `list` of packages to exclude from the find, test and fix
                 operations. Each package should be specifed in the format
                 `//path/to/package`.

    Returns:
        None.
    """
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
