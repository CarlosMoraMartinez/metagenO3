process callKrakenUniq{
  label 'mg06_krakenuniq'
  conda params.callKrakenUniq.conda
  cpus params.resources.callKrakenUniq.cpus
  memory params.resources.callKrakenUniq.mem
  queue params.resources.callKrakenUniq.queue
  //array params.resources.array_size
  clusterOptions params.resources.callKrakenUniq.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg06_krakenuniq", mode: 'symlink'
  input:
  path kudatabase
  tuple(val(illumina_id), path(fastq))

  output:
  tuple(val(illumina_id), path("*standard.krakenuniq.gz"), path("*.standard.krakenuniq.report") ,path("*txku.fastq.gz"), path("*krakenuniq.err"))
  

  shell:
  '''
  outfile=!{illumina_id}.standard.krakenuniq
  report=!{illumina_id}.standard.krakenuniq.report
  unclassified=!{illumina_id}.unclassified
  summary=!{illumina_id}.standard.krakenuniq.err

  krakenuniq --db !{kudatabase} \
        --threads !{params.resources.callKrakenUniq.cpus} \
        --unclassified-out $unclassified'_1.txku.fastq' \
        --hll-precision !{params.callKrakenUniq.hllprecision} \
        --paired !{fastq[0]} !{fastq[1]} \
        --output $outfile \
        --report-file $report 2> $summary
  pigz -p 4 $unclassified'_1.txku.fastq' $unclassified'_2.txku.fastq'
  pigz -p 4 $outfile
  '''

  stub:
  """
  touch $illumina_id'.unclassified_1.txku.fastq.gz'
  touch $illumina_id'.standard.krakenuniq.gz'
  touch $illumina_id'.standard.krakenuniq.err'
  touch $illumina_id'.standard.krakenuniq.report'
  """

}