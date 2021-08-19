# kmc is required for script to work

# USAGE -> bash dump.sh <population directory> <contamination rows> <output file>


  # Population 1

# Name of directory for population
POPULATION_ID=$1
# Low multiplicity kmers to be discarded from kmer dump (default is 2)
CONT=$2

  #OUTPUT FILE
OUTPUT=$3


echo "Generating kmer dump for $POPULATION_ID"
cd $POPULATION_ID
mkdir temp
kmc -k27 -cs15000000 -ci$CONT @file_names kmc_database temp
kmc_tools transform kmc_database dump -s $OUTPUT
rm kmc_database*
rm temp -r
cd ..
