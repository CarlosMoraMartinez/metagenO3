process taxpastaMerge{
  label 'mg33_taxpasta_merge'
  conda params.taxpastaMerge.conda
  cpus params.resources.taxpastaMerge.cpus
  memory params.resources.taxpastaMerge.mem
  queue params.resources.taxpastaMerge.queue
  //array params.resources.array_size
  clusterOptions params.resources.taxpastaMerge.clusterOptions
  errorStrategy { task.exitStatus in 1..2 ? 'retry' : 'ignore' }
  maxRetries 10
  publishDir "$results_dir/mg33_taxpasta_merge_${tool_name}", mode: 'symlink'
  input:
    path taxonomy
    val tool_name
    val input_format
    val output_format
    path input_profiles

  output:
    tuple(path("*merged_full.${output_format}"), path("*merged_species.${output_format}"), path("*merged_genus.${output_format}") )
  
  shell:
  '''
  outname1=!{tool_name}_taxpasta_merged_full.!{output_format}
  outname2=!{tool_name}_taxpasta_merged_species.!{output_format}
  outname3=!{tool_name}_taxpasta_merged_genus.!{output_format}

  taxpasta merge -p !{input_format} \
      --taxonomy !{taxonomy} \
      --add-lineage --add-name --add-rank --wide \
      -o $outname1 \
     --output-format !{output_format} \
      !{input_profiles}

  taxpasta merge -p !{input_format} \
      --taxonomy !{taxonomy} \
      --add-lineage --add-name --add-rank --wide \
      -o $outname2 \
      --output-format !{output_format} \
      --summarise-at species \
      !{input_profiles}

   taxpasta merge -p !{input_format} \
      --taxonomy !{taxonomy} \
      --add-lineage --add-name --add-rank --wide \
      -o $outname3 \
     --output-format !{output_format} \
     --summarise-at genus \
      !{input_profiles}

  '''

  stub:
  """
  touch $tool_name"_taxpasta_merged_full."$output_format
  touch $tool_name"_taxpasta_merged_species."$output_format
  touch $tool_name"_taxpasta_merged_genus."$output_format
  """
  }

