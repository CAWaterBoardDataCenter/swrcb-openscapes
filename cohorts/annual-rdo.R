library(readr)
library(tidyr)
library(ggplot2)
library(viridis)

rdo = read_csv("annual-rdo.csv")
rdo_long <- gather(rdo, Cohort, Count, '2022':'2023')
rdo_long$RDO <- factor(rdo_long$RDO, levels=rev(unique(rdo_long$RDO)))

ggplot(rdo_long, aes(fill=Cohort, x=Count, y=RDO)) + 
  geom_bar(position="stack", stat="identity") +
  theme(legend.position = "top") +
  xlab("Number of Individuals") + 
  ylab("Water Boards Region, Division, or Office (RDO)") +
  scale_fill_viridis(discrete = TRUE, option = "viridis")

ggsave(path = "cohorts/images", filename = "annual-rdo.png")
