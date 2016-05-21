---
title: "README"
author: "Javier"
date: "21 de mayo de 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Description


The first part of the code checks whether the zip file has been downloaded in the Working Directory. If the file is in the WD, the code start to work with it; otherwise, the code download the file and unzip it.
Basically all the files are read using "read.table" function. Once all data is read it, all the data is merge using "cbind" function. Also, the column names of all data set is updated using "gsub" function. Then, using the function "grep" all the data is sorted according the Mean and Std columns. Using the function "factor" the activity names was changed according the activity name file. Finally, the data was melted using the "melt" function and the mean was calculated using the "dcast" function.