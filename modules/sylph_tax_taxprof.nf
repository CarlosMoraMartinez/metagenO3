process callSylphTaxprof{
  label 'mg28_syplh_taxprof'
  conda params.callSylphTaxprof.conda
  cpus params.resources.callSylphTaxprof.cpus
  memory params.resources.callSylphTaxprof.mem
  queue params.resources.callSylphTaxprof.queue
  //array params.resources.array_size
  clusterOptions params.resources.callSylphTaxprof.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg28_syplh_taxprof", mode: 'symlink'
  input:
  tuple(val(illumina_id), path(sylph_result))

  output:
  tuple(val(illumina_id), path("sylphtax_*.sylphmpa"), path("pavian_*.sylphmpa"))
  

  shell:
  if( params.callSylphProfile.separate_samples )
  '''

  sylph-tax taxprof !{sylph_result} -t !{params.resources.callSylphTaxprof.taxonomy_db} \
      -o sylphtax_!{params.resources.callSylphTaxprof.taxonomy_db}_

  sylph-tax taxprof !{sylph_result} -t !{params.resources.callSylphTaxprof.taxonomy_db} \
      -o pavian_!{params.resources.callSylphTaxprof.taxonomy_db}_

  '''
  else
  '''

  sylph-tax taxprof !{sylph_result} -t !{params.resources.callSylphTaxprof.taxonomy_db} \
      -o sylphtax_!{params.resources.callSylphTaxprof.taxonomy_db}_

  sylph-tax taxprof !{sylph_result} -t !{params.resources.callSylphTaxprof.taxonomy_db} \
      -o pavian_!{params.resources.callSylphTaxprof.taxonomy_db}_

  '''

  stub:
  """
  touch $illumina_id'.sylph.tsv'
  """
}
