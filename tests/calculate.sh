#!/bin/bash

ls -1

# gzipped fastqs with timestamp - can't directly md5sum fastq.gz then...
# find . -xtype f -iname "*.fastq.gz" -exec zcat {} | md5sum \;
find . -xtype f -iname "*.fastq.gz" -printf "%f " -exec /bin/bash -c "zcat {} | md5sum | cut -d ' ' -f 1" \;

module load samtools/1.9 2>/dev/null
find . -xtype f -iname "*.bam" -exec samtools flagstat {} \; | sort
