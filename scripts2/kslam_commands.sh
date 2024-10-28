
#download /genomes/.vol3/archive/old_refseq/Bacteria/all.gbk.tar.gz
# Uncompress only some

SLAM --parse-taxonomy taxonomy/names.dmp taxonomy/nodes.dmp
SLAM --output-file database1 --parse-genbank bacteria2/*/*.gbk