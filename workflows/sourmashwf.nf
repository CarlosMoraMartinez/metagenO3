include { sourmashSketch } from '../modules/sourmash_sketch'
include { sourmashTaxPrepare } from '../modules/sourmash_taxprep'
include { sourmashGather } from '../modules/sourmash_gather'
include { sourmashTaxAnnotate } from '../modules/sourmash_taxannotate'



workflow SOURMASH {
  take:
  ch_fastq_filtered

  main:
    
    ch_smash_database = Channel.fromPath(params.sourmashGather.database)

    if(params.resources.sourmashTaxPrepare.do){
      ch_Tax = Channel.fromPath(params.sourmashTaxPrepare.taxonomy_raw )
      sourmashTaxPrepare(ch_Tax)
        .view{"sourmashTaxPrepare output: $it"}
      ch_Tax_prep = sourmashTaxPrepare.out
    }else{
      ch_Tax_prep = Channel.fromPath(params.sourmashTaxAnnotate.taxonomy_prep)
    }


    sourmashSketch(ch_fastq_filtered)
    ch_sourmash_sketch = sourmashSketch.out
        .view{"sourmashSketch output: $it"}

    if(params.sourmashGather.do){
      sourmashGather(ch_smash_database, ch_sourmash_sketch)
      ch_sourmash_gather = sourmashGather.out
        .view{"sourmashGather output: $it"}
        .map{it -> [it[0], it[1]]}

      sourmashTaxAnnotate(ch_Tax_prep, ch_sourmash_gather)
      ch_sourmash_gather_tax = sourmashTaxAnnotate.out
        .view{"sourmashTaxAnnotate output: $it"}

    }else{
      ch_sourmash_gather = Channel.from([])
      ch_sourmash_gather_tax = Channel.from([])
    }


    

    
emit:
  ch_Tax_prep
  ch_sourmash_sketch
  ch_sourmash_gather
  ch_sourmash_gather_tax
}