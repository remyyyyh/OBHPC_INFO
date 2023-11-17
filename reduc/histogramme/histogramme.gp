set key top left

set term png size 1920,1080
set output 'reduc/histogramme/histogram_65536.png'

set title 'Histogramme de Débit en fonction des différentes OFLAGS, versions du compilateurs et algorithmes avec une matrice de taille 65536 '
set xlabel 'Méthodes'
set ylabel 'Débit (Mib/s)'

set lmargin at screen 0.15
set rmargin at screen 0.9
set bmargin at screen 0.3
set tmargin at screen 0.85

set xtics rotate by -45
set xtics ("clang_noflag" 1, "clang_O1" 3, "clang_O2" 5, "clang_O3" 7, "clang_Ofast" 9,  "gcc_noflag" 11, "gcc_O1" 13, "gcc_O2" 15, "gcc_O3" 17 , "gcc_Ofast" 19 )

set style data histograms
set style histogram clustered gap 1
set boxwidth 0.5
set style fill solid 0.5

method_order = "base cblas unroll4 unroll8"

plot 'reduc/histogramme/histogram_data.txt' using 2:xticlabels(1) title word(method_order, 1), '' using 3 title word(method_order, 2), '' using 4 title word(method_order, 3), '' using 5 title word(method_order, 4), '' using 6 title word(method_order, 5), '' using 7 title word(method_order, 6)
