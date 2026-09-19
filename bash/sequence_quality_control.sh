# Count protein sequences in FASTA
grep -c "^>" NAC_homologs.fasta

# Check for invalid amino acid characters
grep -v "^>" NAC_homologs.fasta | grep -n '[^ACDEFGHIKLMNPQRSTVWYXBZUOJ*-]'

# Check for exact duplicate sequences
grep -v "^>" NAC_homologs.fasta | awk 'BEGIN{RS=">"; FS="\n"} NR>1 {seq=""; for(i=2;i<=NF;i++) seq=seq $i; print seq}' | sort | uniq -d
