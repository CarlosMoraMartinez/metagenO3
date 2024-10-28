
# https://gitlab.umiacs.umd.edu/derek/krakenuniq
krakenuniq-download --db DBDIR --threads 10 --dust  refseq/archaea

krakenuniq-build --db DBDIR
krakenuniq-build --db DBDIR --jellyfish-bin $(which jellyfish)