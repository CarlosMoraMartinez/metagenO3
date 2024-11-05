

include { GanonClassify } from '../modules/ganon_classify.nf'
include { GanonBuildDefault } from '../modules/ganon_builddefault.nf'
include { GanonBuildCustom } from '../modules/ganon_buildcustom.nf'



workflow GANON2 {
  take:
  ch_fastq_filtered

  main:

  if(params.GanonBuildDefault.do){
    GanonBuildDefault(
        params.GanonBuildDefault.db_name
    )
    ch_ganonbuild_output = GanonBuildDefault.out
    .view{"GanonBuildDefault output: $it"}

  }else if(params.GanonBuildCustom.do){
    GanonBuildCustom(
        params.GanonBuildCustom.db_name,
        params.GanonBuildCustom.input_file
    )
    ch_ganonbuild_output = GanonBuildCustom.out
    .view{"GanonBuildCustom output: $it"}

  }else{
    ch_ganonbuild_output = Channel.from([])
    ch_ganonbuild_output = Channel.from([
        params.GanonClassify.db_name,
        params.GanonClassify.database
    ])
  }

  ch_ganonclassify_in = ch_ganonbuild_output
  .combine(ch_fastq_filtered)
  .view{"GanonClassify input: $it"}

  GanonClassify(ch_ganonclassify_in)
  ch_ganonclassify_out = GanonClassify.out
   .view{"GanonClassify output: $it"}

  emit:
  ch_ganonbuild_output
  ch_ganonclassify_out

}