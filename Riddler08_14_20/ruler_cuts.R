library(gganimate)
library(gifski)
library(magrittr)
library(tidyverse)

cuts_database <- read.csv2("Riddler 08_14_20/ruler_cuts.csv",sep=",") %>% mutate(X=X+1)
cuts_database %<>% mutate_at(vars(starts_with("n")), funs(as.integer))
cuts_database %<>% mutate(length=ifelse(n2>6,n2-n1,
                                       ifelse(n3>6,n3-n2,
                                              ifelse(n4>6,n4-n3,n5-n4))))

cuts_database %<>% mutate(cut_center=ifelse(n2>6,(n2-n1)/2,
                                        ifelse(n3>6,n2+(n3-n2)/2,
                                               ifelse(n4>6,n3+(n4-n3)/2,n4+(n5-n4)/2))))

cuts_database %<>% mutate(cum_average=cummean(length))

g<-ggplot()+
  #RULER DETAILS
  geom_rect(aes(xmin=-0.2,xmax=12.2,ymin=7,ymax=8),fill="#fdd302")+
  geom_segment(aes(x=seq(0,12),y=8,xend=seq(0,12),yend=7.5),color="black")+
  geom_text(aes(x=seq(0,12),y=7.3,label=seq(0,12)),size=2.5)+
  geom_segment(aes(x=seq(0,12,(12/24)),y=8,xend=seq(0,12,(12/24)),yend=7.7),color="black")+
  geom_segment(aes(x=seq(0,12,(12/144)),y=8,xend=seq(0,12,(12/144)),yend=7.875),color="black")+
  #CUTS
  geom_segment(data=cuts_database,aes(x=n2,y=6.8,xend=n2,yend=8.2),color="red3",size=1,linetype="dashed")+
  geom_segment(data=cuts_database,aes(x=n3,y=6.8,xend=n3,yend=8.2),color="red3",size=1,linetype="dashed")+
  geom_segment(data=cuts_database,aes(x=n4,y=6.8,xend=n4,yend=8.2),color="red3",size=1,linetype="dashed")+
  #CUMULATIVE STATS
  geom_text(data=cuts_database,aes(x=6,y=4.5,label="Average length of pieces containing the 6 in mark:"),size=6)+
  geom_text(data=cuts_database,aes(x=6,y=3.3,label=paste(round(cum_average,2),"in")),size=10)+
  scale_x_continuous(limits=c(-1,13))+
  scale_y_continuous(limits=c(1,10))+
  coord_fixed()+
  labs(title = "Number of rulers produced: {closest_state}") +
  theme_void()+
  theme(plot.title = element_text(hjust=0.5,face="bold",size=15))+
  transition_states(X)
  
animate(g, renderer = gifski_renderer(),fps=5,end_pause = 15,nframes=500)
anim_save("cuts_animation.gif")
