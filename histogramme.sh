if [ $# = 2 ]; then
  if [ $1 = 'dgemm' ]; then
    dossier=$1
    n=$2
    methods=("ijk" "ikj" "iex" "unroll4" "cblas" "unroll8")
    method_order="\"cblas iex ijk ikj unroll4 unroll8\""

  elif [ $1 = 'dotprod' ]; then
    dossier=$1
    n=$2
    methods=("base" "unroll4"  "unroll8" "cblas" )
    method_order="\"base cblas unroll4 unroll8\""


  elif [ $1 = 'reduc' ]; then
    dossier=$1  
    n=$2
    methods=("base"  "unroll4"  "unroll8" "cblas" )
    method_order="\"base cblas unroll4 unroll8\""


  else
    echo "Les arguments valides sont : dgemm dotprod reduc + n value "
    exit 0
  fi

else
  echo "Pas assez d'arguments valides sont : dgemm dotprod reduc + n value "
  exit 0
fi

  
echo "N = $n"
rm -r $dossier/extracted_data_hist
rm $dossier/histogramme/histogram_data.txt $dossier/histogramme/histogramme.gp

# Créez un dossier pour stocker les données extraites
mkdir $dossier/extracted_data_hist

# Parcourez les sous-dossiers de versions
for version_folder in $dossier/versions/*; do
  version=$(basename $version_folder) # Obtenez le nom de la version (par exemple, clang_noflag)

  # Créez un fichier de données pour la version actuelle
  touch "$dossier/extracted_data_hist/$version.txt"

  # Parcourez les sous-dossiers ijk, ikj, iex, unroll4, unroll8
  for method_folder in "$version_folder/"*; do
    method=$(basename $method_folder) # Obtenez le nom de la méthode (par exemple, ijk)

    # Recherchez les fichiers correspondant à n=$2 dans le sous-dossier actuel
    file="$dossier/versions/${version}/${method}/${method}_${n}.txt"
    # Si le fichier existe, extrayez la dernière valeur et ajoutez-la au fichier de données de la version
    if [ -f "$file" ]; then
      awk -F ';' 'END{print $NF}' "$file" >> "$dossier/extracted_data_hist/$version.txt"
    fi
  done
done

#!/bin/bash


mkdir $dossier/histogramme

# Répertoire contenant les fichiers extraits
extracted_data_hist_dir="$dossier/extracted_data_hist"

# Fichier de sortie pour l'histogramme
output_file="$dossier/histogramme/histogram_data.txt"

# Créer un fichier de sortie vide
> "$output_file"

# Parcourir les fichiers extraits
for filename in "$extracted_data_hist_dir"/*; do
    # Extraire le nom de la version du compilateur à partir du nom de fichier
    version=$(basename "$filename" )
    # Lire les données du fichier
    data=($(cat "$filename"))


    # Vérifier si le nombre de données correspond au nombre de méthodes
    if [ ${#data[@]} -eq ${#methods[@]} ]; then
        # Construire la ligne de données avec le nom de la version
        line="$version ${data[@]}"
        
        echo "$line" >> "$output_file"
    else
        echo "Le fichier $filename ne contient pas le bon nombre de données."
    fi
done

echo "Réformatage des données terminé. Les données sont dans $output_file."

# Echo each line to "plot.gp"
{
  echo "set key top left"
  echo ""
  echo "set term png size 1920,1080"
  echo "set output '$dossier/histogramme/histogram_$n.png'"
  echo ""
  echo "set title 'Histogramme de Débit en fonction des différentes OFLAGS, versions du compilateurs et algorithmes avec une matrice de taille $n '"
  echo "set xlabel 'Méthodes'"
  echo "set ylabel 'Débit (Mib/s)'"
  echo ""
  echo "set lmargin at screen 0.15"
  echo "set rmargin at screen 0.9"
  echo "set bmargin at screen 0.3"
  echo "set tmargin at screen 0.85"
  echo ""
  echo "set xtics rotate by -45"
  echo "set xtics (\"clang_noflag\" 1, \"clang_O1\" 3, \"clang_O2\" 5, \"clang_O3\" 7, \"clang_Ofast\" 9,  \"gcc_noflag\" 11, \"gcc_O1\" 13, \"gcc_O2\" 15, \"gcc_O3\" 17 , \"gcc_Ofast\" 19 )"
  echo ""
  echo "set style data histograms"
  echo "set style histogram clustered gap 1"
  echo "set boxwidth 0.5"
  echo "set style fill solid 0.5"
  echo ""
  echo "method_order = $method_order"
  echo ""
  echo "plot '$dossier/histogramme/histogram_data.txt' using 2:xticlabels(1) title word(method_order, 1), '' using 3 title word(method_order, 2), '' using 4 title word(method_order, 3), '' using 5 title word(method_order, 4), '' using 6 title word(method_order, 5), '' using 7 title word(method_order, 6)"
} > $dossier/histogramme/histogramme.gp


# Execute the script using gnuplot
gnuplot $dossier/histogramme/histogramme.gp

echo "L'histogramme a été créé"
  
