def bzlformat_update_pkgs(name = "bzlformat_update_pkgs"):
    native.sh_binary(
        name = name,
        srcs = [
            "@cgrindel_rules_bzlformat//scripts:update_pkgs.sh",
        ],
    )
