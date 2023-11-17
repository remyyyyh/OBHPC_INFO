# OBHPC_INFO

algo: dgemm dotprod reduc


exécuter un benchmark :
    ./scriptbenchmark algo



faire un histogramme :
    ./histogramme algo n

si dgemm alors
n : 5 10 15 .. 70

si dotprod ou reduc
n : 2 4 8 .. 1048576 



faire des graphes :
    ./makegraphe algo