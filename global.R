library(shiny)
library(shinyWidgets)
library(shinythemes)
library(shinydashboard)
library(shinyalert)

library(rhandsontable)

library(tidyverse)
library(lubridate)
library(extrafont)
library(RColorBrewer)

suppressWarnings(font_import(pattern = "times", prompt = F))

library(incidence)

library(R0)
library(earlyR)
library(EpiEstim)
library(EpiNow2)

data("H1N1.serial.interval")
data("MockRotavirus")
linelist <- readRDS('data/linelist_cleaned.rds')