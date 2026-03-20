
process sourmashSketch{
  label 'mg36_sourmashSketch'
  conda params.sourmashSketch.conda
  cpus params.resources.sourmashSketch.cpus
  memory params.resources.sourmashSketch.mem
  maxForks params.resources.maxForks
  queue params.resources.sourmashSketch.queue 
  //array params.resources.array_size
  clusterOptions params.resources.sourmashSketch.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg36_sourmashSketch", mode: 'symlink'
  input:
  tuple(val(illumina_id), path(fastq))
  
  output:
  tuple(val(illumina_id), path('*.sig'))
  
  shell:
  '''
  sourmash sketch dna -p !{params.sourmashSketch.paramstring} \
        !{fastq.join(' ')} \
        --name !{illumina_id} \
        --merge !{illumina_id} \
        -o !{illumina_id}.sig

  '''
  stub:
  """
  touch $illumina_id'.sig'
  """
}