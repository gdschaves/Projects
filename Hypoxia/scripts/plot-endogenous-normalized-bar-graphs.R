library(rstatix)
library(readxl)
library(ggpubr)

# Define the gene of interest
gene="SPARC"

# Define location of dataframe containing RT-PCR gene expression thresholds (Ct values)
directory <- "../data/"
excel_file <- "GeneExpressionDF.xlsx"
gene_expression_df <- read_excel(paste0(directory, excel_file))

# Subset Date Seeded "20220607"
gene_expression_df <- gene_expression_df[ which(
  gene_expression_df$Date_Seeded == "20220607"), ]

# Subset Number Experiment
gene_expression_df <- gene_expression_df[ which(
  gene_expression_df$Number_Given_to_Experiment == "0" |
    gene_expression_df$Number_Given_to_Experiment == "1" |
    gene_expression_df$Number_Given_to_Experiment == "2" |
    gene_expression_df$Number_Given_to_Experiment == "3"), ]

# Subset Time Point for both ACTN and GAPDH
gene_expression_df <- gene_expression_df[ which(
  gene_expression_df$`Hours` == '48h' |
    gene_expression_df$`Hours` == '96h' |
    gene_expression_df$`Hours` == '144h'), ]

###########################################################
###########################################################
##################### A) Endogenous Normalization with ACTN
###########################################################
###########################################################

## Subset target and endogenous control for analysis
# 1) Subset target
gene_expression_df_subset_actn <- gene_expression_df[ which(
  gene_expression_df$`Target Gene Name` == gene  ), ]
# 2) Subset Endogenous Control
gene_expression_df_subset_actn <- gene_expression_df_subset_actn[ which(
  gene_expression_df_subset_actn$`Endogenous Control Name` == 'ACTN'  ), ]

# Reorder Sample, so Normoxia comes before Hypoxia in the graph
gene_expression_df_subset_actn$Sample <- factor(
  gene_expression_df_subset_actn$Sample, levels=c("WN_N", "WN_H", "WS_N", "WS_H"))

# Reorder Hours
gene_expression_df_subset_actn$Hours <- factor(
  gene_expression_df_subset_actn$Hours, levels=c("48h", "96h", "144h"))

#### Normoxia-Hypoxia Statistical Test ####
# stat.test is a DF with the padj and the Stars
stat.test.normoxia_hypoxia.actn <- gene_expression_df_subset_actn %>%
  group_by(`Cell_Line`) %>%
  t_test(RQ ~ Condition) %>%
  adjust_pvalue(method = "bonferroni") #%>%
#add_significance("p.adj")

#### WN/WS Statistical Test ####
# stat.test is a DF with the padj and the Stars
stat.test.wn_ws.actn <- gene_expression_df_subset_actn %>%
  group_by(`Condition`) %>%
  t_test(RQ ~ `Sample`) %>%
  adjust_pvalue(method = "bonferroni") #%>%
#add_significance("p.adj")

## Create Barplot
# Change the width of bars
barplot <- ggbarplot(gene_expression_df_subset_actn, 
                     x = "Hours", y = "RQ", 
                     fill = "Sample",
                     color = "Sample",
                     add = "mean_sd", 
                     ylab = paste0(gene, "/ACTN RQ"),
                     palette = c("#0412d4", "#f71105", "#0412d4", "#f71105"),
                     position = position_dodge())

# Add 10% spaces between the p-value labels and the plot border
barplot <- barplot + 
  geom_bracket(
    xmin = c("48h", "96h", "48h"), # xmin matches xmax: WN_N goes w/ WN_H
    xmax = c("96h", "144h", "144h"), 
    y.position = c(57, 67, 77),          # Same order as above
    label = c("***", "**", "**")         # Same order as above
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)))
barplot

###########################################################
###########################################################
#################### B) Endogenous Normalization with GAPDH
###########################################################
###########################################################

## Subset target and endogenous control for analysis
# 1) Subset target
gene_expression_df_subset_gapdh <- gene_expression_df[ which(
  gene_expression_df$`Target Gene Name` == gene  ), ]
# 2) Subset Endogenous Control
gene_expression_df_subset_gapdh <- gene_expression_df_subset_gapdh[ which(
  gene_expression_df_subset_gapdh$`Endogenous Control Name` == 'GAPDH'  ), ]

# Reorder Sample, so Normoxia comes before Hypoxia in the graph
gene_expression_df_subset_gapdh$Sample <- factor(
  gene_expression_df_subset_gapdh$Sample, levels=c("WN_N", "WN_H", "WS_N", "WS_H"))

# Reorder Hours
gene_expression_df_subset_gapdh$Hours <- factor(
  gene_expression_df_subset_gapdh$Hours, levels=c("48h", "96h", "144h"))

#### Normoxia-Hypoxia Statistical Test ####
# stat.test is a DF with the padj and the Stars
stat.test.normoxia_hypoxia.gapdh <- gene_expression_df_subset_gapdh %>%
  group_by(`Cell_Line`) %>%
  t_test(RQ ~ `Condition`) %>%
  adjust_pvalue(method = "bonferroni") #%>%
#add_significance("p.adj")

#### WN/WS Statistical Test ####
# stat.test is a DF with the padj and the Stars
stat.test.wn_ws.gapdh <- gene_expression_df_subset_gapdh %>%
  group_by(`Condition`) %>%
  t_test(RQ ~ `Sample`) %>%
  adjust_pvalue(method = "bonferroni") #%>%
#add_significance("p.adj")

## Create Barplot
# Change the width of bars
barplot <- ggbarplot(gene_expression_df_subset_gapdh, 
                     x = "Hours", y = "RQ", 
                     fill = "Sample",
                     color = "Sample",
                     add = "mean_sd", 
                     ylab = paste0(gene, "/GAPDH RQ"),
                     palette = c("#0412d4", "#f71105", "#0412d4", "#f71105"),
                     position = position_dodge())

# Add 10% spaces between the p-value labels and the plot border
barplot <- barplot + 
  geom_bracket(
    xmin = c("48h", "96h", "48h"), # xmin matches xmax: WN_N goes w/ WN_H
    xmax = c("96h", "144h", "144h"), 
    y.position = c(95, 105, 115),          # Same order as above
    label = c("***", "**", "**")         # Same order as above
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)))
barplot
