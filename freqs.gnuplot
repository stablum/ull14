set output "plotfreqs.png"
set logscale xy
plot 'wordfreqdistro.out' u ($0):($1)

