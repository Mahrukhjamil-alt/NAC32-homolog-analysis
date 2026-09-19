# Extract 100% conserved positions
awk '$5 == 100.0 && $4 == 15' highly_conserved_positions.txt > conserved_100_percent.txt

# Extract positions with 90–99% conservation
awk '$5 >= 90 && $5 < 100' highly_conserved_positions.txt > conserved_90_99_percent.txt

# Search for the conserved WKATG motif
grep -B1 -A1 "WKATG" NAC_homologs.fasta
