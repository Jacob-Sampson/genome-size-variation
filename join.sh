# Usage join.sh <input file 1> <input file 2> <output file>

INPUT_FILE_1=$1		#Path of the first file to be joined
INPUT_FILE_2=$2			#Path of the second file to be joined
OUTPUT_FILE=$3			#Path and name of the output file


join -o auto -e 0 -a 1 -a 2 $INPUT_FILE_1 $INPUT_FILE_2 > $OUTPUT_FILE

echo $INPUT_FILE_1 " has been successfully joined to " $INPUT_FILE_2
