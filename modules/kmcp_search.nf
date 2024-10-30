process KMCPSearch{
  label 'mg22_kmcp_search'
  conda params.KMCPSearch.conda
  cpus params.resources.KMCPSearch.cpus
  memory params.resources.KMCPSearch.mem
  queue params.resources.KMCPSearch.queue
  //array params.resources.array_size
  clusterOptions params.resources.KMCPSearch.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg22_kmcp_search", mode: 'symlink'
  input:
  tuple(val(db_name), path(db_dir), val(illumina_id), path(fastq))

  output:
  tuple(val(illumina_id), val(db_name), path("*kmcp.gz"), path("*.kmcp.log"))
  

  shell:
  '''
  outname=!{illumina_id}_!{db_name}.kmcp
  kmcp search \
    --threads !{params.resources.KMCPSearch.cpus} \
    !{params.KMCPSearch.extra_args} \
    --db-dir !{db_dir} \
    !{fastq[0]} !{fastq[1]} \
    --out-file $outname'.gz' \
    --log $outname'.log' 2> $outname'.err'
  '''

  stub:
  """
  touch $illumina_id'_'$db_name'.kmcp.gz'
  touch $illumina_id'_'$db_name'.kmcp.log'
  """
}