#REF is the ID of the population which will be used as a reference.
REF = ("E022" "E023" "E033" "E034" "E035")
#KMER_DUMP is the input file used to carry out the kmer analysis. Each row should contain a kmer followed by the coverage in each population.
KMER_DUMP = "E022_E023_E033_E034_E035_private_kmers"
#OUTPUT_FILE is the text file which will contain the comparison statistics
OUTPUT_FILE = "micrantha_stats.txt"

#kmer_stats is the function which will compare how many kmers are shared between the reference and the comparison sample.
kmer_stats () {
	echo 'Number of kmers where' $ID'_cov != 0 and '$element'_cov != 0' >> $OUTPUT_FILE
	awk -v a=$col -v b=${variables[$element]} '{ if ($a != 0 && $b !=0){count+=1}} END {print count}' $KMER_DUMP >> $OUTPUT_FILE
	echo 'Sum of '$ID' kmer counts/'$ID' sequencing depth where '$ID'_cov != 0 and '$element'_cov != 0' >> $OUTPUT_FILE
	awk -v a=$col -v b=${variables[$element]} -v c=$hap_cov '{ if ($a!=0 && $b != 0){count+=$a}} END {print count/c}' $KMER_DUMP >> $OUTPUT_FILE
	echo 'Number of kmers where '$ID'_cov != 0 and '$element'_cov == 0' >> $OUTPUT_FILE
	awk -v a=$col -v b=${variables[$element]} '{ if ($a!=0 && $b == 0){count+=1}} END {print count}' $KMER_DUMP >> $OUTPUT_FILE
	echo 'Sum of '$ID' kmer counts/'$ID' sequencing depth where '$ID'_cov != 0 and '$element'_cov == 0' >> $OUTPUT_FILE
	awk -v a=$col -v b=${variables[$element]} -v c=$hap_cov '{ if ($a!=0 && $b == 0){count+=$a}} END {print count/c}' $KMER_DUMP >> $OUTPUT_FILE
	echo 'Number of kmers where '$ID'_cov == 0 and '$element'_cov != 0' >> $OUTPUT_FILE
	awk -v a=$col -v b=${variables[$element]} '{ if ($a == 0 && $b !=0){count+=1}} END {print count}' $KMER_DUMP >> $OUTPUT_FILE
	echo "-" >> $OUTPUT_FILE
}

# variables is the associated array which will link the population ID to their position in the KMER_DUMP.
declare -A variables
#The following conditional statements establish which rows of the column correspond to the reference and which to the comparisons for each ID in REF.
for ID in "${REF[@]}"
do
	if [ $ID = "E022" ]
	then
		hap_cov=16.9
		col='2'
		variables=( ["E023"]='3' ["E033"]='4' ["E034"]='5' ["E035"]='6' )
	else
		if [ $ID = "E023" ]
		then
			hap_cov=15.8
			col='3'
			declare -gA variables
			variables=( ["E022"]='2' ["E033"]='4' ["E034"]='5' ["E035"]='6' )
		else
			if [ $ID = "E033" ]
			then
				hap_cov=54.5
				col='4'
				declare -gA variables
				variables=( ["E022"]='2' ["E023"]='3' ["E034"]='5' ["E035"]='6' )
			else
				if [ $ID = "E034" ]
				then
					hap_cov=16.6
					col='5'
					declare -gA variables
					variables=( ["E022"]='2' ["E023"]='3' ["E033"]='4' ["E035"]='6' )
				else
					if [ $ID = "E035" ]
					then
						hap_cov=19
						col='6'
						declare -gA variables
						variables=( ["E022"]='2' ["E023"]='3' ["E033"]='4' ["E034"]='5' )
					fi
				fi
			fi
		fi
	fi
	for element in "${!variables[@]}";
	do
		echo "Comparing "$ID" with "$element;
		kmer_stats
	done
done
