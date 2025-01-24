
rule model:
    input:
        tx=Path("results", "repeatmasker", "query.translation"),
    output:
        Path("results", "repeatmasker", "query-families.stk"),
        Path("results", "repeatmasker", "query-families.fa"),
    params:
        wd=lambda wildcards, input: Path(input.tx).parent.resolve(),
    log:
        Path("logs", "model.log").resolve(),
    benchmark:
        Path("logs", "model.benchmark.txt").resolve()
    threads: lambda wildcards, attempt: 10 * attempt
    resources:
        time=lambda wildcards, attempt: 1440 * attempt,
        mem_mb=lambda wildcards, attempt: 12e3 * attempt,
    container:
        get_container("tetools")
    shell:
        "cd {params.wd} || exit 1 "
        "&& "
        "RepeatModeler "
        "-database query "
        "-engine ncbi "
        "-threads {threads} "
        "&> {log}"
