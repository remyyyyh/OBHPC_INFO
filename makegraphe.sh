if [ $# = 1 ]; then
  if [ $1 = 'dgemm' ]; then
    dossier=$1
    methods=("ijk" "ikj" "iex" "unroll4" "cblas" "unroll8")
    method_order="\"cblas iex ijk ikj unroll4 unroll8\""

  elif [ $1 = 'dotprod' ]; then
    dossier=$1
    methods=("base" "unroll4"  "unroll8" "cblas" )
    method_order="\"base cblas unroll4 unroll8\""


  elif [ $1 = 'reduc' ]; then
    dossier=$1
    methods=("base" "unroll4"  "unroll8" "cblas" )
    method_order="\"base cblas unroll4 unroll8\""

  else
    echo "Les arguments valides sont : dgemm dotprod reduc"
    exit 0
  fi

else
  echo "Pas assez d'argument ( les arguments valides sont : dgemm dotprod reduc )"
  exit 0
fi

rm -r $dossier/graphe
mkdir $dossier/graphe

directories=(
    "$dossier/graphe/clang_noflag"
    "$dossier/graphe/clang_O1"
    "$dossier/graphe/clang_O2"
    "$dossier/graphe/clang_O3"
    "$dossier/graphe/clang_Ofast"
    "$dossier/graphe/gcc_noflag"
    "$dossier/graphe/gcc_O1"
    "$dossier/graphe/gcc_O2"
    "$dossier/graphe/gcc_O3"
    "$dossier/graphe/gcc_Ofast"
)   

versions=(
    "clang_noflag"
    "clang_O1"
    "clang_O2"
    "clang_O3"
    "clang_Ofast"
    "gcc_noflag"
    "gcc_O1"
    "gcc_O2"
    "gcc_O3"
    "gcc_Ofast"
)   

for version in "${versions[@]}";do

    mkdir $dossier/graphe/$version

    for method in "${methods[@]}";do


            data_file="$dossier/versions/$version/$method/$method.txt"
            # echo $data_file
            
            if [ $1 = 'dgemm' ]; then

                awk -F ';' 'BEGIN {
                    }
                    NR>1 {
                    n = $5
                    MiB_per_s = $11
                    sub(/^[ \t]+/, "", n)
                    sub(/^[ \t]+/, "", MiB_per_s)
                    printf "%s %s\n", n, MiB_per_s
                    }
                ' "$data_file" > $dossier/graphe/$version/$method.txt   

            elif [ $1 = 'dotprod' ] || [ $1 = 'reduc' ] ; then

                awk -F ';' 'BEGIN {
                    }
                    NR>1 {
                    n = $5
                    MiB_per_s = $12
                    sub(/^[ \t]+/, "", n)
                    sub(/^[ \t]+/, "", MiB_per_s)
                    printf "%s %s\n", n, MiB_per_s
                    }
                ' "$data_file" > $dossier/graphe/$version/$method.txt   
            fi

            # echo $dir/$method".txt"
            # echo $data_file

                
    done
done


#!/bin/bash


if [ $1 = 'dgemm' ]; then

    # Paramètres du graphique
    title="Débit en fonction de n"
    xlabel="n"
    ylabel="Vitese en MiB/s"
    grid="set grid"

    # Noms des méthodes

    # Parcourir les répertoires et générer le graphe pour chaque répertoire
    for dir in "${directories[@]}"; do
        output_file="${dir}.png"
        d=$(basename "$dir" | sed 's/_dir$//; s/_/ /g')
        # Commandes Gnuplot pour créer le graphe
        gnuplot_commands="\
            set title '$title avec :  $d'; \
            set xlabel '$xlabel'; \
            set ylabel '$ylabel'; \
            $grid; \
            set terminal png; \
            set output '$output_file'; \
            plot '$dir/cblas.txt' using 1:2 with linespoints title 'cblas', \
            '$dir/iex.txt' using 1:2 with linespoints title 'iex', \
            '$dir/ijk.txt' using 1:2 with linespoints title 'ijk', \
            '$dir/ikj.txt' using 1:2 with linespoints title 'ikj', \
            '$dir/unroll4.txt' using 1:2 with linespoints title 'unroll4', \
            '$dir/unroll8.txt' using 1:2 with linespoints title 'unroll8'

            set output; \
        "

        # Exécuter les commandes Gnuplot
        echo "$gnuplot_commands" | gnuplot
    done

elif [ $1 = 'dotprod' ] || [ $1 = 'reduc' ] ; then

    # Paramètres du graphique
    title="Débit en fonction de n"
    xlabel="n"
    ylabel="Vitese en MiB/s"
    grid="set grid"

    # Noms des méthodes

    # Parcourir les répertoires et générer le graphe pour chaque répertoire
    for dir in "${directories[@]}"; do
        output_file="${dir}.png"
        d=$(basename "$dir" | sed 's/_dir$//; s/_/ /g')
        # Commandes Gnuplot pour créer le graphe
        gnuplot_commands="\
            set title '$title avec :  $d'; \
            set xlabel '$xlabel'; \
            set ylabel '$ylabel'; \
            set logscale x 2
            $grid; \
            set terminal png; \
            set output '$output_file'; \
            plot '$dir/base.txt' using 1:2 with linespoints title 'base', \
            '$dir/cblas.txt' using 1:2 with linespoints title 'cblas', \
            '$dir/unroll4.txt' using 1:2 with linespoints title 'unroll4', \
            '$dir/unroll8.txt' using 1:2 with linespoints title 'unroll8', \

            set output; \
        "

        # Exécuter les commandes Gnuplot
        echo "$gnuplot_commands" | gnuplot
    done
fi
