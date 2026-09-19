# Check IQ-TREE version
iqtree3 --version

# Maximum-likelihood phylogenetic analysis
iqtree3 -s NAC_trimmed.fasta -m MFP -B 1000 --alrt 1000 -T AUTO
