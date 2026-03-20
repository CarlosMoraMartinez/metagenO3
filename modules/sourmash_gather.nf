
process sourmashGather{
  label 'mg38_sourmashGather'
  conda params.sourmashGather.conda
  cpus params.resources.sourmashGather.cpus
  memory params.resources.sourmashGather.mem
  maxForks params.resources.maxForks
  queue params.resources.sourmashGather.queue 
  //array params.resources.array_size
  clusterOptions params.resources.sourmashGather.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg38_sourmashGather", mode: 'symlink'
  input:
  path(database)
  tuple(val(illumina_id), path(sketch_file))
  
  output:
  tuple(val(illumina_id), path('*.gather.csv'), path('*.err'))
  
  shell:
  '''
  sourmash gather \
  !{params.sourmashGather.extra_params} \
  !{sketch_file} \
  !{database} \
  -o !{illumina_id}.gather.csv 2> !{illumina_id}.err

  '''
  stub:
  """
  touch $illumina_id'.gather.csv'
  touch $illumina_id'.err'
  ""
  """
}