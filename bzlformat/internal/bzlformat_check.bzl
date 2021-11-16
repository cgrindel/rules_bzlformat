def bzlformat_check(name = "bzlformat_check"):
    native.sh_binary(
        name = name,
        srcs = [
            "@cgrindel_rules_bzlformat//scripts:check.sh",
        ],
    )
