# NAC32 Homolog Analysis

## Sequence, Phylogenetic, Conservation, Domain, and Structural Analysis of Arabidopsis NAC Transcription Factor 32

---

## 1. Project Overview

This project investigates the sequence conservation, evolutionary relationships, conserved NAM domain, conserved residues, conserved motif, and structural features of **NAC transcription factor 32 (NAC032)** from *Arabidopsis thaliana*.

The complete computational workflow was:

**Reference selection → BLASTp homolog identification → sequence retrieval → sequence quality control → multiple sequence alignment → gap analysis → alignment trimming → phylogenetic analysis → domain identification → NAM-region alignment → conservation analysis → motif analysis → AlphaFold structure → PyMOL visualization**

A total of **15 NAC-related protein sequences** were analyzed.

---

# 2. Reference Protein

### Database

**UniProt**

### Reference protein

| Feature      | Information                 |
| ------------ | --------------------------- |
| Protein      | NAC transcription factor 32 |
| Gene         | NAC032                      |
| Organism     | *Arabidopsis thaliana*      |
| UniProt      | Q9CAR0                      |
| NCBI Protein | NP_177869.1                 |
| Length       | 253 aa                      |
| Status       | Reviewed / Swiss-Prot       |

The *Arabidopsis thaliana* NAC032 protein was selected as the reference sequence for identification and comparative analysis of NAC-related proteins.

---

# 3. Homolog Identification

### Tool

**NCBI BLASTp**

### Purpose

BLASTp was used to identify protein sequences related to NAC032.

Candidate proteins were selected by considering:

* sequence similarity
* alignment coverage
* E-value
* protein annotation
* taxonomic diversity

The final dataset contained **15 protein sequences**, including the reference protein.

### Selected proteins

| Accession      | Species                | Annotation                           |
| -------------- | ---------------------- | ------------------------------------ |
| NP_177869.1    | *Arabidopsis thaliana* | NAC domain containing protein 32     |
| XP_010416688.2 | *Camelina sativa*      | NAC transcription factor 32          |
| KAL1214576.1   | *Cardamine amara*      | NAC transcription factor 32          |
| NP_001302748.1 | *Brassica napus*       | NAC domain-containing protein 2-like |
| XP_010521273.1 | *Tarenaya hassleriana* | NAC domain-containing protein 2      |
| NP_001236871.2 | *Glycine max*          | NAC domain protein NAC2              |
| NP_001352199.1 | *Cicer arietinum*      | NAC family transcription factor 5    |
| XP_034888993.1 | *Populus alba*         | NAC domain-containing protein 2      |
| XP_022993910.1 | *Cucurbita maxima*     | NAC domain-containing protein 2-like |
| XP_021601298.2 | *Manihot esculenta*    | NAC domain-containing protein 2      |
| XP_006472812.2 | *Citrus sinensis*      | NAC domain-containing protein 2      |
| KAL2519989.1   | *Forsythia ovata*      | NAC domain-containing protein 2      |
| XP_039000468.1 | *Hibiscus syriacus*    | NAC domain-containing protein 2-like |
| ANJ86372.1     | *Carica papaya*        | NAC5                                 |
| XP_015575373.1 | *Ricinus communis*     | NAC domain-containing protein 2      |

The accession list is stored in:

```text
data/accessions.txt
```

The complete protein dataset is stored in:

```text
data/NAC_homologs.fasta
```

> These proteins are referred to as **NAC32-related homolog candidates**. Sequence similarity and phylogenetic clustering alone were not used to establish definitive orthology.

---

# 4. Sequence Retrieval

### Tool

**NCBI EDirect / efetch**

The selected NCBI protein accessions were used to retrieve their amino acid sequences in FASTA format.

### Commands

```bash
export PATH=${HOME}/edirect:${PATH}
```

Used to make NCBI EDirect available in the terminal.

```bash
which efetch
```

Used to verify the `efetch` installation.

```bash
efetch -db protein -id "$(paste -sd, accessions.txt)" -format fasta > NAC_homologs.fasta
```

Used to retrieve all selected protein sequences from NCBI and save them as a FASTA file.

### Output

```text
data/NAC_homologs.fasta
```

The resulting dataset contained:

```text
15 protein sequences
```

---

# 5. Sequence Quality Control

Sequence quality was checked before multiple sequence alignment.

