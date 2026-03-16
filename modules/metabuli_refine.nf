process callMetabuliRefine{
  label 'mg31_metabuli_refine'
  conda params.callMetabuliRefine.conda
  cpus params.resources.callMetabuliRefine.cpus
  memory params.resources.callMetabuliRefine.mem
  queue params.resources.callMetabuliRefine.queue
  //array params.resources.array_size
  clusterOptions params.resources.callMetabuliRefine.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg31_metabuli_refine", mode: 'symlink'
  input:
    path metabuli_db
    tuple(val(illumina_id), path(metabuli_path))

  output:
    tuple(val(illumina_id), path(metabuli_path))
  
  shell:
  '''

  metabuli classifiedRefiner  !{metabuli_path}/!{illumina_id}_classifications.tsv \
    !{params.resources.callMetabuli.taxonomy_path} \
    --threads !{task.cpus} \
    --min-score !{params.resources.callMetabuliRefine.min_score} \
    --remove-unclassified !{params.resources.callMetabuliRefine.remove_unclassified} \
    --report 1

  '''

  stub:
  """
  mkdir metabuli_refined_!{illumina_id} 
  """
  }

