# ncov2019ArticNf

ncov2019ArticNf workflow executes the ncov2019-artic-nf Nextflow workflow from connor-lab (https://github.com/connor-lab/ncov2019-artic-nf).

## Overview

## Dependencies

* [ncov2019-artic-nf-illumina 20210406](https://github.com/oicr-gsi/ncov2019-artic-nf)
* [artic-ncov2019 2](https://github.com/oicr-gsi/artic-ncov2019)
* [ncov2019primernames 20201112](https://gitlab.oicr.on.ca/ResearchIT/modulator)
* [hg38-sars-covid-2 20200714](https://gitlab.oicr.on.ca/ResearchIT/modulator)


## Usage

### Cromwell
```
java -jar cromwell.jar run ncov2019ArticNf.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`fastqR1`|File|Read 1 fastq file.
`fastqR2`|File|Read 2 fastq file.
`outputFileNamePrefix`|String|Output prefix to prefix output file names with.
`schemeVersion`|String|The Artic primer scheme version that was used.


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`renameInputs.mem`|Int|1|Memory (in GB) to allocate to the job.
`renameInputs.timeout`|Int|1|Maximum amount of time (in hours) the task can run for.
`illumina_ncov2019ArticNf.viralContigName`|String|"MN908947.3"|Viral contig name to retain during non-human filtering step.
`illumina_ncov2019ArticNf.allowNoprimer`|Boolean?|None|Allow reads that don't have primer sequence? Ligation prep = false, nextera = true.
`illumina_ncov2019ArticNf.illuminaKeepLen`|Int?|None|Length of illumina reads to keep after primer trimming.
`illumina_ncov2019ArticNf.illuminaQualThreshold`|Int?|None|Sliding window quality threshold for keeping reads after primer trimming (illumina).
`illumina_ncov2019ArticNf.mpileupDepth`|Int?|None|Mpileup depth for ivar.
`illumina_ncov2019ArticNf.ivarFreqThreshold`|Float?|None|ivar frequency threshold for variant.
`illumina_ncov2019ArticNf.ivarMinDepth`|Float?|None|Minimum coverage depth to call variant.
`illumina_ncov2019ArticNf.additionalParameters`|String?|None|Additional parameters to add to the nextflow command.
`illumina_ncov2019ArticNf.mem`|Int|8|Memory (in GB) to allocate to the job.
`illumina_ncov2019ArticNf.timeout`|Int|5|Maximum amount of time (in hours) the task can run for.
`illumina_ncov2019ArticNf.modules`|String|"ncov2019-artic-nf-illumina/20210406 artic-ncov2019/2 ncov2019primernames/20201112 hg38-sars-covid-2/20200714"|Environment module name and version to load (space separated) before command execution.
`illumina_ncov2019ArticNf.ncov2019ArticNextflowPath`|String|"$NCOV2019_ARTIC_NF_ILLUMINA_ROOT"|Path to the ncov2019-artic-nf-illumina repository directory.
`illumina_ncov2019ArticNf.ncov2019ArticPath`|String|"$ARTIC_NCOV2019_ROOT"|Path to the artic-ncov2019 repository directory or url
`illumina_ncov2019ArticNf.compositeHumanVirusReferencePath`|String|"$HG38_SARS_COVID_2_ROOT/composite_human_virus_reference.fasta"|Path to the composite reference to use during non-human filtering step.
`illumina_ncov2019ArticNf.ncov2019primerNames`|String|"$NCOV2019PRIMERNAMES_ROOT/nCoV-2019.outer.V3.primernames.tsv"|Path to primer names for improved primer trimming.


### Outputs

Output | Type | Description | Labels
---|---|---|---
`readTrimmingFastqR1`|File|Fastq R1 from readTrimming step.|vidarr_label: readTrimmingFastqR1
`readTrimmingFastqR2`|File|Fastq R1 from readTrimming step.|vidarr_label: readTrimmingFastqR2
`readMappingBam`|File|Sorted bam from readMapping step.|vidarr_label: readMappingBam
`trimPrimerSequencesBam`|File|Mapped bam from trimPrimerSequences step.|vidarr_label: trimPrimerSequencesBam
`trimPrimerSequencesPrimerTrimmedBam`|File|Mapped + primer trimmer bam from trimPrimerSequences step.|vidarr_label: trimPrimerSequencesPrimerTrimmedBam
`makeConsensusFasta`|File|Consensus fasta from makeConsensus step.|vidarr_label: makeConsensusFasta
`makeConsensusVcf`|File|Consensus vcf from makeConsensus step.|vidarr_label: makeConsensusVcf
`qcPlotsPng`|File|Qc plot (depth) png from qcPlots step.|vidarr_label: qcPlotsPng
`qcCsv`|File|Qc csv from qc step.|vidarr_label: qcCsv
`nextflowLogs`|File|All nextflow workflow task stdout and stderr logs gzipped and named by task.|vidarr_label: nextflowLogs


## Commands
 This section lists command(s) run by ncov2019Artic workflow
 
 * Running ncov2019Artic
 
 
 ### Linking fastq files
 
 ```
     ln -s ~{fastqR1} ~{outputFileNamePrefix}_R1.fastq.gz
     ln -s ~{fastqR2} ~{outputFileNamePrefix}_R2.fastq.gz
 ```
 
 Running workflow as Nextflow wf
 
 ```
     set -euo pipefail
 
     nextflow run ~{ncov2019ArticNextflowPath} \
     --illumina \
     --directory "$(dirname ~{fastqR1})" \
     --prefix "~{outputFileNamePrefix}" \
     --schemeRepoURL ~{ncov2019ArticPath} \
     --schemeVersion ~{schemeVersion} \
     ~{true="--allowNoprimer true" false="--allowNoprimer false" allowNoprimer} \
     ~{"--illuminaKeepLen " + illuminaKeepLen} \
     ~{"--illuminaQualThreshold " + illuminaQualThreshold} \
     ~{"--mpileupDepth " + mpileupDepth} \
     ~{"--ivarFreqThreshold " + ivarFreqThreshold} \
     ~{"--ivarMinDepth " + ivarMinDepth} \
     --composite_ref ~{compositeHumanVirusReferencePath} \
     --viral_contig_name ~{viralContigName} \
     --primer_pairs_tsv ~{ncov2019primerNames} \
     ~{additionalParameters}
 
     # rename some of the outputs
     ln -s "results/ncovIllumina_sequenceAnalysis_readTrimming/~{outputFileNamePrefix}_hostfiltered_R1_val_1.fq.gz" \
     ~{outputFileNamePrefix}_R1.trimmed.fastq.gz
     ln -s "results/ncovIllumina_sequenceAnalysis_readTrimming/~{outputFileNamePrefix}_hostfiltered_R2_val_2.fq.gz" \
     ~{outputFileNamePrefix}_R2.trimmed.fastq.gz
 
     # extract all logs from the nextflow working directory
     NEXTFLOW_ID="$(nextflow log -q | head -1)"
     NEXTFLOW_TASKS=$(nextflow log "${NEXTFLOW_ID}" -f "name,workdir" -s '\t')
     mkdir -p logs
     while IFS=$'\t' read -r name workdir; do
       FILENAME="$(echo "${name}" | sed -e 's/[^A-Za-z0-9._-]/_/g')"
       if [ -f "$workdir/.command.log" ]; then
         cp "$workdir/.command.log" "logs/$FILENAME.stdout"
       fi
       if [ -f "$workdir/.command.err" ]; then
         cp "$workdir/.command.err" "logs/$FILENAME.stderr"
       fi
     done <<< ${NEXTFLOW_TASKS}
     tar -zcvf ~{outputFileNamePrefix}.logs.tar.gz logs/
 ```
 ## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_
