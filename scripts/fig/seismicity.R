
library(glue)
library(data.table)
root <- here::here()

if (file.exists(file.path(root, "mapper/byEvent/epicenters.csv"))) {

  EVENTS <- data.table::fread(file.path(root, "mapper/byEvent/epicenters.csv"))
  EVENTS <- EVENTS[Repi <= 1000, .(
    Location = place,
    Mw = mag,
    Date = as.Date(time),
    Lat = latitude,
    Lon = longitude,
    Rhyp = round(sqrt(Repi^2 + depth^2), 0)
  )]
  EVENTS <- EVENTS[!is.na(Date) & nchar(Location) > 0]

  MCE.Mw <- EVENTS[order(-Mw, Date)][1]
  MCE.Rhyp <- EVENTS[Mw >= 4.5][order(Rhyp, Date)][1]

  key.Mw <- paste(MCE.Mw$Date, MCE.Mw$Lat, MCE.Mw$Lon, MCE.Mw$Mw)
  key.Rhyp <- paste(MCE.Rhyp$Date, MCE.Rhyp$Lat, MCE.Rhyp$Lon, MCE.Rhyp$Mw)

  TEXT <- ""
  if (key.Mw == key.Rhyp) {
    TEXT <- glue(
      "According to the USGS instrumental earthquake catalog, the **largest and closest ",
      "significant event** ($M_w \\geq 4.5$) within a 1,000 km radius of the site was the ",
      "earthquake at {MCE.Mw$Location} on {format(MCE.Mw$Date, '%B, %Y')}, with a moment ",
      "magnitude of $M_w$ {MCE.Mw$Mw} and a hypocentral distance of {MCE.Mw$Rhyp} km from the site."
    )
  } else {
    TEXT <- glue(
      "According to the USGS instrumental earthquake catalog, the **largest recorded event** ",
      "within a 1,000 km radius of the site occurred at {MCE.Mw$Location} on ",
      "{format(MCE.Mw$Date, '%B, %Y')}, with a moment magnitude of $M_w$ {MCE.Mw$Mw} and a ",
      "hypocentral distance of {MCE.Mw$Rhyp} km from the site. The **closest significant event** ",
      "($M_w \\geq 4.5$) was recorded at {MCE.Rhyp$Location} on ",
      "{format(MCE.Rhyp$Date, '%B, %Y')}, with $M_w$ {MCE.Rhyp$Mw} at a hypocentral distance ",
      "of {MCE.Rhyp$Rhyp} km."
    )
  }

} else TEXT <- ""
