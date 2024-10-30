process KMCPComputeKmers{
  label 'mg20_kmcp_computekmers'
  conda params.KMCPComputeKmers.conda
  cpus params.resources.KMCPComputeKmers.cpus
  memory params.resources.KMCPComputeKmers.mem
  queue params.resources.KMCPComputeKmers.queue
  //array params.resources.array_size
  clusterOptions params.resources.KMCPComputeKmers.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg20_kmcp_computekmers", mode: 'symlink'
  input:
  val db_name
  path fasta_dir

  output:
  tuple(val(db_name), path("kmercount_$db_name"), path("*.log"))

  shell:
  '''

  kmcp compute \
    --in-dir !{fasta_dir} \
    --threads !{params.resources.KMCPComputeKmers.cpus}
    --ref-name-regexp "^([a-zA-Z._]+.d+)" \
    --seq-name-filter !{params.KMCPcomputeKmers.seqname_filter} \
    --kmer !{params.KMCPcomputeKmers.kmer} \
    --split-number !{params.KMCPcomputeKmers.split_number} \
    --split-overlap !{params.KMCPcomputeKmers.split_overlap} \
    --out-dir kmercount_!{db_name} \
    !{params.KMCPcomputeKmers.extra_args} --force \
    --log kmercount_!{db_name}.log 2> kmercount_!{db_name}.err

  '''

  stub:
  """
  mkdir 'kmercount_'$db_name
  touch 'kmercount_'$db_name'.log'
  """
}