
process sourmashTaxPrepare{
  label 'mg37_sourmashTaxPrepare'
  conda params.sourmashTaxPrepare.conda
  cpus params.resources.sourmashTaxPrepare.cpus
  memory params.resources.sourmashTaxPrepare.mem
  maxForks params.resources.maxForks
  queue params.resources.sourmashTaxPrepare.queue 
  //array params.resources.array_size
  clusterOptions params.resources.sourmashTaxPrepare.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg37_sourmashTaxPrepare", mode: 'symlink'
  input:
  path(taxonomy)
  
  output:
  path "*.sqldb"
  
  shell:
  '''
  outname=$(basename -s .csv !{taxonomy}).sqldb

  sourmash tax prepare -t !{taxonomy} -o $outname

  '''

  stub:
  """
  touch \$(basename -s .csv $taxonomy)'.sqldb'
  
  """
}