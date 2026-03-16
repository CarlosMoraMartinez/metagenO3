
# pre-built databases; includes a fungal one:
# https://github.com/bluenote-1577/sylph/wiki/Pre%E2%80%90built-databases

# multi-sample paired-end profiling (sylph version >= 0.6)
sylph profile /home/carlos/projects/benchmark4real/extra_data/gtdb-r220-c1000-dbv1.syldb -1 test_data/*_1.filt_cut1e6.fastq.gz -2 test_data/*_2.filt_cut1e6.fastq.gz -t 8 > profiling.tsv

mkdir taxonomy_file_folder
sylph-tax download --download-to taxonomy_file_folder

sylph-tax taxprof results.tsv -t GTDB_r214 -o prefix_