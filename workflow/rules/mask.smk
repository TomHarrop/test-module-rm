


rule mask:
    input:
        cons=Path(
            "results",
            "repeatmasker",
            "query-families.fa.classified",
        ),
        fa=Path("results", "query.cleaned.fa"),
    output:
        temp(
            Path(
                "results",
                "repeatmasker",
                "query.cleaned.fa.masked",
            )
        ),
    params:
        wd=lambda wildcards, input: Path(input.cons).parent.resolve(),
        fa=lambda wildcards, input: Path(input.fa).resolve(),
        threads=lambda wildcards, threads: threads // 4,
    log:
        Path("logs", "mask.log").resolve(),
    benchmark:
        Path("logs", "mask.txt").resolve()
    threads: lambda wildcards, attempt: 12 * attempt
    resources:
        time=lambda wildcards, attempt: 1440 * attempt,
        mem_mb=lambda wildcards, attempt: 12e3 * attempt,
    container:
        get_container("tetools")
    shell:
        "cd {params.wd} || exit 1 ; "
        "RepeatMasker "
        "-engine ncbi "
        "-pa {params.threads} "
        "-lib query-families.fa.classified "
        "-dir {params.wd} "
        "-gccalc -xsmall -gff -html "
        "{params.fa} "
        "&> {log} "
