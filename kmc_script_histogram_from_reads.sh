VARIABLES=('micrantha_E022' 'micrantha_E023')
for species in "${VARIABLES[@]}"
do
	cd $species
	echo "Currently creating histograms for $species"
	mkdir temp #make directory required for kmc
	source ~/.bashrc
	kmc -k27 -cs15000000 @file_names kmer_1 temp #generate kmer dataset, high multiplicity, requires file_names of input genomes
	VAR="_raw_histogram"
	kmc_tools transform kmer_1 histogram kmer_histogram -cx15000000 #generate histogram table from kmer dataset
	awk '{ if( $2 != 0 ){ print $0 } }' kmer_histogram > $species$VAR #remove lines with zeros from histogram
	rm kmer_histogram
	kmc_tools simple kmer_1 /localdisk/home/s1864468/euphrasia/plastid/plastid_kmer kmers_subtract kmer_plastid_removed -cs15000000 #generate new kmer dataset with kmers corresponding to plastid genome removed
	rm kmer_1.kmc*
	kmc_tools transform kmer_plastid_removed histogram kmer2_histogram -cx15000000
	VAR2="_plastid_removed"
	awk '{if ($2 != 0){print $0}}' kmer2_histogram > $species$VAR2
	rm kmer2_histogram
	kmc_tools simple kmer_plastid_removed /localdisk/home/s1864468/euphrasia/mito_genome/mito_assembly kmers_subtract kmer_mito_plastid_removed -cs15000000
	rm kmer_plastid_removed.kmc*
	kmc_tools transform kmer_mito_plastid_removed histogram kmer_mito_plastid_removed_histogram -cx15000000 #generate new histogram with kmers corresponding to plastid genome removed
	rm kmer_mito_plastid_removed.kmc*
	VAR1="_mito_plastid_removed"
	awk '{ if( $2 != 0 ){ print $0 } }' kmer_mito_plastid_removed_histogram > "$species$VAR1" #generate new histogram with no plastid kmers and no zeros
	rm kmer_mito_plastid_removed_histogram
	echo "Histogram for $species completed"
	cd ..
done
