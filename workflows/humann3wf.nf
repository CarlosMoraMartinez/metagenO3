include { concatFastq } from '../modules/concatfastq'
include { doHumann3 } from '../modules/humann3'
include { mergeHumann } from '../modules/merge_humann'
include { translateHumann } from '../modules/translate_humann'

workflow HUMANN3 {
take:
ch_fastq_filtered

main:


if(params.workflows.doHumann3_merge_only){
   println "Running HUMANN3 merge only workflow"
   ch_humann3 = Channel
    .fromPath("${params.resources.mergeHumann3.merge_path}/**/*_{genefamilies,pathabundance,pathcoverage}.tsv")
    //.view{ "Humann3 channel from path: $it" }
    .map { file ->
        def dirName = file.parent.getName().replace("_humann3results", "")
        tuple(dirName, file)
    }
    .groupTuple()
    .map{it -> tuple(it[0], 
                    it[1].find { f -> f.name.endsWith("genefamilies.tsv") }, 
                    it[1].find { f -> f.name.endsWith("pathabundance.tsv") },
                    it[1].find { f -> f.name.endsWith("pathcoverage.tsv") }) 
        } 
    //.view{ "Humann3 channel from path grouped: $it" }

}else{
    //ch_fastq_filtered.view{ "Humann3 input: $it" }
    concatFastq(ch_fastq_filtered)
    ch_concat_fastq = concatFastq.out
        //.view{ "concat fastq output: $it" }
    doHumann3(
            params.doHumann3.bowtie2db,
            params.doHumann3.metaphlan_index, 
            ch_concat_fastq
    )
    ch_humann3 = doHumann3.out
        //.view{ "Humann3 output original: $it" }
}

ch_genefamilies = ch_humann3.map{it -> it[1]}.collect().map{it -> [ "genefamilies", it ] }
ch_pathabundance = ch_humann3.map{it -> it[2]}.collect().map{it -> [ "pathabundance", it ] }
ch_pathcoverage = ch_humann3.map{it -> it[3]}.collect().map{it -> [ "pathcoverage", it ] }
ch_humann3_grouped = ch_genefamilies.concat(ch_pathabundance).concat(ch_pathcoverage)
    //.view{ "Humann3 output flat: $it" }

mergeHumann(ch_humann3_grouped)
ch_humann3_merged = mergeHumann.out
    .view{ "Humann3 output merged: $it" }

//ch_humann3_merged.filter{it[0] == "genefamilies"}.map{it -> it[1]}.view{ "Humann3 merged genefam: $it" }
//ch_humann3_merged.filter{it[0] == "pathabundance"}.map{it -> it[1]}.view{ "Humann3 merged pathabundance: $it" }
//ch_humann3_merged.filter{it[0] == "pathcoverage"}.map{it -> it[1]}view{ "Humann3 merged pathcoverage: $it" }

translateHumann(ch_humann3_merged.filter{it[0] == "genefamilies"}.map{it -> it[1]}, 
                ch_humann3_merged.filter{it[0] == "pathabundance"}.map{it -> it[1]}, 
                ch_humann3_merged.filter{it[0] == "pathcoverage"}.map{it -> it[1]}, 
                params.translateHumann3.cazy_db)
ch_humann3_translated = translateHumann.out
    //.view{ "Humann3 output translated: $it" }

emit:
ch_humann3
ch_humann3_merged
ch_humann3_translated
} 