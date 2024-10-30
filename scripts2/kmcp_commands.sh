

# computing k-mers
kmcp compute \
    --in-dir refs/ \
    --ref-name-regexp "^([\w\.\_]+\.\d+)" \
    --seq-name-filter "plasmid" \
    --kmer 21 \
    --split-number 10 \
    --split-overlap 150 \
    --out-dir refs-k21-n10 \
    --force

# indexing k-mers
kmcp index \
    --in-dir refs-k21-n10/\
    --num-hash 1 \
    --false-positive-rate 0.3 \
    --out-dir refs-k21-n10.kmcp \
    --force

# clean tmp files
rm -rf refs-k21-n10


kmcp search \
    --db-dir refs-k21-n10.kmcp/ \
    mock_1.fastq.gz \
    mock_2.fastq.gz \
    --out-file mock.kmcp.gz \
    --log mock.kmcp.gz.log

for f in *.kmcp.gz; do
    kmcp profile \
        --taxid-map ../../taxdump-custom/taxid.map \
        --taxdump ../../taxdump-custom/ \
        $f \
        --mode 1 \
        --out-file $f.kmcp.profile \
        --metaphlan-report $f.metaphlan.profile \
        --sample-id 0 \
        --cami-report $f.cami.profile \
        --binning-result $f.binning.gz \
        --log $f.kmcp.profile.log
done


### try to index eupathdb

# computing k-mers
kmcp compute \
    --in-dir /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/eupathdb/library/ \
    --ref-name-regexp "^([\w\.\_]+\.\d+)" \
    --seq-name-filter "plasmid" \
    --kmer 21 \
    --split-number 10 \
    --split-overlap 150 \
    --out-dir refs-k21-n10 \
    --force

# indexing k-mers
kmcp index \
    --in-dir refs-k21-n10/\
    --num-hash 1 \
    --false-positive-rate 0.3 \
    --out-dir eupathdb28.kmcp \
    --force

rm -rf refs-k21-n10


kmcp search \
    --db-dir /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/KMCP/eupathdb28.kmcp \
    /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/fastq/yeast_1.fastq.gz \
    /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/fastq/yeast_2.fastq.gz \
    --out-file mock_yeast_eupathdb.kmcp.gz \
    --log mock_yeast_eupathdb.kmcp.gz.log

for f in *eupathdb.kmcp.gz; do
    kmcp profile \
        --taxid-map /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/eupathdb/intentomapid.map \
        --taxdump taxonomy/ \
        $f \
        --mode 1 \
        --out-file $f.kmcp.profile \
        --metaphlan-report $f.metaphlan.profile \
        --sample-id 0 \
        --cami-report $f.cami.profile \
        --binning-result $f.binning.gz \
        --log $f.kmcp.profile.log
done

## Classify with prebuilt database


kmcp search \
    --db-dir /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/KMCP/refseq-fungi.kmcp \
    /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/fastq/yeast_1.fastq.gz \
    /home/carmoma/projects/TFM_MiguelAngelEsteve/test_software/fastq/yeast_2.fastq.gz \
    --out-file mock_yeast.kmcp.gz \
    --log mock_yeast.kmcp.gz.log

for f in *.kmcp.gz; do
    kmcp profile \
        --taxid-map refseq-fungi.kmcp/taxid.map \
        --taxdump taxonomy/ \
        $f \
        --mode 1 \
        --out-file $f.kmcp.profile \
        --metaphlan-report $f.metaphlan.profile \
        --sample-id 0 \
        --cami-report $f.cami.profile \
        --binning-result $f.binning.gz \
        --log $f.kmcp.profile.log
done