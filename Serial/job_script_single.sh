#!/bin/bash

#PBS -N mat_ser_1500

#PBS -q serialq

#PBS -l select=1:ncpus=1

#PBS -l walltime=360:00:00

#PBS -j oe

#PBS -V

cd /scratch/scratch_run/shivam.patel/CUDA/SERIAL

cd $PBS_O_WORKDIR

module load openmpi/gcc-8.2.0/4.0.1
module load gcc/8.2.0

cat ${PBS_NODEFILE} > /scratch/scratch_data/shivam.patel/mat_serial_list/mat_serial_list_2.txt

./mat_serial_list
