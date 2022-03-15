#!/bin/bash

SGE_ROOT="/scratch/apps/sge"

while IFS== read key val; do
    case "$key" in
        NHOSTS) NHOSTS="$val";;
        CUDA_VISIBLE_DEVICES) cudadev="$val";;
        QUEUE) myqueue=="$val";;
    esac
done <environment

while IFS== read key val; do
    case "$key" in
        pe) PE="$val";;
        pe_slots)  pe_slots="$val";;
        host_slots)NSLOTS="$val";;
        job_name)  job_name="$val";;
        job_id)    JOB_ID="$val";;
        ja_task_id) TASK_ID="$val";;
        pe_hostfile) pe_hostfile="$val";;
    esac
done <config


if [ "$job_name" = "petask" ]
then
   NSLOTS=${pe_slots}
fi

export NCORES=${NSLOTS}
# 2GB RAM for each process?
let "MEMS = $NCORES * 4"

let "PROCS = 3 + $NCORES"

if [ "$job_name" = "petask" ]
then
   let "PROCS = $PROCS + 2*${NHOSTS}"
fi

if [ ! -z "$PE" && "$PE" = "omp" ]
then
     export OMP_NUM_THREADS=${NSLOTS}
fi

let "CSHARE = $NCORES * 1024"


exec systemd-run --unit=sge-shepherd-$JOB_ID-$TASK_ID --scope  --slice=sge-shepherd-$JOB_ID-$TASK_ID -p MemoryLimit=${MEMS}G -p CPUShares=${CSHARE} ${SGE_ROOT}/bin/linux-x64/sge_shepherd $@
