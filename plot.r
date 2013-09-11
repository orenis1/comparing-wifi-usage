library(plyr)


chicago.raw <- read.csv('data/chicago.csv')
chicago <- data.frame (
  city = 'Chicago',
  month = strptime(paste0('1 ',chicago.raw$MONTH, ', ', chicago.raw$YEAR), format = '%d %B, %Y'),
  sessions = chicago.raw$NUMBER.OF.SESSIONS
)

newyork.raw <- read.csv('data/newyork.csv')
newyork.aggregated <- ddply(newyork.raw, c('Year', 'Month'), function(df) { c(sessions = sum(df$X..of.Sessions)) })
newyork <- data.frame (
  city = 'New York',
  month = as.POSIXct(paste(newyork.aggregated$Year, newyork.aggregated$Month, '01', sep = '-')),
  sessions = newyork.aggregated$sessions
)

DICTIONNAIRE <- c('Janvier' = 1)
paris.raw <- read.csv('data/paris.csv', sep = ';')
paris <- data.frame (
  city = 'Paris',
  month = strptime(paste0('1 ', DICTIONNAIRE[paris.raw$mois], ', ', paris.raw$annee), format = '%d %B, %Y'),
  sessions = paris.raw$nombre_session_total
)


