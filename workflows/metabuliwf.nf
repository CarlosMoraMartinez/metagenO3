include { callMetabuli } from '../modules/metabuli'

workflow METABULI {
take:
    ch_fastq_filtered

main:
     
    callMetabuli(params.resources.callMetabuli.db, ch_fastq_filtered)
    ch_metabuli = callMetabuli.out
      .view{ "Metabuli output: $it" }

emit:
    ch_metabuli
}