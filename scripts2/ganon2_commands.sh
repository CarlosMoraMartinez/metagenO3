

ganon build -g archaea bacteria fungi protozoa -d ArcBctFngPrt -c -t 30

ganon build -g fungi protozoa -d FngPrt -c -t 30


ganon classify --db-prefix FngPrt \
  --rel-cutoff 0.75 \
  --rel-filter 0.1 \
  --min-count 0.00005 \
  --multiple-matches em \
  --report-type abundance \
  --paired-reads /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/fastq/yeast_1.fastq.gz /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/fastq/yeast_2.fastq.gz \
  --output-prefix results_ganon_test --threads 12


ganon classify --db-prefix FngPrt \
  --binning \
  --report-type abundance \
  --paired-reads /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/fastq/yeast_1.fastq.gz /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/fastq/yeast_2.fastq.gz \
  --output-prefix results_ganon_test2 --threads 12

  ganon report --db-prefix FngPrt --input results_ganon_test.rep --output-prefix tax_profile --report-type abundance

  ## Build custom

  ganon build-custom -e 'fna' -d eupath_ganon2 --taxonomy skip \
    -i /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/eupathdb/library 

  ganon classify --db-prefix eupath_ganon2 \
  --rel-cutoff 0.75 \
  --rel-filter 0.1 \
  --min-count 0.00005 \
  --multiple-matches em \
  --report-type abundance \
  --paired-reads /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/fastq/yeast_1.fastq.gz /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/fastq/yeast_2.fastq.gz \
  --output-prefix results_ganon_eupath1 --threads 12  

  ganon build-custom -e 'fna' \
    -i /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/eupathdb/library \
    --skip-genome-size \
    -d eupath_ganon2 -l species \
    -n /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/eupathdb/intentomapid.map \
    --taxonomy-files /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/KMCP/taxonomy