#install.packages("here")
#install.packages("readr")
#install.packages("tidyr")
#install.packages("ggplot2")
#install.packages("viridis")

library(here)
library(readr)
library(tidyr)
library(ggplot2)
library(viridis)

# Update RDO Data in "cohorts/annual-rdo.csv" 
# Import the RDO data
rdo = read.csv(here("cohorts/annual-rdo.csv"))

# Convert from wide to long format
rdo_long <- gather(rdo, Cohort, Count, 'X2022_F':'X2024_SIM')

# Convert RDO to a factor
rdo_long$RDO <- factor(rdo_long$RDO, levels=rev(unique(rdo_long$RDO)))

# Remove the first character ("X") in front of Cohort years
rdo_long$Cohort <- gsub("^.{0,1}", "", rdo_long$Cohort)

# Add a column to specify the type of individuals represented
rdo_long$IndividualType <- ""

# If Cohort ends in "IM", make IndividualType = "Instructors + Mentors", else  "Team Members"
rdo_long$IndividualType <- ifelse(grepl("IM", rdo_long$Cohort), "Instructors + Mentors", "Team Members")

# Remove "IM" from Cohort years
rdo_long$Cohort <- gsub("\\IM$","", rdo_long$Cohort)

# Create the plot
ggplot(rdo_long, aes(fill=Cohort, x=Count, y=RDO)) + 
  geom_bar(position="stack", stat="identity") +
  xlab("Number of Individuals") + 
  ylab("Water Boards Region, Division, or Office (RDO)") +
  scale_fill_viridis(discrete = TRUE, option = "viridis") +
  facet_wrap(~factor(IndividualType, c("Team Members", "Instructors + Mentors")), 
             scales = "free") +
  scale_x_continuous(breaks =c(0,2,4,6,8,10,12,14))

# Save the plot
ggsave(path = "cohorts/images", filename = "annual-rdo.png",
       dpi = 600, width = 7.08, height = 5, units = "in")
