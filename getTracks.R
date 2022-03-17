yourName = "changeme" #fill this string with your name

packages.used=as.list(
  c("spotifyr",
    "httpuv",
    "tidyverse")
)
check.pkg = function(x){
  if(!require(x, character.only=T)) install.packages(x, character.only=T, dependence=T)}

lapply(packages.used, check.pkg)

id <- 'a748b3ec8c3c4e64a403fdea99a8844e'
secret <- '4520f0162ac04fcaa082ddd260649b45'
Sys.setenv(SPOTIFY_CLIENT_ID = id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = secret)
access_token <- get_spotify_access_token()

Stracks <- get_my_top_artists_or_tracks(50, type = "tracks", time_range = "short_term")  %>%
  mutate(range = "short") %>%
  mutate(rangenum = 1) %>%
  mutate(rank = row_number())

Mtracks <- get_my_top_artists_or_tracks(50, type = "tracks", time_range = "medium_term") %>%
  mutate(range = "mid") %>%
  mutate(rangenum = 2) %>%
  mutate(rank = row_number())

Ltracks<- get_my_top_artists_or_tracks(50, type = "tracks", time_range = "long_term") %>%
  mutate(range = "long") %>%
  mutate(rangenum = 3) %>%
  mutate(rank = row_number())

toptracks <- list(Stracks, Mtracks, Ltracks)

tempToptracks <- do.call('rbind', toptracks) 

tempToptracks <- tempToptracks %>% 
  mutate(userName = yourName)

#export! 
filename <- paste(yourName, "Toptracks", sep="")
dir <- "results/"

#save as an Rdata object to keep the list cols
save(tempToptracks, file=paste(dir, filename, ".Rdata", sep = ""))

#save as a csv as a backup

#tempToptracks$genres <- vapply(tempToptracks$genres, paste, collapse = ", ", character(1L))

#tempToptracks <- tempToptracks %>% 
#  subset(select = -c(images, )) 

#write.csv(tempToptracks, paste(dir, filename, ".csv", sep = ""), row.names = FALSE) 
