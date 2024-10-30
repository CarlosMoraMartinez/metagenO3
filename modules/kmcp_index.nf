process KMCPIndex{
  label 'mg21_kmcp_index'
  conda params.KMCPComputeKmers.conda
  cpus params.resources.KMCPComputeKmers.cpus
  memory params.resources.KMCPComputeKmers.mem
  queue params.resources.KMCPComputeKmers.queue
  //array params.resources.array_size
  clusterOptions params.resources.KMCPComputeKmers.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg21_kmcp_index", mode: 'symlink'
  input:
  tuple(val(db_name), path(kmercount))

  output:
  tuple(val(db_name), path("*.kmcp"), path("*.log"))

  shell:
  '''

 kmcp index \
    --in-dir !{kmercount} \
    --threads !{params.resources.KMCPIndex.cpus}
    !{params.KMCPIndex.fprate} \
    --num-hash !{params.KMCPIndex.numhash} \
    --false-positive-rate !{params.KMCPIndex.fprate} \
    --out-dir !{db_name}.kmcp \
    --log !{db_name}.log \
    --force


  '''

  stub:
  """
  mkdir $db_name'.kmcp'
  touch $db_name'.log'
  """
}