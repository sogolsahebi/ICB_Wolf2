# Microarray Data Processing.
# File:Save Format_EXPR.csv- (dimension is 21508 x 105)

# Read libraries.
library(data.table)

# Data Reading
# expr is single gene-level dataset with log2gNor (data is log2 transformed and then quantile normalized)
expr <- as.data.frame(fread("files/EXPR.txt.gz", sep = "\t", dec = ",", stringsAsFactors = FALSE))

# Set first column as rows
rownames(expr) <- expr[, 1]
expr <- expr[, -1] # dim 21508   105

# Data Filtering
case <- read.csv("files/cased_sequenced.csv", sep = ";")

# Filter the 'expr' dataset to include patients with expr value of 1 in the 'case' dataset
expr <- expr[, colnames(expr) %in% case[case$expr == 1, ]$patient]
expr <- as.data.frame(lapply(expr, as.numeric), row.names = rownames(expr))

# Write the transformed data to csv file.
write.table( expr, "files/EXPR.csv", quote=FALSE , sep=";" , col.names=TRUE , row.names=TRUE )
