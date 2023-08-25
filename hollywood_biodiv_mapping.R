


# load libraries ----------------------------------------------------------


library(tidyverse)
library(maps)
library(ggplot2)
library(ggrepel)

# http://sarahleejane.github.io/learning/r/2014/09/20/plotting-beautiful-clear-maps-with-r.html
# https://sarahleejane.github.io/learning/r/2014/09/21/plotting-data-points-on-maps-with-r.html
# prep maps ---------------------------------------------------------------


world_map <- map_data("world")

#Creat a base plot with gpplot2
p <- ggplot() + coord_fixed() +
  xlab("") + ylab("")

#Add map to base plot
base_world_messy <- p + geom_polygon(data=world_map, aes(x=long, y=lat, group=group),
                                     colour="darkgray", fill="darkgray")

base_world_messy

#Strip the map down so it looks super clean (and beautiful!)
cleanup <-
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = 'white', colour = 'white'),
        axis.line = element_line(colour = "white"), legend.position="none",
        axis.ticks=element_blank(), axis.text.x=element_blank(),
        axis.text.y=element_blank())

base_world <- base_world_messy + cleanup

base_world



# read in data ------------------------------------------------------------


hbdata<-read_csv("./data_raw/hb_data_raw.csv") %>%
  mutate_all(tolower) %>%
  mutate(lat=as.numeric(lat)) %>%
  mutate(long=as.numeric(long))

# plot data  --------------------------------------------------------------

map_data <-
  base_world +
  geom_point(data = hbdata,
             aes(
               x = long,
                 y = lat,
                 fill = common_name,
                 shape = common_name
                 ),
             # pch=21,
             size=2,
             alpha=I(0.7))+
  labs(
    title = "Hollywood's Lost Biodiversity",
    subtitle = "submit your sightings at https://github.com/BrunaLab/hollywood-biodiversity"
  )+
  geom_text_repel(data = hbdata,
                  aes(
                    x = long,
                    y = lat,
                    label=title
                  ),
                  # check_overlap = TRUE,
                  # nudge_x = -14.25,
                  # nudge_y = -5.25
                  )+
  facet_wrap(~common_name,
             ncol=1)+
  theme(legend.position = "none",
        strip.text.x = element_text(size=12, face="bold")
        )
map_data


# if you want to change the colors....
# mapfill <- c('screaming piha' = "forestgreen", 'baboon' = "purple")
# maplab <- c('screaming piha' = "screaming piha", 'baboon' = "baboon")
#
# scale_fill_manual(values = mapfill, labels = maplab) +
