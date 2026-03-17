process removeHeaderMetabuli{
  label 'mg32_metabuli_remove_header'
  conda params.removeHeaderMetabuli.conda
  cpus params.resources.removeHeaderMetabuli.cpus
  memory params.resources.removeHeaderMetabuli.mem
  queue params.resources.removeHeaderMetabuli.queue
  //array params.resources.array_size
  clusterOptions params.resources.removeHeaderMetabuli.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg32_metabuli_remove_header", mode: 'symlink'
  input:
    tuple(val(illumina_id), path(metabuli_path))

  output:
    tuple(val(illumina_id), path(metabuli_path), path("$metabuli_path/*_report_k2.tsv"))
  
  shell:
  '''
   infname=!{metabuli_path}/!{illumina_id}_report.tsv

   outfname=!{metabuli_path}/!{illumina_id}_report_k2.tsv

   grep -v "^#" $infname > $outfname

  '''

  stub:
  """
  touch $metabuli_path/$illumina_id"_report_k2.tsv"
  """
  }

