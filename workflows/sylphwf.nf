include { callSylphProfileSingle } from '../modules/sylph_profile'
include { callSylphProfileMany } from '../modules/sylph_profile_many'
include { callSylphTaxprof } from '../modules/sylph_tax_taxprof'
include { mergeSylph } from '../modules/sylph_merge'

workflow SYLPH {
take:
    ch_fastq_filtered

main:
    
     
    if(params.callSylphProfile.separate_samples){
        callSylphProfileSingle(
                params.callSylphProfile.sylphdb,
                ch_fastq_filtered
        )
        ch_sylph = callSylphProfileSingle.out
            .view{ "callSylphProfileSingle output: $it" }

    }else{
        ch_fastq_filtered_grouped = ch_fastq_filtered
            .collect{it -> [it]}
            .view{ "callSylphProfileMany input 1: $it" }
            .map { all_samples ->
                def ids = all_samples.collect { it->it[0] }
                def r1s = all_samples.collect { it->it[1][0] }
                def r2s = all_samples.collect { it->it[1][1] }
                return tuple(ids, r1s, r2s)
            }
            .view{ "callSylphProfileMany input: $it" }
            
        callSylphProfileMany(
                params.callSylphProfile.sylphdb,
                ch_fastq_filtered_grouped
        )
        ch_sylph = callSylphProfileMany.out
            .view{ "callSylphProfileMany output: $it" }
    }

    callSylphTaxprof(ch_sylph)
    ch_taxonomy = callSylphTaxprof.out
        .view{ "callSylphTaxprof output: $it" }

    if(!params.callSylphProfile.separate_samples){
        ch_taxonomy_only_mpa = ch_taxonomy
        .map { rows -> rows[1].collect() }
        .view{ "callSylphTaxprof output mod: $it" }

    }else{
        ch_taxonomy_only_mpa = ch_taxonomy
        .map { it -> it[1] }
        .collect()
        .view{ "callSylphTaxprof output mod: $it" }
    }
    
    mergeSylph(ch_taxonomy_only_mpa)
    ch_sylph_merged = mergeSylph.out
      .view{ "Sylph merged output: $it" }
 

emit:
    ch_sylph
    ch_taxonomy
    ch_taxonomy_only_mpa
    ch_sylph_merged
}