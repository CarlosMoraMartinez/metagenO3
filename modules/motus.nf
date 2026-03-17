process callmOTUs{
  label 'mg34_mOTUs'
  conda params.callmOTUs.conda
  cpus params.resources.callmOTUs.cpus
  memory params.resources.callmOTUs.mem
  queue params.resources.callmOTUs.queue
  //array params.resources.array_size
  clusterOptions params.resources.callmOTUs.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg34_mOTUs", mode: 'symlink'
  input:
  tuple(val(illumina_id), path(fastq))

  output:
  tuple(val(illumina_id), path("*mOTUs.tsv"), path("*mOTUs.err"))
  

  shell:
  '''
  outfile=!{illumina_id}.mOTUs.tsv
  summary=!{illumina_id}.mOTUs.err

  motus profile -f !{fastq[0]} -r !{fastq[1]} -n !{illumina_id} \
      -o $outfile -c \
      !{params.callmOTUs.extra_options} 2> $summary

  '''

  stub:
  """
  touch $illumina_id'.mOTUs.tsv'
  touch $illumina_id'.mOTUs.err'

  """
}