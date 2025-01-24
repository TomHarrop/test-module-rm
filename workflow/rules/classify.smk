
rule classify:
    input:
        stk=Path("results", "repeatmasker", "query-families.stk"),
        fa=Path("results", "repeatmasker", "query-families.fa"),
    output:
        Path(
            "results",
            "repeatmasker",
            "query-families.fa.classified",
        ),
        Path(
            "results",
            "repeatmasker",
            "query-families-classified.stk",
        ),
    log:
        Path("logs", "classify.log"),
    benchmark:
        Path("logs", "classify.benchmarks.txt")
    threads: lambda wildcards, attempt: 10 * attempt
    resources:
        time=lambda wildcards, attempt: 60 * attempt,
        mem_mb=lambda wildcards, attempt: 12e3 * attempt,
    container:
        get_container("tetools")
    shadow:
        "minimal"
    shell:
        "RepeatClassifier "
        "-threads {threads} "
        "-consensi {input.fa} "
        "-stockholm {input.stk} "
        "&> {log}"
