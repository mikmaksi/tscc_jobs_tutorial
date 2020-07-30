#!/bin/bash
#PBS -q hotel
#PBS -N test
#PBS -l nodes=1:ppn=1
#PBS -l walltime=00:15:00
#PBS -o job.o
#PBS -e job.e 
#PBS -V
#PBS -t 1-12
#PBS -A gymreklab-group

# about: launch an array job on TSCC
# -q: the queue name (see TSCC instructions)
# -l: number of nodes and processors per node request; max run time
# -o and -e: names for log files from the job (stdout and stderr)
# -t: specifies the array indices; must be contiguous; environmental variable names PBS_ARRAYID will be set equal to each index when the job starts
# -V: use environment from which qsub was launched
# -A: need to specify group id for charging copute resources

# cd into main analysis directory; this is necessary b/c job will not start in your project space
cd /projects/ps-gymreklab/mikhail/tscc_jobs_tutorial

# config
proc_list='_to_proc' # a list that has some parameters for your job

# debug
# PBS_ARRAYID=1

# get proc params; in this example were processing six chromosomes in 2 files; PBS_ARRAYID is used to grab the correct line
proc_params=`sed -n "${PBS_ARRAYID},${PBS_ARRAYID}p" $proc_list`
FS=' '; read -a proc_params <<< "$proc_params"
chrom=${proc_params[0]}
file=${proc_params[1]}

# make output directory
out_dir='data' && mkdir -p $out_dir

# example script is a shell script, but it could be a .py or .R or any other executable
cmd="simple_script.sh $file $chrom > ${out_dir}/${file}_${chrom}.out"
echo $cmd
eval $cmd
