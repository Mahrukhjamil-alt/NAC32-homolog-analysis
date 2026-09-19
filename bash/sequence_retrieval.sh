# NCBI EDirect path
export PATH=${HOME}/edirect:${PATH}

# Verify efetch installation
which efetch

# Retrieve protein sequences from NCBI
efetch -db protein -id "$(paste -sd, accessions.txt)" -format fasta > NAC_homologs.fasta
