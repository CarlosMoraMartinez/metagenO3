sourmash tax prepare -t gtdb-rs220.lineages.csv -o gtdb-rs220.taxonomy.sqldb -F 

sourmash sketch dna -p scaled=100,k=31 /home/carlos/projects/metagenO3/test_data/sample2*.fastq.gz --merge sample2 -o sample2.sig

sourmash gather --dna sample2.sig gtdb-reps-rs220-k31.dna.zip

## with gather

sourmash gather \
  sample2.sig \
  sample2.sig gtdb-reps-rs220-k31.dna.zip \
  -o sample2.gather.csv

sourmash gather \
  C6368.sig \
  C6368.sig gtdb-reps-rs220-k31.dna.zip \
  --estimate-ani \
  -o sample.gather_ani.csv


sourmash tax prepare -t gtdb-rs220.lineages.csv -o gtdb-rs220.taxonomy.sqldb -F 

mkdir -p sample_with_tax
  sourmash tax annotate \
  -g sample.gather.csv \
  -t gtdb-rs220.taxonomy.sqldb \
  -o sample_with_tax

## with LCA
  # classify
sourmash lca classify \
  --db gtdb-reps-rs220-k31.dna.zip \
  --query sample2.sig \
  -o sample2.lca.csv
#   --taxonomy gtdb-rs220.taxonomy.sqldb \
# summarize
sourmash lca summarize \
  --db genbank-k31.sbt.zip \
  --taxonomy genbank-k31.lca.json.gz \
  sample.sig \
  -o sample.summary.csv