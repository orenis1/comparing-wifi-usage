library(reshape2)
library(plyr)
library(ggplot2)
library(scales)

paris.raw <- read.csv('data/paris.csv', sep = ';')
paris.raw$mois <- factor(paris.raw$mois, levels = c(
  'Janvier',
  'Février',
  'Mars',
  'Avril',
  'Mai',
  'Juin',
  'Juillet',
  'Août',
  'Septembre',
  'Octobre',
  'Novembre',
  'Décembre'
))

endroits <- c(
  "total",
  "parcs_et_jardins",
  "bibliotheques",
  "hotel_de_ville",
  "centre_culturels",
  "divers"
)
columns.sites.ouverts <- c(
  "mois",
  "annee",
  "sites_ouverts_total",
  "sites_ouverts_parcs_et_jardins",
  "sites_ouverts_bibliotheques",
  "sites_ouverts_hotel_de_ville",
  "sites_ouvertes_centre_culturel_s",
  "sites_ouverts_divers"
)
columns.trafic <- c(
  "mois",
  "annee",
  "trafic_en_minutes_total",
  "trafic_en_minutes_parcs_et_jardi",
  "trafic_en_minutes_bibliotheques",
  "trafic_en_minutes_hotel_de_ville",
  "trafic_en_minutes_centre_culture",
  "trafic_en_minutes_divers"
)
columns.sessions <- c(
  "mois",
  "annee",
  "nombre_session_total",
  "nombre_session_parcs_et_jardins",
  "nombre_de_sessions_bibliotheques",
  "nombre_de_sessions_hotel_de_vill",
  "nombre_de_sessions_centre_cultur",
  "nombre_de_sessions_divers"
)

paris.sites.ouverts <- melt(paris.raw[columns.sites.ouverts],
   c('annee','mois'), variable.name = 'endroit', value.name = 'sites.ouverts')
levels(paris.sites.ouverts$endroit) <- endroits

paris.trafic <- melt(paris.raw[columns.trafic],
   c('annee','mois'), variable.name = 'endroit', value.name = 'trafic')
levels(paris.trafic$endroit) <- endroits

paris.sessions <- melt(paris.raw[columns.sessions],
   c('annee','mois'), variable.name = 'endroit', value.name = 'sessions')
levels(paris.sessions$endroit) <- endroits

paris.rapport <- paris.raw[c(
  'annee',
  'mois',
  'nombre_de_minutes_session',
  'nbr_de_go_total',
  'nbr_de_mo_session'
)]
names(paris.rapport)[3:5] <- c('minutes.par.session', 'gigaoctets.total','megaoctets.par.session')

paris <- join(paris.sites.ouverts, join(paris.trafic, paris.sessions))
paris$trafic <- as.numeric(sub(',', '.', gsub(' ', '', paris$trafic)))
paris <- subset(paris, endroit != 'total')
paris$endroit <- factor(paris$endroit, levels = unique(paris$endroit))

eda <- function() {
  plot(sessions ~ endroit, data = paris)
  plot(sessions ~ trafic, data = paris)
  plot(sessions ~ trafic + endroit, data = paris)
}

paris.molten <- melt(na.omit(paris), c('annee', 'mois','endroit'),c('trafic','sites.ouverts','sessions'))

Sys.setlocale('LC_TIME', 'fr_FR.UTF-8')
paris.molten$date <- strptime(paste(paris.molten$annee, paris.molten$mois, '1'), '%Y %B %d')
paris.molten$annee <- NULL
paris.molten$mois <- NULL

p1 <- ggplot(paris.molten) + aes(x = date, y = value, group = variable, color = variable) +
  geom_line() + facet_wrap(~endroit) + scale_y_log10('', labels = comma)

p2 <- ggplot(paris) + aes(x = sessions, y = trafic, label = annee) +
  geom_point() + facet_wrap(~endroit) + scale_y_log10('Trafic (en minutes)', labels = comma) +
  scale_x_log10('Nombre de sessions', labels = comma) + geom_text()

m2 <- lm(log10(trafic) ~  endroit + log10(sessions), data = paris)

p3 <- ggplot(subset(paris, annee != 2013)) + aes(x = sessions, y = trafic, label = annee, color = endroit) +
  geom_point() + scale_y_log10('Trafic (en minutes)', labels = comma) +
  scale_x_log10('Nombre de sessions', labels = comma)

m3 <- lm(log10(trafic) ~  endroit + log10(sessions), data = subset(paris, annee != 2013))

p4 <- ggplot(subset(paris.molten, date < as.POSIXct('2013-01-01'))) +
  aes(x = date, y = value, group = variable, color = variable) +
  geom_line() + facet_wrap(~endroit) + scale_y_log10('', labels = comma)

m5 <- lm(log10(trafic) ~ log10(sessions), data = subset(paris, annee != 2013 & endroit == 'bibliotheques'))
p5 <- ggplot(subset(paris, annee != 2013 & endroit == 'bibliotheques')) +
  aes(x = sessions, y = trafic, label = annee) +
  geom_point() + scale_y_log10('Trafic (en minutes)', labels = comma) +
  scale_x_log10('Nombre de sessions', labels = comma)

p5.base <- function() {
  plot(log10(trafic) ~ log10(sessions), data = subset(paris, annee != 2013 & endroit == 'bibliotheques'),
    main = 'Utilisation du wifi publique de Paris',
    xlab = 'Nombre de sessions',
    ylab = 'Trafic (en minutes)',
    axes = FALSE
  )
  .x <- c(1e3, 3e3, 1e4, 3e4)
  .y <- c(1e5, 3e5, 1e6)
  axis(1, at = log10(.x), labels = .x)
  axis(2, at = log10(.y), labels = c('100000', '500000', '1 million'))
  abline(m5, lty = 2)
}
