nextflow run all.nf -c config/run_samples_cluster.config -profile conda -resume -with-report report.html -with-dag pipeline_dag.html

nextflow run all.nf -c config/run_samples_local_UPDATED.config -profile conda -resume -stub