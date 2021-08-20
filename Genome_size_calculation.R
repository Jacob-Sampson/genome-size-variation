#input the haploid coverage, previously calculated by Tetmer
haploid_coverage=15.4

#input the rows which will be discarded from the dataset, high frequency, low multiplicity kmers from first few rows of data.
cont=6
df_cont=df[-(1:cont),]

#Calculate number of kmers (multiplicity*coverage)
number_kmers=sum(df_cont$c)

#Estimate genome size by dividing (multiplicity*coverage)/sequencing depth
genome_size=number_kmers/haploid_coverage

#Convert genome size into megabases
genome_size_mb=genome_size/1E06
genome_size_mb