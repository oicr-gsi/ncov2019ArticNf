#!/bin/bash

ls -1

find . -type f -iname "*.fastq.gz" -exec md5sum {} \;

module load samtools/1.9 2>/dev/null
find . -type f -iname "*.bam" -exec samtools flagstat {} \; | sort