
#download /genomes/.vol3/archive/old_refseq/Bacteria/all.gbk.tar.gz
# Uncompress only some

SLAM --parse-taxonomy taxonomy/names.dmp taxonomy/nodes.dmp
SLAM --output-file database1 --parse-genbank bacteria2/*/*.gbk

SLAM --db=/home/carmoma/Documents/Mycobiome/test_software/kslam/database1 --output-file=test_db1 /home/carmoma/projects/TFM_MiguelAngelEsteve/test_data/testA_1.fastq.gz /home/carmoma/projects/TFM_MiguelAngelEsteve/test_data/testA_2.fastq.gz


