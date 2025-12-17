#!/bin/bash

#################################################################################################################
## script para el quality control de los ficheros                                                              ##
##                                                                                                             ##
## SBATCH --job-name=name: Nombre del trabajo                                                                  ##
## SBATCH --output=dir/name_%A_%a.out #archivo_%j.out: Directorio y nombre del fichero de salida               ##
## SBATCH --error=dir/name_%A_%a.err #archivo_%j.err: Directorio y nombre del ficherro de errores              ##
## SBATCH --array=1-n: paralelizacion del trabajo, lanza simultaneamente 16 trabajos                           ##
## SBATCH --partition=long: la particion que queremos usar                                                     ##
##          "slimits" para ver las opciones                                                                    ##
## SBATCH --cpus-per-task 4                                                                                    ##
## SBATCH --mem 10G                                                                                            ##
#################################################################################################################

#SBATCH --job-name=K2std1
#SBATCH -o slurm.%N.%j.out
#SBATCH -e slurm.%N.%j.err
#SBATCH --qos=long
#SBATCH --cpus-per-task 4
#SBATCH --mem=16G
#SBATCH --time=8-00:00:00 # 8 días 

#Do this before executing sbatch
module load anaconda #3_2022.10

nextflow run all.nf -c config/launch_downloaded_datasets/run_garnatxa_study2.config -profile conda -resume -with-report report2.html -with-dag pipeline_dag2.html

#nextflow run all.nf -c config/launch_downloaded_datasets/run_garnatxa_study3.config -profile conda -resume -with-report report3.html -with-dag pipeline_dag3.html