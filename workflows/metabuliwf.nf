include { callMetabuli } from '../modules/metabuli'
include { callMetabuliRefine } from '../modules/metabuli_refine'

workflow METABULI {
take:
    ch_fastq_filtered

main:
     
    callMetabuli(params.resources.callMetabuli.db, ch_fastq_filtered)
    ch_metabuli = callMetabuli.out
      .view{ "Metabuli output: $it" }

    if(params.resources.callMetabuliRefine.do ){
        callMetabuliRefine(params.resources.callMetabuli.db, ch_metabuli)
        ch_metabuli_refined = callMetabuliRefine.out
        .view{ "Metabuli refined output: $it" }
    }else{
        ch_metabuli_refined = ch_metabuli
    }


emit:
    ch_metabuli
    ch_metabuli_refined
}