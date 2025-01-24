rule clean:
    input:
        fa=Path("results", "query.reformat.fa"),
    output:
        fa=temp(Path("results", "query.cleaned.fa")),
    params:
        wd=lambda wildcards, output: Path(output.fa).parent.resolve(),
        fa=lambda wildcards, input: Path(input.fa).resolve(),
    log:
        Path("logs", "clean_query.log").resolve(),
    benchmark:
        Path("logs", "clean_query.benchmark.txt").resolve()
    threads: lambda wildcards, attempt: 20 * attempt
    resources:
        time=lambda wildcards, attempt: 2880 * attempt,
        mem_mb=lambda wildcards, attempt: 24e3 * attempt,
    container:
        get_container("funannotate")
    shell:
        "mkdir -p {params.wd} && cd {params.wd} || exit 1 "
        "&& "
        "funannotate clean "
        "--exhaustive "
        "--input {params.fa} "
        "--out query.cleaned.fa "
        "--cpus {threads} "
        "&> {log}"


rule reformat:
    input:
        query_genome,
    output:
        temp(Path("results", "query.reformat.fa")),
    log:
        Path("logs", "reformat.log"),
    container:
        get_container("bbmap")
    shell:
        "reformat.sh in={input} out={output} 2>{log}"
