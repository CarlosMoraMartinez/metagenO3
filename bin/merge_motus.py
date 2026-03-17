#!/usr/bin/env python3

import argparse
import pandas as pd
import os
import sys


def read_mpa(file, merge_column="consensus_taxonomy"):
    """
    Read a sylphmpa file and return a dataframe
    """
    header = ""
    datalist = []
    of = open(file, 'r')
    for line in of:
        if line.startswith('#'):
            if merge_column in line:
                header = line.strip().replace('#', '').split('\t')
                continue
            else:
                continue
        else:
            datalist.append(line.strip().split('\t'))
    of.close()
    df = pd.DataFrame(datalist, columns=header)
    return df


def main():

    parser = argparse.ArgumentParser(
        description="Merge sylph .sylphmpa files into a single table"
    )

    parser.add_argument(
        "inputs",
        nargs="+",
        help="Input .sylphmpa files"
    )

    parser.add_argument(
        "-o",
        "--output",
        required=True,
        help="Output merged TSV"
    )

    args = parser.parse_args()

    merged = None

    for file in args.inputs:

        sample = os.path.basename(file).replace(".tsv", "").replace(".fastq.gz", "").replace(".fq.gz", "")

        df = read_mpa(file)

        if merged is None:
            merged = df
        else:
            cols = merged.columns.intersection(df.columns)
            merged = pd.merge(merged, df, on=cols.tolist(), how='outer')

    merged = merged.fillna(0)

    merged.to_csv(args.output, sep="\t")


if __name__ == "__main__":
    main()