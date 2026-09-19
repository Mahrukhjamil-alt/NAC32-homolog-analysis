# Extract first 150 amino acids from each protein
awk '
/^>/ {
    if (seq != "") print substr(seq,1,150)
    print
    seq=""
    next
}
{seq=seq $0}
END {
    if (seq != "") print substr(seq,1,150)
}' NAC_homologs.fasta > NAC_Nterminal150.fasta

# Align the N-terminal/NAM-containing regions
mafft --auto NAC_Nterminal150.fasta > NAC_NAM_alignment.fasta
