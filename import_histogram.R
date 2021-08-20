#import table into R
library(ggplot2)
table=read.table("E047_mito_plastid_removed") 
#create data frame from table
df = data.frame(table)
#create new column of table (c) - multiplicity*coverage
df$c=df$V1*df$V2
#Plot the kmer spectra
ggplot(data = df, aes(x = V1, y = V2))+geom_line() +ylim(0,2.5E07)+xlim(0,100)+xlab("Coverage") + ylab("Frequency")#display first 100 lines of data
head(df, 100)
