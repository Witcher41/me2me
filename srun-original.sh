#!/bin/bash

# sbatch -N 1 -n 1 -p ibbullion --exclusive ./srun.sh

for (( i=0; i<=100; i=i+10 ))
do
echo -e "#TTPs\t#TMPs\t#MEAN\t#STD\t#WIPs\t#MPs\t#TPs\t#Size" >> data/results.dat

    for (( j=0; j<=100; j=j+10 ))
    do
	for (( k=0; k<3; k++ ))
	do
	    DATE=$(date "+%d%m%y%H%M")
	    srun -p ibbullion -o simulator.txt ./simulator.py -n 25 -i 0 -t $i -m $j -z 100 -d 570 -c 570
	    
	    MEAN=$(cat ${DATE}n25t${i}m${j}z100d570/sample.dat | awk '{ sum += $8; n++ } END { print sum / n;}')
	    STD=$(cat ${DATE}n25t${i}m${j}z100d570/sample.dat | awk '{ sum += $8; sumsqrt += $8^2; n++ } END { print sqrt(sumsqrt/n-(sum/n)^2) }')

	    tail -n 1 ${DATE}n25t${i}m${j}z100d570/sample.dat | awk '{print $2,"\t",$3,"\t",$4,"\t",$5;}' >> team.dat

	    echo -e "${i}\t${j}\t${MEAN}\t${STD}" >> data/${i}${j}.dat
	    
	    tar -zcvf ${DATE}n25t${i}m${j}z100d570.tgz ${DATE}n25t${i}m${j}z100d570
	    scp ${DATE}n25t${i}m${j}z100d570.tgz bullxual.hpca.ual.es:~/experiments-copy
	    rm -r ${DATE}n25t${i}m${j}z100d570
	    rm ${DATE}n25t${i}m${j}z100d570.tgz
	done

	MEAN=$(cat  data/${i}${j}.dat | awk '{ sum += $3; n++ } END { print sum / n;}')
	STD=$(cat  data/${i}${j}.dat | awk '{ sum += $4; n++ } END { print sum / n;}')
	TEAM=$(cat team.dat | awk '{ c1 += $1; c2 += $2; c3 += $3; c4 += $4; n++; } END { print c1 / n,"\t",c2 / n,"\t", c3 / n,"\t",c4 /n; }')
	rm -r team.dat

	echo -e "${i}\t${j}\t${MEAN}\t${STD}\t${TEAM}" >> data/results.dat

    done
    echo "" >> data/results.dat
done

