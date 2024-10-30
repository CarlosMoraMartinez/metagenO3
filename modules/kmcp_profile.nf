process KMCPProfile{
  label 'mg23_kmcp_profile'
  conda params.KMCPProfile.conda
  cpus params.resources.KMCPProfile.cpus
  memory params.resources.KMCPProfile.mem
  queue params.resources.KMCPProfile.queue
  //array params.resources.array_size
  clusterOptions params.resources.KMCPProfile.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg23_kmcp_profile", mode: 'symlink'
  input:
  path taxidmap
  path taxonomy
  tuple(val(illumina_id), val(db_name), path(samplekmcp))

  output:
  tuple(val(illumina_id), val(db_name), path("*kmcp.profile"), path("*kmcp.profile.metaphlan"), path("*kmcp.profile.cami"), path("*kmcp.profile.binning.gz"), path("*kmcp.profile.log"), )
  

  shell:
  '''
  outname=!{illumina_id}_!{db_name}.kmcp.profile

  kmcp profile \
        --taxid-map !{taxidmap} \
        --taxdump !{taxonomy} \
        !{samplekmcp} \
        --threads !{params.resources.KMCPProfile.cpus}
        --mode !{params.KMCPProfile.mode} \
        !{params.KMCPProfile.extra_args} \
        --out-file $outname \
        --metaphlan-report $outname'.metaphlan' \
        --sample-id 0 \
        --cami-report $outname'.cami' \
        --binning-result $outname'.binning.gz' \
        --log $outname'.log' 2> $outname'.err'

  '''

  stub:
  """
  touch $illumina_id'_'$db_name'.kmcp.profile'
  touch $illumina_id'_'$db_name'.kmcp.profile.metaphlan'
  touch $illumina_id'_'$db_name'.kmcp.profile.cami'
  touch $illumina_id'_'$db_name'.kmcp.profile.binning.gz'
  touch $illumina_id'_'$db_name'.kmcp.profile.log'
  """
}