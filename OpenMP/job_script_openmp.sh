#!/bin/bash

#PBS -N mat_par_cpu_1500

#PBS -q serialq

#PBS -l select=1:ncpus=8

#PBS -l walltime=360:00:00

#PBS -j oe

#PBS -V

cd /scratch/scratch_run/shivam.patel/CUDA/OPENMP

cd $PBS_O_WORKDIR

module load openmpi/gcc-8.2.0/4.0.1
module load gcc/8.2.0

export OMP_NUM_THREADS=8

cat ${PBS_NODEFILE} > /scratch/scratch_data/shivam.patel/mat_OPENMP_list/mat_OPENMP_list_2.txt

./mat_openmp_list
