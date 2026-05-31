#!/bin/bash
#SBATCH --job-name=mmp_coral
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=5
#SBATCH --partition=mlogan
#SBATCH --mem=100GB
#SBATCH --output=analysis_%j.log
#SBATCH --mail-user=m.logan@aims.gov.au
#SBATCH --mail-type=ALL

module load singularity
singularity exec -B .:/home/Project gcrmn_alt2.sif make run_R
