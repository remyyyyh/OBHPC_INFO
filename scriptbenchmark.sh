
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
    methods=("base"  "unroll4"  "unroll8" "cblas" )
    method_order="\"base cblas unroll4 unroll8\""


  else
    echo "Les arguments valides sont : dgemm dotprod reduc"
    exit 0
  fi

else
  echo "Pas assez/trop d'arguments valides sont : dgemm dotprod reduc"
  exit 0
fi


cd $1
rm -r versions
mkdir versions


if [ $1 = 'dgemm' ]; then


for j in {0..9..1}
do  
    make clean
    if [ $j = 0 ]; then
        dossier=versions/gcc_noflag
        mkdir $dossier
        make CC=gcc 
        
    elif [ $j = 1 ]; then
        dossier=versions/gcc_O1
        mkdir $dossier
        make CC=gcc  OFLAGS=-O1

    elif [ $j = 2 ]; then
        dossier=versions/gcc_O2
        mkdir $dossier
        make CC=gcc  OFLAGS=-O2

    elif [ $j = 3 ]; then
        dossier=versions/gcc_O3
        mkdir $dossier
        make CC=gcc  OFLAGS=-O3

    elif [ $j = 4 ]; then
        dossier=versions/gcc_Ofast
        mkdir $dossier
        make CC=gcc  OFLAGS=-Ofast
                
    elif [ $j = 5 ]; then
        dossier=versions/clang_noflag
        mkdir $dossier
        make CC=clang
                
    elif [ $j = 6 ]; then
        dossier=versions/clang_O1
        mkdir $dossier
        make CC=clang OFLAGS=-O1

    elif [ $j = 7 ]; then
        dossier=versions/clang_O2
        mkdir $dossier
        make CC=clang OFLAGS=-O2

    elif [ $j = 8 ]; then
        dossier=versions/clang_O3
        mkdir $dossier
        make CC=clang OFLAGS=-O3

    elif [ $j = 9 ]; then
        dossier=versions/clang_Ofast
        mkdir $dossier
        make CC=clang OFLAGS=-Ofast
    fi

    mkdir $dossier/ijk
    mkdir $dossier/ikj
    mkdir $dossier/iex
    mkdir $dossier/unroll4
    mkdir $dossier/cblas
    mkdir $dossier/unroll8


    taskset -c 2 ./dgemm 1 1 | grep -i "title" > title

    cat title > $dossier/ijk/ijk.txt
    cat title > $dossier/ikj/ikj.txt
    cat title > $dossier/iex/iex.txt
    cat title > $dossier/unroll4/unroll4.txt
    cat title > $dossier/cblas/cblas.txt
    cat title > $dossier/unroll8/unroll8.txt
    


    for i in {5..70..5}
    do  
        taskset -c 2 ./dgemm $i 31 > res
            cat res | grep -i "ijk" >> $dossier/ijk/ijk.txt
            cat res | grep -i "ikj" >> $dossier/ikj/ikj.txt
            cat res | grep -i "iex" >> $dossier/iex/iex.txt
            cat res | grep -i "unroll4" >> $dossier/unroll4/unroll4.txt
            cat res | grep -i "cblas" >> $dossier/cblas/cblas.txt
            cat res | grep -i "unroll8" >> $dossier/unroll8/unroll8.txt
            
            cat res | grep -i "ijk" > $dossier/ijk/ijk_$i.txt
            cat res | grep -i "ikj" > $dossier/ikj/ikj_$i.txt
            cat res | grep -i "iex" > $dossier/iex/iex_$i.txt
            cat res | grep -i "unroll4" > $dossier/unroll4/unroll4_$i.txt
            cat res | grep -i "cblas" > $dossier/cblas/cblas_$i.txt
            cat res | grep -i "unroll8" > $dossier/unroll8/unroll8_$i.txt            

    done
    cp dgemm $dossier

done
rm dgemm res title
cd ..
else


for j in {0..9..1}
do  
    make clean
    if [ $j = 0 ]; then
        dossier=versions/gcc_noflag
        mkdir $dossier
        make CC=gcc 
        
    elif [ $j = 1 ]; then
        dossier=versions/gcc_O1
        mkdir $dossier
        make CC=gcc  OFLAGS=-O1

    elif [ $j = 2 ]; then
        dossier=versions/gcc_O2
        mkdir $dossier
        make CC=gcc  OFLAGS=-O2

    elif [ $j = 3 ]; then
        dossier=versions/gcc_O3
        mkdir $dossier
        make CC=gcc  OFLAGS=-O3

    elif [ $j = 4 ]; then
        dossier=versions/gcc_Ofast
        mkdir $dossier
        make CC=gcc  OFLAGS=-Ofast
                
    elif [ $j = 5 ]; then
        dossier=versions/clang_noflag
        mkdir $dossier
        make CC=clang
                
    elif [ $j = 6 ]; then
        dossier=versions/clang_O1
        mkdir $dossier
        make CC=clang OFLAGS=-O1 

    elif [ $j = 7 ]; then
        dossier=versions/clang_O2
        mkdir $dossier
        make CC=clang OFLAGS=-O2

    elif [ $j = 8 ]; then
        dossier=versions/clang_O3
        mkdir $dossier
        make CC=clang OFLAGS=-O3

    elif [ $j = 9 ]; then
        dossier=versions/clang_Ofast
        mkdir $dossier
        make CC=clang OFLAGS=-Ofast
    fi

    mkdir $dossier/base
    mkdir $dossier/unroll4
    mkdir $dossier/cblas
    mkdir $dossier/unroll8

    taskset -c 2 ./dotprod 1 1 | grep -i "title" > title

    cat title > $dossier/base/base.txt
    cat title > $dossier/unroll4/unroll4.txt
    cat title > $dossier/cblas/cblas.txt
    cat title > $dossier/unroll8/unroll8.txt
    

    k=1
    for i in {1..21}
    do  
        # echo $k
        taskset -c 2 ./$1 $k 31 > res
            cat res | grep -i "base" > $dossier/base/base_$k.txt
            cat res | grep -i "unroll4" > $dossier/unroll4/unroll4_$k.txt
            cat res | grep -i "cblas" > $dossier/cblas/cblas_$k.txt
            cat res | grep -i "unroll8" > $dossier/unroll8/unroll8_$k.txt

            cat res | grep -i "base" >> $dossier/base/base.txt
            cat res | grep -i "unroll4" >> $dossier/unroll4/unroll4.txt
            cat res | grep -i "cblas" >> $dossier/cblas/cblas.txt
            cat res | grep -i "unroll8" >> $dossier/unroll8/unroll8.txt
        k=$((k * 2))

    done
    cp dotprod $dossier

done
rm res title $1

cd ..
fi

