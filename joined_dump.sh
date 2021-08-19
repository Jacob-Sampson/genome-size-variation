# kmc is required for script to WORK_DIR

# USAGE -> bash joined_dump.sh <population 1> <contamination rows 1> <population 2> <contamination rows 2> <output file>


  # Population 1

# Name of directory for population 1
POPULATION_1=$1
# Low multiplicity kmers to be discarded from kmer dump (default is 2)
CONT_1=$2

  # Population 2

# Name of directory for population 2
POPULATION_2=$3
# Low multiplicity kmers to be discarded from kmer dump (default is 2)
CONT_2=$4

  #OUTPUT FILE
OUTPUT=$5


echo "Generating kmer database for $POPULATION_1"
cd $POPULATION_1
mkdir temp
kmc -k27 -cs15000000 -ci$CONT_1 @file_names kmc_database temp
kmc_tools transform kmc_database dump -s kmer_dump
rm kmc_database*
rm temp -r
cd ..

echo "Generating kmer database for $POPULATION_2"
cd $POPULATION_2
mkdir temp
kmc -k27 -cs15000000 -ci$CONT_2 @file_names kmc_database temp
kmc_tools transform kmc_database dump -s kmer_dump
rm kmc_database*
rm temp -r
cd ..

echo "Now joining kmer dumps"
join -o auto -e 0 -a 1 -a 2 $POPULATION_1/kmer_dump $POPULATION_2/kmer_dump > $OUTPUT

echo "Kmer dumps joined, now removing individual dumps"

rm $POPULATION_1/kmer_dump
rm $POPULATION_2/kmer_dump
