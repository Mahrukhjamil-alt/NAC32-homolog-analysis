# Calculate gap percentage for each aligned sequence
awk '
/^>/ {
    if (seq != "") {
        gap=0
        for(i=1;i<=length(seq);i++)
            if(substr(seq,i,1)=="-") gap++
        print name, length(seq), gap, (gap/length(seq))*100
    }
    name=$0
    seq=""
    next
}
{seq=seq $0}
END {
    if (seq != "") {
        gap=0
        for(i=1;i<=length(seq);i++)
            if(substr(seq,i,1)=="-") gap++
        print name, length(seq), gap, (gap/length(seq))*100
    }
}' NAC_aligned.fasta > gap_percent.txt
