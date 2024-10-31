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
  publishDir "$results_dir/mg24_ganon_buildcustom", mode: 'symlink'
  input:
  val(db_name)
  path(fasta_dir)

  output:
  tuple(val(db_name), path(db_name))

  shell:
  '''
  mkdir !{db_name}

   ganon build-custom -e !{params.GanonBuildCustom.fasta_extension} \
    -d !{db_name}/!{db_name} --taxonomy skip --skip-genome-size \
    -i !{fasta_dir} \
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