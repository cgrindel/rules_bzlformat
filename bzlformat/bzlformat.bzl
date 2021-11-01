load(
    "//bzlformat/internal:bzlformat_format.bzl",
    _bzlformat_format = "bzlformat_format",
)
load(
    "//bzlformat/internal:bzlformat_pkg.bzl",
    _bzlformat_pkg = "bzlformat_pkg",
)

bzlformat_format = _bzlformat_format
bzlformat_pkg = _bzlformat_pkg
