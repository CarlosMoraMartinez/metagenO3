process callSylphProfileMany{
  label 'mg27_syplhprofile'
  conda params.callSylphProfileMany.conda
  cpus params.resources.callSylphProfileMany.cpus
  memory params.resources.callSylphProfileMany.mem
  queue params.resources.callSylphProfileMany.queue
  //array params.resources.array_size
  clusterOptions params.resources.callSylphProfileMany.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg27_syplhprofile", mode: 'symlink'
  input:
  path sylphindex
  tuple(val(illumina_ids), path(fastq1), path(fastq2))

  output:
  tuple(val(illumina_ids), path("*.sylph.tsv"))
  

  shell:
  '''
  outfile=all_samples.sylph.tsv

  sylph profile !{sylphindex} -1 !{fastq1} -2 !{fastq2} -o $outfile -t !{task.cpus}
  '''

  stub:
  """
  touch all_samples.sylph.tsv
  """
}