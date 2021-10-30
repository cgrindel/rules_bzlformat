def bzlformat(name, srcs = None):
    # Only process paths; ignore labels
    src_paths = [src for src in srcs if src_utils.is_path(src)]

    format_names = []
    for src in src_paths:
        src_name = src.replace("/", "_")
        format_name = name + "_fmt_" + src_name
        format_names.append(":" + format_name)

        swiftformat_format(
            name = format_name,
            srcs = [src],
            config = config,
        )
        diff_test(
            name = name + "_test_" + src_name,
            file1 = src,
            file2 = ":" + format_name,
        )

    updatesrc_update(
        name = name + "_update",
        deps = format_names,
    )
