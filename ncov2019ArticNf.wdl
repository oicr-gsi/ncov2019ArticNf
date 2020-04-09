version 1.0

workflow ncov2019ArticNf {
  input {
    File fastqR1
    File fastqR2
    String outputFileNamePrefix
  }

  call renameInputs {
    input:
      fastqR1 = fastqR1,
      fastqR2 = fastqR2,
      outputFileNamePrefix = outputFileNamePrefix
  }

  call illumina_ncov2019ArticNf {
    input:
      fastqR1 = renameInputs.renamedFastqR1,
      fastqR2 = renameInputs.renamedFastqR2,
      outputFileNamePrefix = outputFileNamePrefix
  }

  output {
    File readTrimmingFastqR1 = illumina_ncov2019ArticNf.readTrimmingFastqR1
    File readTrimmingFastqR2 = illumina_ncov2019ArticNf.readTrimmingFastqR2
    File readMappingBam = illumina_ncov2019ArticNf.readMappingBam
    File trimPrimerSequencesBam = illumina_ncov2019ArticNf.trimPrimerSequencesBam
    File trimPrimerSequencesPrimerTrimmedBam = illumina_ncov2019ArticNf.trimPrimerSequencesPrimerTrimmedBam
    File makeConsensusFasta = illumina_ncov2019ArticNf.makeConsensusFasta
    File qcPlotsPng = illumina_ncov2019ArticNf.qcPlotsPng
    File callVariantsTsv = illumina_ncov2019ArticNf.callVariantsTsv
    File qcCsv = illumina_ncov2019ArticNf.qcCsv
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
      readTrimmingFastqR1: "Fastq R1 from readTrimming step.",
      readTrimmingFastqR2: "Fastq R1 from readTrimming step.",
      readMappingBam: "Sorted bam from readMapping step.",
      trimPrimerSequencesBam: "Mapped bam from trimPrimerSequences step.",
      trimPrimerSequencesPrimerTrimmedBam: "Mapped + primer trimmer bam from trimPrimerSequences step.",
      makeConsensusFasta: "Consensus fasta from makeConsensus step.",
      callVariantsTsv: "Variants tsv from callVariants step.",
      qcPlotsPng: "Qc plot (depth) png from qcPlots step.",
      qcCsv: "Qc csv from qc step."
    }
  }

}

task renameInputs {
  input {
    File fastqR1
    File fastqR2
    String outputFileNamePrefix
    Int mem = 1
    Int timeout = 1
  }

  command <<<
    ln -s ~{fastqR1} ~{outputFileNamePrefix}_R1.fastq.gz
    ln -s ~{fastqR2} ~{outputFileNamePrefix}_R2.fastq.gz
  >>>

  output {
    File renamedFastqR1 = "~{outputFileNamePrefix}_R1.fastq.gz"
    File renamedFastqR2 = "~{outputFileNamePrefix}_R2.fastq.gz"
  }

  runtime {
    memory: "~{mem} GB"
    timeout: "~{timeout}"
  }

  parameter_meta {
    fastqR1: "Read 1 fastq file to rename."
    fastqR2: "Read 2 fastq file to rename."
    outputFileNamePrefix: "Output prefix to renamed fastqs with."
    mem: "Memory (in GB) to allocate to the job."
    timeout: "Maximum amount of time (in hours) the task can run for."
  }
}

task illumina_ncov2019ArticNf {
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

  output {
    File readTrimmingFastqR1 = "results/ncovIllumina_sequenceAnalysis_readTrimming/~{outputFileNamePrefix}_R1_val_1.fq.gz"
    File readTrimmingFastqR2 = "results/ncovIllumina_sequenceAnalysis_readTrimming/~{outputFileNamePrefix}_R2_val_2.fq.gz"
    File readMappingBam = "results/ncovIllumina_sequenceAnalysis_readMapping/~{outputFileNamePrefix}.sorted.bam"
    File trimPrimerSequencesBam = "results/ncovIllumina_sequenceAnalysis_trimPrimerSequences/~{outputFileNamePrefix}.mapped.bam"
    File trimPrimerSequencesPrimerTrimmedBam = "results/ncovIllumina_sequenceAnalysis_trimPrimerSequences/~{outputFileNamePrefix}.mapped.primertrimmed.sorted.bam"
    File makeConsensusFasta = "results/ncovIllumina_sequenceAnalysis_makeConsensus/~{outputFileNamePrefix}.primertrimmed.consensus.fa"
    File callVariantsTsv = "results/ncovIllumina_sequenceAnalysis_callVariants/~{outputFileNamePrefix}.variants.tsv"
    File qcPlotsPng = "results/qc_plots/~{outputFileNamePrefix}.depth.png"
    File qcCsv = "results/~{outputFileNamePrefix}.qc.csv"
  }

  runtime {
    memory: "~{mem} GB"
    modules: "~{modules}"
    timeout: "~{timeout}"
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