### Tool

**Linux Bash commands**

### 5.1 Count sequences

```bash
grep -c "^>" NAC_homologs.fasta
```

Used to confirm that the FASTA file contained the expected number of sequences.

### Result

```text
15
```

---

### 5.2 Check invalid amino acid characters

```bash
grep -v "^>" NAC_homologs.fasta | grep -n '[^ACDEFGHIKLMNPQRSTVWYXBZUOJ*-]'
```

Used to detect characters outside the accepted amino acid alphabet.

### Result

No output was produced, indicating that no invalid amino acid characters were detected.

---

### 5.3 Check exact duplicate sequences

```bash
grep -v "^>" NAC_homologs.fasta | awk 'BEGIN{RS=">"; FS="\n"} NR>1 {seq=""; for(i=2;i<=NF;i++) seq=seq $i; print seq}' | sort | uniq -d
```

Used to identify exact duplicate protein sequences.

### Result

No duplicate sequences were detected.

---

# 6. Multiple Sequence Alignment

### Tool

**MAFFT v7.525**

MAFFT was used to align the complete protein sequences.

### Version check

```bash
mafft --version
```

### Alignment command

```bash
mafft --auto NAC_homologs.fasta > NAC_aligned.fasta
```

The `--auto` option allowed MAFFT to select an appropriate alignment strategy automatically.

### Result

The alignment contained:

```text
15 sequences
345 alignment positions
```

### Output

```text
alignment/NAC_aligned.fasta
```

---

# 7. Alignment Gap Analysis

### Tool

**Linux Bash / AWK**

The aligned sequences were examined for gap content.

### Command

```bash
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
```

This was used to calculate the percentage of gaps in each aligned sequence.

### Output

```text
alignment/gap_percent.txt
```

---

# 8. Alignment Trimming

### Tool

**trimAl v1.5.rev1**

The original alignment contained variable and gap-rich positions. trimAl was used to automatically identify and remove poorly aligned regions before phylogenetic analysis.

### Command

```bash
trimal -in NAC_aligned.fasta -out NAC_trimmed.fasta -automated1
```

### Result

| Feature            | Positions |
| ------------------ | --------: |
| Original alignment |       345 |
| Trimmed alignment  |       281 |
| Positions removed  |        64 |
| Positions retained |    ~81.4% |

### Output

```text
alignment/NAC_trimmed.fasta
```

---

# 9. Phylogenetic Analysis

### Tool

**IQ-TREE v3.1.3**

IQ-TREE was used to construct a maximum-likelihood phylogenetic tree from the trimmed alignment.

### Version check

```bash
iqtree3 --version
```

### Phylogenetic command

```bash
iqtree3 -s NAC_trimmed.fasta -m MFP -B 1000 --alrt 1000 -T AUTO
```

### Parameters

| Parameter              | Purpose                             |
| ---------------------- | ----------------------------------- |
| `-s NAC_trimmed.fasta` | Input alignment                     |
| `-m MFP`               | Automatic best-fit model selection  |
| `-B 1000`              | 1000 ultrafast bootstrap replicates |
| `--alrt 1000`          | 1000 SH-aLRT replicates             |
| `-T AUTO`              | Automatic CPU thread selection      |

### Best-fit model

```text
JTT+G4
```

according to BIC.

### Main tree

```text
phylogeny/NAC_trimmed.fasta.treefile
```

### Additional outputs

```text
phylogeny/NAC_trimmed.fasta.contree
phylogeny/NAC_trimmed.fasta.iqtree
phylogeny/NAC_NAC32_ML.tree
```

The tree was interpreted as evidence of evolutionary relationships among the selected sequences. It was not used alone to establish definitive orthology.

---

# 10. Phylogenetic Visualization

### Tool

**Interactive Tree of Life (iTOL)**

The IQ-TREE maximum-likelihood tree was uploaded to iTOL for visualization.

The final annotated tree image is stored in:

```text
results/NAC32_phylogenetic_tree.png
```

The visualization allows the clustering and branch-support values of the NAC-related proteins to be examined more clearly.

---

# 11. NAM Domain Identification

### Tool

**NCBI Conserved Domain Search — Batch CD-Search**

The original 15 protein sequences were submitted to NCBI Batch CD-Search to identify conserved protein domains.

### Result

