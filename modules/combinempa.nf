process combineMpa{
  label 'mg09_combinempa'
  conda params.combineMpa.conda
  cpus params.resources.combineMpa.cpus
  memory params.resources.combineMpa.mem
  queue params.resources.combineMpa.queue
  clusterOptions params.resources.combineMpa.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg09_combinempa_$programlab", mode: 'copy'
  input:
  tuple(val(programlab), val(taxonomy_level_name), path(mpa), val(letter))

  output:
  tuple(val(programlab), val(taxonomy_level_name), path("*.mpa.combined.txt"), path("*.mpa.combined.clean1.txt"), path("*.mpa.combined.clean2.txt"))
  

  shell:
  '''
  outfile=!{taxonomy_level_name}.!{programlab}.mpa.combined.txt
  outfile2=!{taxonomy_level_name}.!{programlab}.mpa.combined.clean1.txt
  outfile3=!{taxonomy_level_name}.!{programlab}.mpa.combined.clean2.txt

  combine_mpa.py -i !{mpa} -o $outfile
  grep -E "(!{letter}__)|(#Classification)" $outfile > $outfile2
  sed -e 's/.!{taxonomy_level_name}.!{programlab}.bracken.report.txt//g' $outfile2 > $outfile3

  '''

  stub:
  """
  touch $taxonomy_level_name'.'$programlab'.mpa.combined.txt'
  touch $taxonomy_level_name'.'$programlab'.mpa.combined.clean1.txt'
  touch $taxonomy_level_name'.'$programlab'.mpa.combined.clean2.txt'
  """
}