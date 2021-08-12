# This is a script to create plots based on R between two kmer dump files to observe the differences in kmer coverage.
#Designed to compare two populations whose kmer dump file has already been joined
KMER_DUMP="E022_E023_E033_E034_E035_joined"       # Input kmer dump file containing the kmer coverages for a set of populations.
REF_POP="E023"                                      # The reference population
COMP_POP="E033"                                     # The comparison population. The script will subtract kmer coverage like so (REF_cov - COMP_cov)
REF_COL=3                                          # The column on the joined kmer dump file which corresponds to the reference populations
COMP_COL=4                                         # The column on the joined kmer dump which corresponds to the comparison population
REF_HAP_COV=15.8                                   # Haploid coverage of the reference populations
COMP_HAP_COV=54.5                                  # Haploid coverage of the comparison population
OUTPUT_FOLDER=$REF_POP"-"$COMP_POP"_kmer_cov_diff_and_cumulative_diff"

mkdir $OUTPUT_FOLDER

awk -v r=$REF_COL -v c=$COMP_COL -v ref_hap=$REF_HAP_COV -v comp_hap=$COMP_HAP_COV '{
{print $r/ref_hap, (($r/ref_hap)-($c/comp_hap))}}' $KMER_DUMP > $OUTPUT_FOLDER/output1

sort -n $OUTPUT_FOLDER/output1 > $OUTPUT_FOLDER/sorted_output

rm $OUTPUT_FOLDER/output1

uniq -c $OUTPUT_FOLDER/sorted_output > $OUTPUT_FOLDER/count_output

rm $OUTPUT_FOLDER/sorted_output

awk '{print $2, $1*$3}' $OUTPUT_FOLDER/count_output | awk '{total += $2; print $1, $2, total}' > $OUTPUT_FOLDER/coverage_and_cumulative_kmer_difference


cd $OUTPUT_FOLDER
Rscript /localdisk/home/s1864468/euphrasia/kmers_joined/R_script_plot_kmer_coverage_differences.R $REF_POP $COMP_POP
cd ..
