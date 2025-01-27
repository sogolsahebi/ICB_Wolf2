# Format_downloaded_data.R

# This script formats and cleans clinical and expression data.
# - Creates "CLIN.txt" ,dimension 105 x 20
# - Creates "EXPR.txt.gz", dimension 21508 x 105

# Load required libraries
library(GEOquery)

# Get source files from GEO "GSE173839" and extract the tar file
download.file("https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE173839&format=file&file=GSE173839_ISPY2_DurvalumabOlaparibArm_biomarkers.csv.gz", 
              destfile = "source data/GSE173839_ISPY2_DurvalumabOlaparibArm_biomarkers.csv.gz")

# Read and format clinical data
clin <- read.csv(gzfile("source data/GSE173839_ISPY2_DurvalumabOlaparibArm_biomarkers.csv.gz")) # dim 105 x 20

# Set patient column
colnames(clin)[colnames(clin) == "ResearchID"] <- "patient"

# Add "X" to patient column for matching expr columns.
clin$patient <- paste0("X", clin$patient)

# Save clinical data as CLIN.txt
write.table(clin, "files/CLIN.txt", quote = FALSE, sep = "\t", row.names = FALSE)

# Read and process expression data
download.file("https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE173839&format=file&file=GSE173839_ISPY2_AgilentGeneExp_durvaPlusCtr_FFPE_meanCol_geneLevel_n105.txt.gz", 
              destfile = "source data/GSE173839_ISPY2_AgilentGeneExp_durvaPlusCtr_FFPE_meanCol_geneLevel_n105.txt.gz")

expr <- read.table(gzfile("source data/GSE173839_ISPY2_AgilentGeneExp_durvaPlusCtr_FFPE_meanCol_geneLevel_n105.txt.gz"), header = TRUE) # dim 21508 x 106

# Set Rownames as gene names
rownames(expr) <- expr$GeneName
expr$GeneName <- NULL

# Sort the rownames of 'expr'
expr <- expr[sort(rownames(expr)), ]

# Save expression data as EXPR.txt.gz
gz_conn <- gzfile("files/EXPR.txt.gz", "w")
write.table(expr, gz_conn, sep = "\t", row.names = TRUE, quote = FALSE)
close(gz_conn)
