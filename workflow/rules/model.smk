
rule model:
    input:
        rules.build.output,
    output:
        Path("results", "repeatmasker", "query-families.stk"),
        Path("results", "repeatmasker", "query-families.fa"),
        Path("results", "repeatmasker", "query-rmod.log"),
    params:
        db=lambda wildcards, input: Path(input[0]).with_suffix(""),
    log:
        Path("logs", "model.log"),
    benchmark:
        Path("logs", "model.benchmark.txt")
    threads: lambda wildcards, attempt: 10 * attempt
    resources:
        runtime=lambda wildcards, attempt: 1440 * attempt,
        mem_mb=lambda wildcards, attempt: 12e3 * attempt,
    container:
        get_container("tetools")
    shadow:
        "minimal"
    shell:
        "RepeatModeler "
        "-database {params.db} "
        "-engine ncbi "
        "-threads {threads} "
        "&> {log}"
