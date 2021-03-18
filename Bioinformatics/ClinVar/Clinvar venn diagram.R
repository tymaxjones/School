#Read in the tables
tablead <- read.delim("C:/Users/tymax/Downloads/clinvar_resultad.txt", header = TRUE, sep = "\t")
tablec <- read.delim("C:/Users/tymax/Downloads/clinvar_resultc.txt", header = TRUE, sep = "\t")
tablece <- read.delim("C:/Users/tymax/Downloads/clinvar_resultce.txt", header = TRUE, sep = "\t")
tableh <- read.delim("C:/Users/tymax/Downloads/clinvar_resulth.txt", header = TRUE, sep = "\t")



#Get unique Genes
c_genes <- unique(tablec$Gene.s.)
ad_genes <- unique(tablead$Gene.s.[ nchar(tablead$Gene.s.) < 10 ])
ce_genes <- unique(tablece$Gene.s.)
h_genes <- unique(tableh$Gene.s.)



##Pairwise
#AD C
c_genes[c_genes %in% ad_genes]

#AD CE
ce_genes[ce_genes %in% ad_genes]

#AD H
h_genes[h_genes %in% ad_genes]


#C CE
ce_genes[ce_genes %in% c_genes]


#C H
c_genes[c_genes %in% h_genes]


#CE H
ce_genes[ce_genes %in% h_genes]



## Groups of 3 (AD' indicates all but AD)
#AD'
ce_genes[ce_genes %in% h_genes %in% c_genes]

#C'
ce_genes[ce_genes %in% h_genes %in% ad_genes]

#CE'
c_genes[c_genes %in% h_genes %in% ad_genes]

#H'
ce_genes[ce_genes %in% c_genes %in% ad_genes]



##alltogether
ce_genes[ce_genes %in% c_genes %in% ad_genes %in% h_genes]





#### Creating the Venn Diagram


library(VennDiagram)
library(RColorBrewer)

# Chart
myCol <- brewer.pal(4, "Spectral")

venn.diagram(
  x = list(ad_genes, c_genes, h_genes, ce_genes),
  category.names = c("Eczema" , "Chron's" , "Hashimoto's Thyroiditis", "Celiac"),
  filename = 'genes_venn_diagramm.png',
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


