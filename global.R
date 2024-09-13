library(shiny)
library(shinydashboard)
library(shinydashboardPlus)

library(performance)
library(dplyr)
library(ggplot2)
library(scales)
library(ggpubr)
library(plotly)
library(glue)

# Palet warna pastel
palet_warna <- c("#232323", "#656565","#989898", "#58508d", "#bc5090", "#e090df", "#fbbede")

# Load the pre-trained model
model <- readRDS("model_all.RDS")

properti <- read.csv("data_input/properti_jual.csv", stringsAsFactors = T)

properti_rumah <- properti %>% 
  filter(Tipe.Properti == "Rumah") %>% 
  select(-Tipe.Properti)

