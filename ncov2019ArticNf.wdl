version 1.0

workflow ncov2019ArticNf {
  input {
    File fastqR1
    File fastqR2
    String outputFileNamePrefix
  }

  call runNcov2019ArticNf {
    input:
      fastqR1 = fastqR1,
      fastqR2 = fastqR2,
      outputFileNamePrefix = outputFileNamePrefix
  }

  output {
  }

  parameter_meta {
    fastqR1: "Read 1 fastq file."
    fastqR2: "Read 2 fastq file."
    outputFileNamePrefix: "Output prefix to prefix output file names with."
  }

  meta {
    author: "Michael Laszloffy"
    email: "michael.laszloffy@oicr.on.ca"
    description: "ncov2019ArticNf workflow executes the ncov2019-artic-nf Nextflow workflow from connor-lab (https://github.com/connor-lab/ncov2019-artic-nf)."
    dependencies: [
      {
        name: "ncov2019-artic-nf/1",
        url: "https://github.com/connor-lab/ncov2019-artic-nf"
      },
      {
        name: "artic-ncov2019/1",
        url: "https://github.com/artic-network/artic-ncov2019.git"
      }
    ]
    output_meta: {
    }
  }

}

task runNcov2019ArticNf {
  input {
    File fastqR1
    File fastqR2
    String outputFileNamePrefix

    Int mem = 8
    Int timeout = 5
    String modules = "ncov2019-artic-nf/1 artic-ncov2019/1"
    String ncov2019ArticNextflowPath = "$NCOV2019_ARTIC_NF_ROOT"
    String ncov2019ArticPath = "$ARTIC_NCOV2019_ROOT"
  }

  command <<<
    set -euo pipefail

    nextflow run ~{ncov2019ArticNextflowPath} \
    --illumina \
    --directory "$(dirname ~{fastqR1})" \
    --prefix "~{outputFileNamePrefix}" \
    --schemeRepoURL ~{ncov2019ArticPath}
  >>>

  runtime {
    memory: "~{mem} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
  }

  output {

  }

  parameter_meta {
    fastqR1: "Read 1 fastq file."
    fastqR2: "Read 2 fastq file."
    outputFileNamePrefix: "Output prefix to prefix output file names with."
    mem: "Memory (in GB) to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
    modules: "Environment module name and version to load (space separated) before command execution."
    ncov2019ArticNextflowPath: "Path to the ncov2019-artic-nf repository directory."
    ncov2019ArticPath: "Path to the artic-ncov2019 repository directory or url"
  }
}
