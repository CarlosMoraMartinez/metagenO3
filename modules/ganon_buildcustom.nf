process GanonBuildCustom{
  label 'mg24_ganon_buildcustom'
  conda params.GanonBuildCustom.conda
  cpus params.resources.GanonBuildCustom.cpus
  memory params.resources.GanonBuildCustom.mem
  queue params.resources.GanonBuildCustom.queue
  //array params.resources.array_size
  clusterOptions params.resources.GanonBuildCustom.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg24_ganon_buildcustom_$db_name", mode: 'symlink'
  input:
  val(db_name)
  path(input_file)

  output:
  tuple(val(db_name), path(db_name))

  shell:
  '''
  mkdir !{db_name}

   ganon build-custom -e !{params.GanonBuildCustom.fasta_extension} \
    -d !{db_name}/!{db_name} \
    --input-file !{input_file} \
    !{params.GanonBuildCustom.taxonomy} \
    !{params.GanonBuildCustom.extra_args} \
    -t !{params.resources.GanonBuildCustom.cpus} > !{db_name}'.log' 2>!{db_name}'.err'

  '''

  stub:
  """
  mkdir $db_name
  touch $db_name'.log'
  touch $db_name'.err'
  """
}