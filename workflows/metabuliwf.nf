include { callMetabuli } from '../modules/metabuli'
include { callMetabuliRefine } from '../modules/metabuli_refine'
include { removeHeaderMetabuli } from '../modules/metabuli_remove_header'
include  { taxpastaMerge } from '../modules/taxpasta_merge'


workflow METABULI {
take:
    ch_fastq_filtered

main:
     
    callMetabuli(params.resources.callMetabuli.db, ch_fastq_filtered)
    ch_metabuli = callMetabuli.out
      .view{ "Metabuli output: $it" }

    if(params.resources.callMetabuliRefine.do ){
        callMetabuliRefine(params.resources.callMetabuli.taxonomy_path, ch_metabuli)
        ch_metabuli_refined = callMetabuliRefine.out
        .view{ "Metabuli refined output: $it" }
    }else{
        ch_metabuli_refined = ch_metabuli
    }

    removeHeaderMetabuli(ch_metabuli_refined)
    ch_metabuli_noheader = removeHeaderMetabuli.out
       .view{ "Metabuli no header output: $it" }

    ch_noheader_collapsed = ch_metabuli_noheader
      .map{it -> it[2]}
      .collect()
      .view{ "Metabuli collected output: $it" }

    taxpastaMerge(params.resources.callMetabuli.taxonomy_path, 
                  "metabuli", "kraken2", 
                  params.resources.taxpastaMerge.output_format_metabuli,
                  ch_noheader_collapsed)
    ch_taxpasta = taxpastaMerge.out
       .view{ "Taxpasta output: $it" }


emit:
    ch_metabuli
    ch_metabuli_refined
    ch_taxpasta
}