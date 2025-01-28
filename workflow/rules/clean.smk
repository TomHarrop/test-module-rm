rule clean:
    input:
        fa=Path("results", "query.reformat.fa"),
    output:
        fa=temp(Path("results", "query.cleaned.fa")),
    log:
        Path("logs", "clean_query.log"),
    benchmark:
        Path("logs", "clean_query.benchmark.txt")
    threads: lambda wildcards, attempt: 20 * attempt
    resources:
        runtime=lambda wildcards, attempt: 720 * attempt,
        mem_mb=lambda wildcards, attempt: 24e3 * attempt,
    container:
        get_container("funannotate")
    shell:
        "funannotate clean "
        "--exhaustive "
        "--input {input.fa} "
        "--out {output.fa} "
        "--cpus {threads} "
        "&> {log}"


rule reformat:
    input:
        query_genome,
    output:
        temp(Path("results", "query.reformat.fa")),
    log:
        Path("logs", "reformat.log"),
    benchmark:
        Path("logs", "reformat.benchmark.txt")
    resources:
        mem_mb=lambda wildcards, attempt: 16e3 * attempt,
    container:
        get_container("bbmap")
    shell:
        "reformat.sh "
        "-Xmx{resources.mem_mb}m "
        "in={input} "
        "out={output} "
        "2>{log}"
