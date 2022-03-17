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

Sartists <- get_my_top_artists_or_tracks(50, type = "artists", time_range = "short_term")  %>%
     mutate(range = "short") %>%
     mutate(rangenum = 1) %>%
     mutate(rank = row_number())

Martists <- get_my_top_artists_or_tracks(50, type = "artists", time_range = "medium_term") %>%
     mutate(range = "mid") %>%
     mutate(rangenum = 2) %>%
     mutate(rank = row_number())

Lartists<- get_my_top_artists_or_tracks(50, type = "artists", time_range = "long_term") %>%
     mutate(range = "long") %>%
     mutate(rangenum = 3) %>%
     mutate(rank = row_number())

topartists <- list(Sartists, Martists, Lartists)

tempTopArtists <- do.call('rbind', topartists) 

tempTopArtists <- tempTopArtists %>% 
     mutate(userName = yourName)

#export! 
filename <- paste(yourName, "TopArtists", sep="")
dir <- "results/"

#save as an Rdata object to keep the list cols
save(tempTopArtists, file=paste(dir, filename, ".Rdata", sep = ""))

#save as a csv as a backup

tempTopArtists$genres <- vapply(tempTopArtists$genres, paste, collapse = ", ", character(1L))

tempTopArtists <- tempTopArtists %>% 
  subset(select = -images) 

write.csv(tempTopArtists, paste(dir, filename, ".csv", sep = ""), row.names = FALSE) 
