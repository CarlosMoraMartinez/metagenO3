
process sourmashTaxAnnotate{
  label 'mg36_sourmashTaxAnnotate'
  conda params.sourmashTaxAnnotate.conda
  cpus params.resources.sourmashTaxAnnotate.cpus
  memory params.resources.sourmashTaxAnnotate.mem
  maxForks params.resources.maxForks
  queue params.resources.sourmashTaxAnnotate.queue 
  //array params.resources.array_size
  clusterOptions params.resources.sourmashTaxAnnotate.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg36_sourmashTaxAnnotate", mode: 'symlink'
  input:
  path(taxonomy_db)
  tuple(val(illumina_id), path(smash_result))
  
  output:
  tuple(val(illumina_id), path('*_smashgather_tax'))
  
  shell:
  '''
  newdir=!{illumina_id}_smashgather_tax
  mkdir -p $newdir

  sourmash tax annotate \
  -g !{smash_result} \
  -t !{taxonomy_db} \
  -o $newdir

  '''
  stub:
  """
  mkdir $illumina_id'_smashgather_tax'
  """
}