All:

```text
15 / 15 proteins
```

contained a specific **NAM domain**.

| Feature                   | Result          |
| ------------------------- | --------------- |
| Domain                    | NAM             |
| Pfam                      | PF02365         |
| Superfamily               | cl03558         |
| Proteins with domain      | 15/15           |
| Approximate NAC032 region | residues 11–134 |

The domain E-values were approximately in the range:

```text
10^-73 to 10^-75
```

This confirmed the presence of the conserved NAM region across the selected proteins.

---

# 12. N-terminal / NAM-Containing Region

The NAM domain was located near the N-terminus of the proteins.

Therefore, the first 150 amino acids were extracted for focused conservation analysis.

### Command

```bash
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
```

### Output

```text
alignment/NAC_Nterminal150.fasta
```

The extracted sequences were then aligned using MAFFT.

```bash
mafft --auto NAC_Nterminal150.fasta > NAC_NAM_alignment.fasta
```

### Result

The focused alignment contained:

```text
15 sequences
154 alignment positions
```

### Output

```text
alignment/NAC_NAM_alignment.fasta
```

> The first 150 residues were used as a practical NAM-containing region. Exact CD-Search domain coordinates varied slightly between proteins.

---

# 13. Conserved Residue Analysis

The NAM-containing alignment was analyzed position-by-position to identify highly conserved residues.

The conservation analysis produced:

```text
conservation/highly_conserved_positions.txt
```

### 100% conserved residues

```bash
awk '$5 == 100.0 && $4 == 15' highly_conserved_positions.txt > conserved_100_percent.txt
```

This extracted positions where all 15 sequences contained the same residue.

### Result

```text
96 residues
```

were 100% conserved.

---

### 90–99% conserved residues

```bash
awk '$5 >= 90 && $5 < 100' highly_conserved_positions.txt > conserved_90_99_percent.txt
```

This extracted positions with 90–99% conservation.

Together with the completely conserved positions, a total of:

```text
115 residues
```

showed at least 90% conservation.

### Outputs

```text
conservation/highly_conserved_positions.txt
conservation/conserved_100_percent.txt
conservation/conserved_90_99_percent.txt
```

---

# 14. NAC032 Reference Residue Mapping

Alignment positions were mapped back to the original *Arabidopsis thaliana* NAC032 residue numbering.

This was necessary because insertions and gaps in the alignment can cause alignment positions to differ from the original protein residue numbers.

### Output

```text
conservation/NAC32_conserved_residue_mapping.txt
```

This file allows conserved alignment positions to be interpreted using the actual NAC032 residue numbering.

---

# 15. Conserved Motif Analysis

A conserved sequence motif:

```text
WKATG
```

was specifically examined.

### Command

```bash
grep -B1 -A1 "WKATG" NAC_homologs.fasta
```

Used to locate the motif within the selected protein sequences.

### Result

The motif was present in:

```text
15 / 15 sequences
```

Therefore:

```text
100% motif presence
```

In the *Arabidopsis thaliana* NAC032 reference sequence, the motif corresponds to:

```text
W91-K92-A93-T94-G95
```

All five residues were conserved across the analyzed sequences.

> Conservation of this motif identifies it as a highly conserved sequence feature, but conservation alone does not establish its specific biological function.

---

# 16. Structural Analysis

## Structure source

**AlphaFold Protein Structure Database**

### Reference

```text
UniProt: Q9CAR0
Protein: NAC transcription factor 32
Organism: Arabidopsis thaliana
Length: 253 aa
```

No experimental PDB structure was available for NAC032, so an AlphaFold predicted structure was used.

### Selected model

```text
AF-Q9CAR0-F1
```

The model contains:

```text
253 residues
```

with an average reported pLDDT of:

```text
70.62
```

The structure was treated as a **predicted model**, rather than an experimentally determined structure.

### Structure file

```text
structure/AF-Q9CAR0-F1-model_v6.pdb
```

---

# 17. Structural Visualization

### Tool

**PyMOL**

The AlphaFold NAC032 model was opened in PyMOL for 3D visualization.

The NAM-containing region and conserved `WKATG` motif were specifically examined.

The motif corresponds to:

```text
W91-K92-A93-T94-G95
```

The final structural figure is stored in:

```text
results/wkatg.png
```

---

# 18. Summary of Results

