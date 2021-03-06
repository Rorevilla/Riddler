library(R.utils)    #for binary conversion
library(magrittr)   #pipping
library(tidyverse)  #dplyr, ggplot, etc
library(hrbrthemes) #custom theme for ggplot
library(cowplot)    #adding grobs to ggplot

#Setting up reference DataFrame
shire <- c("Oneshire","Twoshire","Threeshire","Fourshire","Fiveshire","Sixshire","Sevenshire","Eightshire","Nineshire","Tenshire")
population <- c(11,21,31,41,51,61,71,81,91,101)
votes <- c(3,4,5,6,7,8,9,10,11,12)
shires <- data.frame(shire,population,votes)
shires %<>% mutate(votes_to_win_shire = population%/%2+1)
shires

#1024 combinations produced
numbers <- 0:1023
combinations <- as.data.frame(numbers) %>% mutate(binary = intToBin(numbers),numbers=NULL)
combinations%<>% separate(binary,into=paste0("s", seq(1:10)),sep = "(?<=.)")
combinations%<>% mutate(total_electoral_votes = ifelse(s1==1,votes[1],0)+
                                                ifelse(s2==1,votes[2],0)+
                                                ifelse(s3==1,votes[3],0)+
                                                ifelse(s4==1,votes[4],0)+
                                                ifelse(s5==1,votes[5],0)+
                                                ifelse(s6==1,votes[6],0)+
                                                ifelse(s7==1,votes[7],0)+
                                                ifelse(s8==1,votes[8],0)+
                                                ifelse(s9==1,votes[9],0)+
                                                ifelse(s10==1,votes[10],0))
combinations %<>% filter(total_electoral_votes > Reduce("+",votes)%/%2)
combinations%<>% mutate(total_population_votes = ifelse(s1==1,population[1]%/%2+1,0)+
                                                  ifelse(s2==1,population[2]%/%2+1,0)+
                                                  ifelse(s3==1,population[3]%/%2+1,0)+
                                                  ifelse(s4==1,population[4]%/%2+1,0)+
                                                  ifelse(s5==1,population[5]%/%2+1,0)+
                                                  ifelse(s6==1,population[6]%/%2+1,0)+
                                                  ifelse(s7==1,population[7]%/%2+1,0)+
                                                  ifelse(s8==1,population[8]%/%2+1,0)+
                                                  ifelse(s9==1,population[9]%/%2+1,0)+
                                                  ifelse(s10==1,population[10]%/%2+1,0))

#Optimal combination(s) selected
combinations %>% top_n(n = -1, wt = total_population_votes)
136/Reduce("+",population)*100

#Wrangling data for plotting
solutions <- combinations %>% top_n(n = -1, wt = total_population_votes)
solutions  %<>%  mutate(solution_number = row_number())
solutions %<>% select(-total_electoral_votes,-total_population_votes) %>% gather(key="shire",value="winner",-solution_number)
solutions   %<>%  mutate(shire=recode_factor(shire,s1="Oneshire",s2="Twoshire",s3="Threeshire",s4="Fourshire",s5="Fiveshire",s6="Sixshire",
                                           s7="Sevenshire",s8="Eightshire",s9="Nineshire",s10="Tenshire"))
solutions  %<>% left_join(shires %>% select(shire,electoral_votes=votes,votes_to_win_shire,population))
solutions  %<>%  mutate(label=paste(ifelse(winner==1,votes_to_win_shire,0),"/",population,"\n",ifelse(winner==1,electoral_votes,0),"/",electoral_votes))

#Producing base plot
a <- solutions %>% ggplot(aes(x=shire,y=as.character(solution_number),fill=winner))+
  geom_tile(color="white",size=1)+
  ggthemes::scale_fill_tableau(name = "Shire Winner", labels = c("Candidate A", "Candidate B"))+
  labs(x="Shire",y="Scenario")+
  geom_text(aes(label=label),size=3,color="white")+
  coord_fixed()+
  theme_ipsum_rc()+
  theme(axis.text.x = element_text(angle = 45,hjust = 1))+
  theme(legend.position = "bottom")+
  theme(axis.title.x = element_text(hjust = 0, vjust=0, colour="darkgrey",size=12,face="bold"))+
  theme(axis.title.y = element_text(hjust = 0, vjust=3, colour="darkgrey",size=12,face="bold"))

#Adding scenario summaries
additional_elements <- ggdraw()
for (i in seq(0.34,0.87,0.106)) {
  additional_elements <- additional_elements + draw_label("136 / 560 voters\n38 / 75 electoral votes", x = 0.92, y = i,colour = "black",size=9)
}

#Adding title
additional_elements <- additional_elements + draw_label("There are six scenarios where                        wins the election, with only 24.3% of the popular vote", x = 0.5, y = 0.96,colour = "black",fontface="bold",size=12)
additional_elements <- additional_elements + draw_label("Candidate B", x = 0.3878, y = 0.96,colour = "#F28E2B",fontface="bold",size=12)
additional_elements <- additional_elements + draw_label("github.com/Rorevilla", x = 0.93, y = 0.1,colour = "gray50",fontface="bold",size=8.5)

#Exporting plot
final_plot<-additional_elements+draw_plot(a+ theme(plot.margin = margin(t = 0, r = 1.4, b = 0, l = 0, unit = "in")))
save_plot("plot.png",final_plot,base_width=8,base_height=6)

