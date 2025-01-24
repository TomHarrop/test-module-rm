
rule classify:
    input:
        Path("results", "repeatmasker", "query-families.stk"),
        Path("results", "repeatmasker", "query-families.fa"),
    output:
        Path(
            "results",
            "repeatmasker",
            "query-families.fa.classified",
        ),
    params:
        wd=lambda wildcards, input: Path(input[0]).parent.resolve(),
    log:
        Path("logs", "classify.log").resolve(),
    benchmark:
        Path("logs", "classify.benchmarks.txt").resolve()
    threads: lambda wildcards, attempt: 10 * attempt
    resources:
        time=lambda wildcards, attempt: 60 * attempt,
        mem_mb=lambda wildcards, attempt: 12e3 * attempt,
    container:
        get_container("tetools")
    shell:
        "cd {params.wd} || exit 1 ; "
        "RepeatClassifier "
        "-threads {threads} "
        "-consensi query-families.fa "
        "-stockholm query-families.stk "
        "&> {log}"