| Analysis                   | Result                |
| -------------------------- | --------------------- |
| Protein sequences analyzed | 15                    |
| Reference protein          | NAC032, *A. thaliana* |
| Reference accession        | Q9CAR0 / NP_177869.1  |
| Reference length           | 253 aa                |
| Original MSA               | 345 positions         |
| Trimmed MSA                | 281 positions         |
| Phylogenetic model         | JTT+G4                |
| UFBoot replicates          | 1000                  |
| SH-aLRT replicates         | 1000                  |
| NAM domain                 | 15/15 proteins        |
| NAM Pfam                   | PF02365               |
| NAM superfamily            | cl03558               |
| ≥90% conserved residues    | 115                   |
| 100% conserved residues    | 96                    |
| WKATG motif                | 15/15                 |
| NAC032 motif position      | W91-K92-A93-T94-G95   |
| AlphaFold model            | AF-Q9CAR0-F1          |
| Structure length           | 253 aa                |
| Average pLDDT              | 70.62                 |

---

# 19. Tools and Databases Used

| Tool / Database       | Purpose                                  |
| --------------------- | ---------------------------------------- |
| UniProt               | Reference protein selection              |
| NCBI BLASTp           | Homolog identification                   |
| NCBI EDirect / efetch | Protein sequence retrieval               |
| Linux Bash / AWK      | Sequence QC and sequence processing      |
| MAFFT v7.525          | Multiple sequence alignment              |
| trimAl v1.5.rev1      | Alignment trimming                       |
| IQ-TREE v3.1.3        | Maximum-likelihood phylogenetic analysis |
| iTOL                  | Tree visualization                       |
| NCBI CD-Search        | Conserved NAM domain identification      |
| AlphaFold DB          | Predicted protein structure              |
| PyMOL                 | 3D structural visualization              |

---

# 20. Repository Structure

```text
NAC32-homolog-analysis/
│
├── README.md
│
├── bash/
│   ├── sequence_retrieval.sh
│   ├── sequence_quality_control.sh
│   ├── alignment.sh
│   ├── gap_analysis.sh
│   ├── trimming.sh
│   ├── phylogeny.sh
│   ├── nam_region.sh
│   └── conservation.sh
│
├── data/
│   ├── accessions.txt
│   └── NAC_homologs.fasta
│
├── alignment/
│   ├── NAC32_reference_alignment.fasta
│   ├── NAC_NAM_alignment.fasta
│   ├── NAC_Nterminal150.fasta
│   ├── NAC_aligned.fasta
│   ├── NAC_trimmed.fasta
│   └── gap_percent.txt
│
├── conservation/
│   ├── NAC32_conserved_residue_mapping.txt
│   ├── conserved_100_percent.txt
│   ├── conserved_90_99_percent.txt
│   └── highly_conserved_positions.txt
│
├── phylogeny/
│   ├── NAC_NAC32_ML.tree
│   ├── NAC_trimmed.fasta.contree
│   ├── NAC_trimmed.fasta.iqtree
│   └── NAC_trimmed.fasta.treefile
│
├── results/
│   ├── NAC32_phylogenetic_tree.png
│   └── wkatg.png
│
└── structure/
    └── AF-Q9CAR0-F1-model_v6.pdb
```

---

# 21. Conclusion

This project provides a computational characterization of *Arabidopsis thaliana* NAC032 using sequence, evolutionary, domain, conservation, motif, and structural analyses.

The analysis included **15 NAC-related protein sequences** and demonstrated that all selected proteins contained the conserved NAM domain. Detailed analysis of the NAM-containing region identified **96 completely conserved residues** and **115 residues with at least 90% conservation**.

The `WKATG` motif was detected in all 15 sequences and corresponds to **W91-K92-A93-T94-G95** in the NAC032 reference protein.

Phylogenetic analysis using IQ-TREE provided an evolutionary framework for the selected sequences, while AlphaFold and PyMOL provided structural context for the conserved NAC032 region.

Overall, the project integrates:

**homolog identification → sequence QC → alignment → trimming → phylogeny → domain analysis → conservation → motif analysis → structural analysis**

into a reproducible computational workflow for studying NAC transcription factor sequences.

Sequence similarity and phylogenetic clustering were used to describe relatedness, but were not treated as definitive evidence of orthology.
