# ncov2019ArticNf

ncov2019ArticNf workflow executes the ncov2019-artic-nf Nextflow workflow from connor-lab (https://github.com/connor-lab/ncov2019-artic-nf).

## Overview

## Dependencies

* [ncov2019-artic-nf 1](https://github.com/connor-lab/ncov2019-artic-nf)
* [artic-ncov2019 1](https://github.com/artic-network/artic-ncov2019.git)


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


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`runNcov2019ArticNf.mem`|Int|8|Memory (in GB) to allocate to the job.
`runNcov2019ArticNf.timeout`|Int|5|Maximum amount of time (in hours) the task can run for.
`runNcov2019ArticNf.modules`|String|"ncov2019-artic-nf/1 artic-ncov2019/1"|Environment module name and version to load (space separated) before command execution.
`runNcov2019ArticNf.ncov2019ArticNextflowPath`|String|"$NCOV2019_ARTIC_NF_ROOT"|Path to the ncov2019-artic-nf repository directory.
`runNcov2019ArticNf.ncov2019ArticPath`|String|"$ARTIC_NCOV2019_ROOT"|Path to the artic-ncov2019 repository directory or url


### Outputs

Output | Type | Description
---|---|---


## Niassa + Cromwell

This WDL workflow is wrapped in a Niassa workflow (https://github.com/oicr-gsi/pipedev/tree/master/pipedev-niassa-cromwell-workflow) so that it can used with the Niassa metadata tracking system (https://github.com/oicr-gsi/niassa).

* Building
```
mvn clean install
```

* Testing
```
mvn clean verify \
-Djava_opts="-Xmx1g -XX:+UseG1GC -XX:+UseStringDeduplication" \
-DrunTestThreads=2 \
-DskipITs=false \
-DskipRunITs=false \
-DworkingDirectory=/path/to/tmp/ \
-DschedulingHost=niassa_oozie_host \
-DwebserviceUrl=http://niassa-url:8080 \
-DwebserviceUser=niassa_user \
-DwebservicePassword=niassa_user_password \
-Dcromwell-host=http://cromwell-url:8000
```

## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with wdl_doc_gen (https://github.com/oicr-gsi/wdl_doc_gen/)_
