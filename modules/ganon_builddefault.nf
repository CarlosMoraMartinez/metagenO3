process GanonBuildDefault{
  label 'mg24_ganon_builddefault'
  conda params.GanonBuildDefault.conda
  cpus params.resources.GanonBuildDefault.cpus
  memory params.resources.GanonBuildDefault.mem
  queue params.resources.GanonBuildDefault.queue
  //array params.resources.array_size
  clusterOptions params.resources.GanonBuildDefault.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg24_ganon_builddefault", mode: 'symlink'
  input:
  val(db_name)

  output:
  tuple(val(db_name), path(db_name))

  shell:
  '''
  mkdir !{db_name}
  ganon build -g !{params.GanonBuildDefault.genomes} \
    -d !{db_name}/!{db_name} \
    !{params.GanonBuildDefault.extra_args} \
    -t !{params.resources.GanonBuildDefault.cpus} > !{db_name}'.log' 2>!{db_name}'.err'

  '''

  stub:
  """
  mkdir $db_name
  touch $db_name'.log'
  touch $db_name'.err'
  """
}