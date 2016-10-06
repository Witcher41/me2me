#!/bin/bash

# sbatch -N 1 -n 1 -p ibmulticore2 --exclusive ./srun.sh

for (( i=100; i<=100; i=i+10 ))
do
echo -e "#TTPs\t#TMPs\t#MEAN\t#STD\t#WIPs\t#MPs\t#TPs\t#Size" >> data/results.dat

    for (( j=100; j<=100; j=j+10 ))
    do
	#for (( k=0; k<3; k++ ))
	#do
	    DATE=$(date "+%d%m%y%H%M")
	    srun -p ibmulticore2 --exclusive -o simulator.txt ./simulator.py -n 15 -i 0 -t $i -m $j -z 100 -p ${DATE}n25t${i}m${j}z100
	    #srun -p ibbullion --exclusive -o simulator.txt ./simulator.py -n 15 -i 0 -t $i -m $j -z 100 -p ${DATE}n25t${i}m${j}z100


	    MEAN=$(tail -n+2 ${DATE}n25t${i}m${j}z100/sample.dat | awk '{ sum += $8; n++ } END { print sum / n;}')
	    STD=$(tail -n+2 100 ${DATE}n25t${i}m${j}z100/sample.dat | awk '{ sum += $8; sumsqrt += $8^2; n++ } END { print sqrt(sumsqrt/n-(sum/n)^2) }')

	    tail -n 1 ${DATE}n25t${i}m${j}z100/sample.dat | awk '{print $2,"\t",$3,"\t",$4,"\t",$5;}' >> team.dat

	    tail -n+2 ${DATE}n25t${i}m${j}z100/sample.dat | awk '{print $1,"\t", $2/$5, "\t", $3/$5, "\t", $4/$5;}' | awk '{ if (n==0){ini=$1};fin=$1;wip+=$2;mp+=$3;tp+=$4;n++;}END{print wip/n, "\t", mp/n,"\t",tp/n,"\t",ini,"\t",fin;}' >> stats-round.dat

	    cat ${DATE}n25t${i}m${j}z100/simulator.txt | awk '/STABLE_ROUND =/{print $3}' >> stable-round.dat

	    echo -e "${i}\t${j}\t${MEAN}\t${STD}" >> data/${i}${j}.dat

	    tar -zcvf ${DATE}n25t${i}m${j}z100.tgz ${DATE}n25t${i}m${j}z100
	    scp ${DATE}n25t${i}m${j}z100.tgz bullxual.hpca.ual.es:~/experiments-copy
	    #rm -r ${DATE}n25t${i}m${j}z100
	    rm ${DATE}n25t${i}m${j}z100.tgz
	#done

	MEAN=$(cat data/${i}${j}.dat | awk '{ sum += $3; n++ } END { print sum / n;}')
	STD=$(cat data/${i}${j}.dat | awk '{ sum += $4; n++ } END { print sum / n;}')
	STATS=$(cat stats-round.dat | awk '{ c1 += $1; c2 += $2; c3 += $3; c4 += $4; c5 +=$5; n++; } END { print c1 / n,"\t",c2 / n,"\t", c3 / n,"\t",c4/n ,"\t", c5/n; }')
	ROUNDSTB=$(cat stable-round.dat | awk '{ sum += $1; n++ } END { print sum / n;}')
	TEAM=$(cat team.dat | awk '{ c1 += $1; c2 += $2; c3 += $3; c4 += $4; n++; } END { print c1 / n,"\t",c2 / n,"\t", c3 / n,"\t",c4 /n; }')
	rm team.dat
	rm stable-round.dat
	rm stats-round.dat

	echo -e "${i}\t${j}\t${MEAN}\t${STD}\t${TEAM}" >> data/results.dat
	echo -e "${i}\t${j}\t${STATS}\t${ROUNDSTB}\t${MEAN}\t${STD}" >> data/stats.dat


    done
    echo "" >> data/results.dat
done

