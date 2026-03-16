process mergeSylph{
  label 'mg29_mergesylph'
  conda params.mergeSylph.conda
  cpus params.resources.mergeSylph.cpus
  memory params.resources.mergeSylph.mem
  queue params.resources.mergeSylph.queue
  //array params.resources.array_size
  clusterOptions params.resources.mergeSylph.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg29_mergesylph", mode: 'copy'
  input:
    path metaphlan_results_list
  output:
  path("sylph_merged.tsv")
  
  shell:
  '''
  merge_sylph.py *.sylphmpa -o sylph_merged.tsv  
  '''

  stub:
  """
  echo $metaphlan_results_list
  touch metaphlan_merged.tsv
  """
  }