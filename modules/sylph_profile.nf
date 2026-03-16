process callSylphProfileSingle{
  label 'mg27_syplhprofile'
  conda params.callSylphProfileSingle.conda
  cpus params.resources.callSylphProfileSingle.cpus
  memory params.resources.callSylphProfileSingle.mem
  queue params.resources.callSylphProfileSingle.queue
  //array params.resources.array_size
  clusterOptions params.resources.callSylphProfileSingle.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg27_syplhprofile", mode: 'symlink'
  input:
  path sylphindex
  tuple(val(illumina_id), path(fastq))

  output:
  tuple(val(illumina_id), path("*.sylph.tsv"))
  

  shell:
  '''
  outfile=!{illumina_id}.sylph.tsv

  sylph profile !{sylphindex} -1 !{fastq[0]} -2 !{fastq[1]} -o $outfile -t !{task.cpus}
  '''

  stub:
  """
  touch $illumina_id'.sylph.tsv'
  """
}