


rule mask:
    input:
        cons=Path(
            "results",
            "repeatmasker",
            "query-families.fa.classified",
        ),
        fa=Path("results", "query.cleaned.fa"),
    output:
        multiext(
            Path(
                "results",
                "repeatmasker",
                "query.cleaned.fa",
            ).as_posix(),
            ".masked",
            ".tbl",
            ".cat",
            ".out",
        ),
    params:
        threads=lambda wildcards, threads: threads // 4,
        outdir=lambda wildcards, output: Path(output[0]).parent,
    log:
        Path("logs", "mask.log"),
    benchmark:
        Path("logs", "mask.benchmark.txt")
    threads: lambda wildcards, attempt: 12 * attempt
    resources:
        runtime=lambda wildcards, attempt: 1440 * attempt,
        mem_mb=lambda wildcards, attempt: 12e3 * attempt,
    shadow:
        "minimal"
    container:
        get_container("tetools")
    # rm expects the dir under /opt to exist
    shell:
        "mkdir -p /opt/RepeatMasker/Libraries/general ; "
        "RepeatMasker "
        "-engine ncbi "
        "-pa {params.threads} "
        "-lib {input.cons} "
        "-gccalc -xsmall -gff -html "
        "{input.fa} "
        "&> {log} "
        "&& mv {input.fa}.* {params.outdir}/ "
