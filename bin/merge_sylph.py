#!/usr/bin/env python3

import argparse
import pandas as pd
import os
import sys


def read_mpa(file):
    """
    Read a sylphmpa / metaphlan-like file and return a dataframe
    with columns: taxon, abundance
    """
    df = pd.read_csv(
        file,
        sep="\t",
        comment="#",
        header=0
    )

    if df.shape[1] < 2:
        raise ValueError(f"{file} does not look like a valid mpa file")

    df = df.iloc[:, :2]
    df.columns = ["taxon", "abundance"]

    return df


def main():

    parser = argparse.ArgumentParser(
        description="Merge sylph/sylph-tax .sylphmpa files into a single table"
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

        sample = os.path.basename(file).replace(".sylphmpa", "").replace(".fastq.gz", "").replace(".fq.gz", "")

        df = read_mpa(file)
        df = df.set_index("taxon")
        df.columns = [sample]

        if merged is None:
            merged = df
        else:
            merged = merged.join(df, how="outer")

    merged = merged.fillna(0)

    merged.to_csv(args.output, sep="\t")


if __name__ == "__main__":
    main()