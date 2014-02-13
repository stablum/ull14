set term postscript
set output "out/plotfreqs.ps"
set logscale xy
plot 'out/wordfreqdistro.out' u ($0):($1)

