process mergemOTUs{
  label 'mg35_mergemOTUs'
  conda params.mergemOTUs.conda
  cpus params.resources.mergemOTUs.cpus
  memory params.resources.mergemOTUs.mem
  queue params.resources.mergemOTUs.queue
  //array params.resources.array_size
  clusterOptions params.resources.mergemOTUs.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg35_mergemOTUs", mode: 'copy'
  input:
  path motus_results_list
  output:
  path("motus_merged.tsv")
  
  shell:
  '''
  merge_motus.py *.tsv -o motus_merged.tsv  
  '''

  stub:
  """
  echo $motus_results_list
  touch motus_merged.tsv
  """
  }