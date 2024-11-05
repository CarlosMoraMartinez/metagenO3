process GanonClassify{
  label 'mg25_ganon_classify'
  conda params.GanonClassify.conda
  cpus params.resources.GanonClassify.cpus
  memory params.resources.GanonClassify.mem
  queue params.resources.GanonClassify.queue
  //array params.resources.array_size
  clusterOptions params.resources.GanonClassify.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg25_ganon_classify_$db_name", mode: 'symlink'
  input:
  tuple(val(db_name), path(db_dir), val(illumina_id), path(fastq))

  output:
  tuple(val(illumina_id), val(db_name), path("$illumina_id*.ganon2*"))
  

  shell:
  '''
  outname=!{illumina_id}_!{db_name}.ganon2

  ganon classify --db-prefix !{db_name}'/'!{db_name} \
    --threads !{params.resources.GanonClassify.cpus} \
    --rel-cutoff !{params.GanonClassify.rel_cutoff} \
    --rel-filter !{params.GanonClassify.rel_filter} \
    --min-count !{params.GanonClassify.min_count} \
    --multiple-matches !{params.GanonClassify.multiple_matches} \
    --report-type !{params.GanonClassify.report_type} \
    !{params.GanonClassify.extra_args} \
    --paired-reads !{fastq[0]} !{fastq[1]} \
    --output-prefix $outname --threads 12  > $outname'.log' 2> $outname'.err'

  '''

  stub:
  """
  touch $illumina_id'_'$db_name'.ganon2.tre'
  touch $illumina_id'_'$db_name'.ganon2.all'
  touch $illumina_id'_'$db_name'.ganon2.rep'
  touch $illumina_id'_'$db_name'.ganon2.log'
  touch $illumina_id'_'$db_name'.ganon2.err'
  """
}