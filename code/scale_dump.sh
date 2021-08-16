# Script to bin mulitplicitied in joined k-mer dumps
# Assumes three columns, applies the function normBin to columns 2 and 3.
# USAGE bash scale_dum.sh <joined dump> <noramalisation factor 1> <normalisation factor 2>

# Normalisation factors for spectra read fromthe command line. NB $1 and $2 have a different meaning in the awk string.
fact1=$2
fact2=$3

# Location of the dump file
dfile=$1
#echo $dfile

# A binning function
awk -v f1=$fact1 -v f2=$fact2 '
function normBin(num, factor){
    if(num/factor < 0.5)
    retrun 0 
    return int(log(num/factor/0.5)/log(1.1))
}
{
    print normBin($2, f1) " " normBin($3, f2)
}
' $dfile
