

include { KMCPComputeKmers } from '../modules/kmcp_computekmers.nf'
include { KMCPIndex } from '../modules/kmcp_index.nf'
include { KMCPSearch } from '../modules/kmcp_search.nf'
include { KMCPProfile } from '../modules/kmcp_profile.nf'



workflow KMCP {
  take:
  ch_fastq_filtered

  main:

  if(params.KMCPComputeKmers.do){
    KMCPComputeKmers(
        params.KMCPComputeKmers.db_name,
        params.KMCPComputeKmers.fasta_dir
    )
    ch_kmers_output = KMCPComputeKmers.out
    .view{"KMCPcomputeKmers output: $it"}

    ch_kmcp_index_in = ch_kmers_output.map{it -> tuple(it[0], it[1])}
    KMCPIndex(ch_kmcp_index_in)
    ch_kmcp_index_out = KMCPIndex.out
    .view{"KMCPIndex output: $it"}

  }else{
    ch_kmers_output = Channel.from([])
    ch_kmcp_index_out = Channel.from([
        params.KMCPSearch.db_name,
        params.KMCPSearch.database
    ])
  }

  ch_kmcpsearch_in = ch_kmcp_index_out
  .map{it -> tuple(it[0], it[1])}
  .combine(ch_fastq_filtered)
  .view{"KMCPSearch input: $it"}
  KMCPSearch(ch_kmcpsearch_in)
  ch_kmcpsearch_out = KMCPSearch.out
   .view{"KMCPSearch output: $it"}

  ch_kmcpprofile_in = ch_kmcpsearch_out
  .map{it -> it[0..2]}
  KMCPProfile(
    params.KMCPProfile.taxidmap,
    params.KMCPProfile.taxonomy,
    ch_kmcpprofile_in
  )
  ch_kmcpprofile_out = KMCPProfile.out
  .view{"KMCPProfile output: $it"}

  emit:
  ch_kmcp_index_out
  ch_kmcpprofile_out

}