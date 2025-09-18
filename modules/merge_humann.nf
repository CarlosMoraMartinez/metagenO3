process mergeHumann{
  label 'mg14_humannmerged'
  conda params.doHumann3.conda
  cpus params.resources.mergeHumann3.cpus
  memory params.resources.mergeHumann3.mem
  queue params.resources.mergeHumann3.queue
  //array params.resources.array_size
  clusterOptions params.resources.mergeHumann3.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg14_mergeHumann", mode: 'copy'
  input:
    tuple(val(table_type), path(humann_results_list))
  output:
    tuple(val(table_type), path("*_merged.tsv"))

  shell:
  '''
  humann_join_tables --input . --output humann3_!{table_type}_merged.tsv   
  '''

  stub:
  """
  echo $humann_results_list
  touch 'humann3_'$table_type'_merged.tsv'
  """
}