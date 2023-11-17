rm -r versions
mkdir versions

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
        taskset -c 2 ./dotprod $k 31 > res
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

rm res title dotprod