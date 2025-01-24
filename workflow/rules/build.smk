
rule build:
    input:
        fa=Path("results", "query.cleaned.fa"),
    output:
        tx=Path("results", "repeatmasker", "query.translation"),
    params:
        wd=lambda wildcards, output: Path(output.tx).parent.resolve(),
        fa_dir=lambda wildcards, input: Path(input.fa).parent.resolve(),
    log:
        Path("logs", "build.log").resolve(),
    benchmark:
        Path("logs", "build.benchmark.txt").resolve()
    threads: 1
    resources:
        time=lambda wildcards, attempt: 120 * attempt,
    container:
        get_container("tetools")
    shell:
        "mkdir -p {params.wd} && cd {params.wd} || exit 1 "
        "&& "
        "BuildDatabase "
        "-name query "
        "-engine ncbi "
        "-dir {params.fa_dir} "
        "&> {log} "
