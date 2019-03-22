#!/bin/sh
cd workspace
#mkdir temp_dir
for j in $(ls ../data/pdb);do
	pdb_name=`echo $j|cut -d '.' -f 1`
	echo $pdb_name >>pdb_list.txt
	/home/huanghe/huangh/bioinfo_hh/Complex_Tool/Complex_Tool -i ../data/pdb/$j -o ${pdb_name}.contact -m 1	
	mkdir ${pdb_name}_temp_dir
	mv *con ${pdb_name}_temp_dir
	for k in $(ls ${pdb_name}_temp_dir);do
		len=`expr length $k`
		if [ $len -eq 9 ];then
			name=`echo $k|cut -d '.' -f 1`
			chain=$(echo ${name:4})
			echo $chain >>${pdb_name}_temp_dir/${pdb_name}_chain.txt
		fi
	done
	if [ -s ./${pdb_name}_temp_dir/${pdb_name}_chain.txt ];then
		for r in $(cat ${pdb_name}_temp_dir/${pdb_name}_chain.txt);do 
	                /home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/${pdb_name}${r}.con 8 > ${pdb_name}_${r}_temp.contact_matrix
        	        for l in $(cat ${pdb_name}_temp_dir/${pdb_name}_chain.txt);do
                	        if [ "$r" != "$l" ];then
                        	        /home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/${pdb_name}_${r}_${l}.con 8 > ${pdb_name}_${r}_${l}_temp.contact_matrix
	                        fi
        	        done
		done
	else
		chain=$(echo ${name:4})
		echo $chain >>${pdb_name}_temp_dir/${pdb_name}_chain.txt
		/home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/*.con 8 > ${pdb_name}_${r}_temp.contact_matrix
	fi
:<<!
	for r in $(cat ${pdb_name}_temp_dir/${pdb_name}_chain.txt);do 
		/home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/${pdb_name}${r}.con 8 > ${pdb_name}_${r}_temp.contact_matrix
		for l in $(cat ${pdb_name}_temp_dir/${pdb_name}_chain.txt);do
			if [ "$r" != "$l" ];then
				/home/huanghe/huangh/bioinfo_hh/Complex_Tool/util/DistMat_To_ContMat ${pdb_name}_temp_dir/${pdb_name}_${r}_${l}.con 8 > ${pdb_name}_${r}_${l}_temp.contact_matrix
			fi
		done
	done
!
done
	
