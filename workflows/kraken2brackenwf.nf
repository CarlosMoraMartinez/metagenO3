

include { callKraken2 } from '../modules/kraken2'
include { callKrakenUniq } from '../modules/krakenuniq'
include { callBracken } from '../modules/bracken'
include { braken2mpa } from '../modules/bracken2mpa'
include { combineMpa } from '../modules/combinempa'
include { callKronaFromKraken2 } from '../modules/krona'


workflow KRAKEN2BRACKEN {
  take:
  ch_fastq_filtered

  main:
  //Call Kraken2

  if(params.callKraken2.do){
    callKraken2(params.callKraken2.k2database,
            params.callKraken2.confidence,
            ch_fastq_filtered
    )
    ch_kraken2_output = callKraken2.out
    //.view{"Kraken2 output: $it"}

    ch_bracken_input1 = ch_kraken2_output
        .map{it -> tuple('K2', params.callKraken2.k2database, it[0], it[2])}
        .combine(Channel.of(['species', 'S'],['genus', 'G'],['phylum', 'P']))
        //.view{"Bracken input form Kraken2: $it"}

  }else{
    ch_kraken2_output = Channel.from([])
    ch_bracken_input1 = Channel.from([])
  }

  if(params.callKrakenUniq.do){
    callKrakenUniq(
            params.callKrakenUniq.kudatabase,
            ch_fastq_filtered
    )
    ch_krakenuniq_output = callKrakenUniq.out
    //.view{"Krakenuniq output: $it"}

    ch_bracken_input2 = ch_krakenuniq_output
        .map{it -> tuple('KU', params.callKrakenUniq.kudatabase, it[0], it[2])}
        .combine(Channel.of(['species', 'S'],['genus', 'G'],['phylum', 'P']))
        //.view{"Bracken input fom KrakenUniq: $it"}

  }else{
    ch_krakenuniq_output = Channel.from([])
    ch_bracken_input2 = Channel.from([])
  }

  //Call Bracken
  if(params.callBracken.do){
    ch_bracken_input = ch_bracken_input1.concat(ch_bracken_input2)

    callBracken(ch_bracken_input)

    ch_bracken_output = callBracken.out
      //.view{"Bracken output: $it"}

    //Transform to mpa and merge
    ch_transform2mpa_input = ch_bracken_output
       .map{it -> tuple(it[0], it[1], it[2], it[4])}
    braken2mpa(ch_transform2mpa_input)
    ch_transform2mpa_output = braken2mpa.out
      //.view{"Transform to MPA output: $it"}

    ch_combineMpa_input = ch_transform2mpa_output
       .map{it -> tuple(it[0], it[2], it[3])}
       .groupTuple(by:[0, 1])
       .map{it -> tuple(it[0], it[1], it[2], it[1][0])} //[1].join(' ') -> it is not necessary to concat files as a string
       //.view{"Combine MPA input: $it"}
    combineMpa(ch_combineMpa_input)
    ch_combineMpa_output = combineMpa.out
       //.view{"Combine MPA output: $it"}
 
  }else{
    ch_bracken_output  = Channel.from([])
    ch_transform2mpa_output  = Channel.from([])
    ch_combineMpa_output  = Channel.from([])
  }

  //callKronaFromKraken2: Krona plot from Kraken report
  if(params.resources.callKronaFromKraken2.do_krona){
    ch_krona_input = ch_kraken2_output
        .map{it -> tuple(it[0], it[2])}
    callKronaFromKraken2(ch_krona_input)
    ch_krona_output = callKronaFromKraken2.out
     //.view{ "Krona output: $it" }
  }else{
    ch_krona_output = Channel.from([])
  }
  emit:
  ch_kraken2_output
  ch_krakenuniq_output
  ch_bracken_output
  ch_transform2mpa_output
  ch_combineMpa_output
  ch_krona_output
}