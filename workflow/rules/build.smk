
rule build:
    input:
        fa=Path("results", "query.cleaned.fa"),
    output:
        multiext(
            Path("results", "repeatmasker", "query").as_posix(),
            ".translation",
            ".nsq",
            ".nog",
            ".nni",
            ".nnd",
            ".njs",
            ".nin",
            ".nhr",
        ),
    params:
        fa_dir=lambda wildcards, input: Path(input.fa).parent,
        outdir=lambda wildcards, output: Path(output[0]).parent,
    log:
        Path("logs", "build.log"),
    benchmark:
        Path("logs", "build.benchmark.txt")
    threads: 1
    resources:
        runtime=lambda wildcards, attempt: 120 * attempt,
    shadow:
        "minimal"
    container:
        get_container("tetools")
    shell:
        "BuildDatabase "
        "-name query "
        "-dir {params.fa_dir} "
        "&> {log} "
        "&& mv query.* {params.outdir}/"
