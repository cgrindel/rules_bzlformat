load(
    "//bzlformat/internal:bzlformat_format.bzl",
    _bzlformat_format = "bzlformat_format",
)
load(
    "//bzlformat/internal:bzlformat.bzl",
    _bzlformat = "bzlformat",
)

bzlformat_format = _bzlformat_format
bzlformat = _bzlformat
