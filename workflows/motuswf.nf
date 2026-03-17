include { callmOTUs } from '../modules/motus.nf'
include { mergemOTUs } from '../modules/motus_merge.nf'

workflow MOTUS {
take:
    ch_fastq_filtered

main:
     
    callmOTUs(ch_fastq_filtered)
    ch_mOTUS= callmOTUs.out
      .view{ "mOTUs output: $it" }
    
    ch_mOTUS_filt = ch_mOTUS
      .map{it -> it[1]}
      .collect()
      .view{ "mOTUs collected output: $it" }

    mergemOTUs(ch_mOTUS_filt)
    ch_mOTUS_merged= mergemOTUs.out
      .view{ "mOTUs merged output: $it" }

    //if(params.resources.callMetabuliRefine.do ){
    //    callMetabuliRefine(params.resources.callMetabuli.taxonomy_path, ch_metabuli)
    //    ch_metabuli_refined = callMetabuliRefine.out
    //    .view{ "Metabuli refined output: $it" }
    //}else{
    //    ch_metabuli_refined = ch_metabuli
    //}
//
    //removeHeaderMetabuli(ch_metabuli_refined)
    //ch_metabuli_noheader = removeHeaderMetabuli.out
    //   .view{ "Metabuli no header output: $it" }
//
    //ch_noheader_collapsed = ch_metabuli_noheader
    //  .map{it -> it[2]}
    //  .collect()
    //  .view{ "Metabuli collected output: $it" }
//
    //taxpastaMerge(params.resources.callMetabuli.taxonomy_path, 
    //              "metabuli", "kraken2", 
    //              params.resources.taxpastaMerge.output_format_metabuli,
    //              ch_noheader_collapsed)
    //ch_taxpasta = taxpastaMerge.out
    //   .view{ "Taxpasta output: $it" }


emit:
    ch_mOTUS
    ch_mOTUS_merged
}