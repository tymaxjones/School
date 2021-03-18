#load in data
library(readr)
GWAS_Crohns <- read_csv("C:/Users/tymax/Downloads/GWAS Crohns.csv")
GWAS_Hashimoto <- read_csv("C:/Users/tymax/Downloads/GWAS Hashimoto.csv")
GWAS_Celiac <- read_csv("C:/Users/tymax/Downloads/GWAS Celiac.csv")
GWAS_Eczema <- read_csv("C:/Users/tymax/Downloads/GWAS Eczema.csv")




#separate columns Celiac
GWAS_Celiac$ID <- sub("*\\-<b>[A,T,G,C,?]</b>", "", GWAS_Celiac$`Variant and risk allele`)
GWAS_Celiac$allele <- gsub(".*-<b>(.+)</b>.*", "\\1", GWAS_Celiac$`Variant and risk allele`)

#Separate Columns Crohns
GWAS_Crohns$ID <- sub("*\\-<b>[A,T,G,C,?]</b>", "", GWAS_Crohns$`Variant and risk allele`)
GWAS_Crohns$allele <- gsub(".*-<b>(.+)</b>.*", "\\1", GWAS_Crohns$`Variant and risk allele`)

#Separate Columns Hashimoto
GWAS_Hashimoto$ID <- sub("*\\-<b>[A,T,G,C,?]</b>", "", GWAS_Hashimoto$`Variant and risk allele`)
GWAS_Hashimoto$allele <- gsub(".*-<b>(.+)</b>.*", "\\1", GWAS_Hashimoto$`Variant and risk allele`)

#Separate Columns Eczema
GWAS_Eczema$ID <- sub("*\\-<b>[A,T,G,C,?]</b>", "", GWAS_Eczema$`Variant and risk allele`)
GWAS_Eczema$allele <- gsub(".*-<b>(.+)</b>.*", "\\1", GWAS_Eczema$`Variant and risk allele`)


#See if any SNPs Match up

CeliacSNP <- unique(GWAS_Celiac$ID)
CrohnsSNP <- unique(GWAS_Crohns$ID)
HashimotoSNP <- unique(GWAS_Hashimoto$ID)
EczemaSNP <- unique(GWAS_Eczema$ID)


#AD Celiac

library(VennDiagram)
library(RColorBrewer)

# Chart
myCol <- brewer.pal(4, "Spectral")

venn.diagram(
  x = list(EczemaSNP, CrohnsSNP, HashimotoSNP, CeliacSNP),
  category.names = c("Eczema" , "Crohn's" , "Hashimoto's Thyroiditis", "Celiac"),
  filename = 'SNPs_venn_diagramm.png',
  output=TRUE,
  lwd = 2,
  lty = 'blank',
  fill = myCol,
  
  # Numbers
  cex = .6,
  fontface = "bold",
  fontfamily = "sans",
  cat.cex = 0.6,
  cat.fontface = "bold",
  cat.default.pos = "outer",
  cat.fontfamily = "sans"
)



#Looking at the overlap between AD C and CE

filter <- CeliacSNP[CeliacSNP %in% EczemaSNP]


tbl_ce <- GWAS_Celiac[GWAS_Celiac$ID %in% filter, c("ID", "allele", "P-value")]
tbl_c <- GWAS_Crohns[GWAS_Crohns$ID %in% filter, c("ID", "allele", "P-value")]
tbl_ad <- GWAS_Eczema[GWAS_Eczema$ID %in% filter, c("ID", "allele", "P-value")]

ce_list <- c()
c_list <- c()
ad_list <- c()

for (i in unique(tbl_ad$ID)) {
 ce_alleles <- paste(unique(tbl_ce[tbl_ce$ID == i,2][[1]]), collapse = "")
 c_alleles <- paste(unique(tbl_c[tbl_ce$ID == i,2][[1]]), collapse = "")
 ad_alleles <- paste(unique(tbl_ad[tbl_ad$ID == i,2][[1]]), collapse = "")
 
 ce_list <- append(ce_list, ce_alleles)
 c_list <- append(c_list, c_alleles)
 ad_list <- append(ad_list, ad_alleles)
 
}

ce_list
c_list
ad_list    
SNP<- unique(tbl_ad$ID)


#Data Frame for mix of CE C and AD SNPS
data.frame(SNP, c_list, ce_list, ad_list)

