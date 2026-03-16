process callMetabuli{
  label 'mg30_metabuli'
  conda params.callMetabuli.conda
  cpus params.resources.callMetabuli.cpus
  memory params.resources.callMetabuli.mem
  queue params.resources.callMetabuli.queue
  //array params.resources.array_size
  clusterOptions params.resources.callMetabuli.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg30_metabuli", mode: 'symlink'
  input:
    path metabuli_db
    tuple(val(illumina_id), path(fastq))

  output:
    tuple(val(illumina_id), path("metabuli_$illumina_id"))
  
  shell:
  '''
  maxmem=$(echo !{task.memory} | sed 's/ GB//')

  metabuli classify --max-ram $maxmem --threads !{task.cpus} \
       !{fastq[0]} !{fastq[1]} !{metabuli_db} metabuli_!{illumina_id} !{illumina_id}_
  '''

  stub:
  """
  mkdir metabuli_!{illumina_id}
  """
  }

