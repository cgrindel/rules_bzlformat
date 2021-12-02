load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def bzlformat_rules_dependencies():
    """Loads the dependencies for `rules_bzlformat`."""
    maybe(
        http_archive,
        name = "bazel_skylib",
        sha256 = "1c531376ac7e5a180e0237938a2536de0c54d93f5c278634818e0efc952dd56c",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "cgrindel_bazel_starlib",
        sha256 = "1f5c6b13243a1a6f79742a8a0e883f7f4591f7890a388f87c8323f4242dc718d",
        strip_prefix = "bazel-starlib-0.1.0",
        urls = ["https://github.com/cgrindel/bazel-starlib/archive/v0.1.0.tar.gz"],
    )

    maybe(
        http_archive,
        name = "cgrindel_bazel_doc",
        sha256 = "bae4a0f41cc5cf89f26c779fc04379f09bb290b4910b2cf206c0372ad0c8aac7",
        strip_prefix = "bazel-doc-0.1.0",
        urls = ["https://github.com/cgrindel/bazel-doc/archive/v0.1.0.tar.gz"],
    )

    maybe(
        http_archive,
        name = "cgrindel_rules_updatesrc",
        sha256 = "18eb6620ac4684c2bc722b8fe447dfaba76f73d73e2dfcaf837f542379ed9bc3",
        strip_prefix = "rules_updatesrc-0.1.0",
        urls = ["https://github.com/cgrindel/rules_updatesrc/archive/v0.1.0.tar.gz"],
    )

    # Buildifier Deps

    maybe(
        http_archive,
        name = "io_bazel_rules_go",
        sha256 = "2b1641428dff9018f9e85c0384f03ec6c10660d935b750e3fa1492a281a53b0f",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.29.0/rules_go-v0.29.0.zip",
            "https://github.com/bazelbuild/rules_go/releases/download/v0.29.0/rules_go-v0.29.0.zip",
        ],
    )

    maybe(
        http_archive,
        name = "bazel_gazelle",
        sha256 = "de69a09dc70417580aabf20a28619bb3ef60d038470c7cf8442fafcf627c21cb",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.24.0/bazel-gazelle-v0.24.0.tar.gz",
            "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.24.0/bazel-gazelle-v0.24.0.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "com_google_protobuf",
        sha256 = "9b4ee22c250fe31b16f1a24d61467e40780a3fbb9b91c3b65be2a376ed913a1a",
        strip_prefix = "protobuf-3.13.0",
        urls = [
            "https://github.com/protocolbuffers/protobuf/archive/v3.13.0.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "com_github_bazelbuild_buildtools",
        sha256 = "ae34c344514e08c23e90da0e2d6cb700fcd28e80c02e23e4d5715dddcb42f7b3",
        strip_prefix = "buildtools-4.2.2",
        urls = [
            "https://github.com/bazelbuild/buildtools/archive/refs/tags/4.2.2.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "cgrindel_rules_bazel_integration_test",
        sha256 = "ef6cf463a269d969bdb3b31eed53c50d3667f02e004abc9ce7a3a2413eadca6a",
        strip_prefix = "rules_bazel_integration_test-0.3.0",
        urls = ["https://github.com/cgrindel/rules_bazel_integration_test/archive/v0.3.0.tar.gz"],
    )

    maybe(
        http_archive,
        name = "cgrindel_bazel_shlib",
        sha256 = "d2f0a8dd3180463f00451449ad1f0bedfebb3d2bccc8178634ef5ad07ab55dac",
        strip_prefix = "bazel_shlib-0.2.0",
        urls = ["https://github.com/cgrindel/bazel_shlib/archive/v0.2.0.tar.gz"],
    )
