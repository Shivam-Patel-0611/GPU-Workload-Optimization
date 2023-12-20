#!/bin/bash

#PBS -N mat_par_cuda_1500

#PBS -q serialq

#PBS -l select=1:ngpus=1

#PBS -l walltime=360:00:00

#PBS -j oe

#PBS -V

cd /scratch/scratch_run/shivam.patel/CUDA/CUDA

cd $PBS_O_WORKDIR

module load cuda11.8/toolkit/11.8.0

cat ${PBS_NODEFILE} > /scratch/scratch_data/shivam.patel/mat_CUDA_list/mat_CUDA_list_2.txt

./mat_CUDA_list
