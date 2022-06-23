library(rstatix)
library(readxl)
library(ggpubr)

# Define objects and location of DF containing RT-PCR gene expression thresholds (Ct values)
gene="SPARC"
plotFolder="../plots/"
directory <- "../data/"
actinPlotFile <-paste0(gene,"_Actin_Normal.pdf")
gapdhPlotFile <-paste0(gene,"_Gapdh_Normal.pdf")
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
##################### A) Endogenous Normalization with ACTN
###########################################################
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

####################################################
########## Condition Test Per Cell Line ############ 

# 1) Subset Hours

gene_expression_df_subset_actn.48h <- gene_expression_df[ which(
  gene_expression_df$`Hours` == "48h"  ), ]

gene_expression_df_subset_actn.96h <- gene_expression_df[ which(
  gene_expression_df$`Hours` == "96h"  ), ]

gene_expression_df_subset_actn.144h <- gene_expression_df[ which(
  gene_expression_df$`Hours` == "144h"  ), ]


t_test.cell_line.Condition.actn.48h <- gene_expression_df_subset_actn.48h %>%
  group_by(`Cell_Line`) %>%
  t_test(`RQ 48h` ~ Condition) %>%
  adjust_pvalue(method = "bonferroni")
t_test.cell_line.Condition.actn.48h["Time Point"] <- "48h"

t_test.cell_line.Condition.actn.96h <- gene_expression_df_subset_actn.96h %>%
  group_by(`Cell_Line`) %>%
  t_test(`RQ 48h` ~ Condition) %>%
  adjust_pvalue(method = "bonferroni")
t_test.cell_line.Condition.actn.96h["Time Point"] <- "96h"

t_test_temp <- rbind(t_test.cell_line.Condition.actn.48h, t_test.cell_line.Condition.actn.96h)

t_test.cell_line.Condition.actn.144h <- gene_expression_df_subset_actn.144h %>%
  group_by(`Cell_Line`) %>%
  t_test(`RQ 48h` ~ Condition) %>%
  adjust_pvalue(method = "bonferroni")
t_test.cell_line.Condition.actn.144h["Time Point"] <- "144h"

t_test.cell_line.Condition.actn <- rbind(t_test_temp, t_test.cell_line.Condition.actn.144h)

#########################################################
############# Cell Line Test Per Condition ############## 

t_test.Condition.cell_type.actn <- gene_expression_df_subset_actn %>%
  group_by(`Condition`) %>%
  t_test(`RQ 48h` ~ `Sample`) %>%
  adjust_pvalue(method = "bonferroni") #%>%

###########################################
############# Create Barplot ##############

barplot <- ggbarplot(gene_expression_df_subset_actn, 
                     x = "Hours", y = "RQ 48h", 
                     fill = "Sample",
                     color = "Sample",
                     add = "mean_sd", 
                     ylab = paste0(gene, "/ACTN RQ 48h"),
                     palette = c("#0412d4", "#f71105", "#0412d4", "#f71105"),
                     position = position_dodge())

##########################################################################################
############# Add 10% spaces between the p-value labels and the plot border ##############

barplot <- barplot + 
  geom_bracket(
    xmin = c("48h", "96h", "48h"), # xmin matches xmax: WN_N goes w/ WN_H
    xmax = c("96h", "144h", "144h"), 
    y.position = c(0.15, 0.16, 0.17),          # Same order as above
    label = c("***", "**", "**")         # Same order as above
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)))
barplot

############################################################
############# Plot Actin Normalization Figure ##############

library(gridExtra)
pdf(file = paste0(plotFolder,actinPlotFile),   
    width = 8, 
    height = 5)
grid.arrange(barplot, 
             top=paste0(gene,"/ACTN"),
             ncol = 1,
             nrow = 1)
dev.off()

###########################################################
#################### B) Endogenous Normalization with GAPDH
###########################################################
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

####################################################
########## Condition Test Per Cell Line ############ 

t_test.cell_line.Condition.gapdh <- gene_expression_df_subset_gapdh %>%
  group_by(`Cell_Line`) %>%
  t_test(`RQ 48h` ~ Condition) %>%
  adjust_pvalue(method = "bonferroni") #%>%

#########################################################
############# Cell Line Test Per Condition ############## 

t_test.Condition.cell_type.gapdh <- gene_expression_df_subset_gapdh %>%
  group_by(`Condition`) %>%
  t_test(`RQ 48h` ~ `Sample`) %>%
  adjust_pvalue(method = "bonferroni") #%>%

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

### Plot GAPDH Normalization Figure
library(gridExtra)
pdf(file = paste0(plotFolder,gapdhPlotFile),   
    width = 8, 
    height = 5)
grid.arrange(barplot, 
             top=paste0(gene,"/GAPDH"),
             ncol = 1,
             nrow = 1)
dev.off()
