## Detecting related datasets




Paris open data: wifi and coffee.


I flipped through a few pages of OpenPrism and came up with these

* https://data.ny.gov/Social-Services/Public-Pay-Telephone-Wifi-Metrics/2zez-gixy?
* http://parisdata.opendatasoft.com/explore/dataset/utilisations_mensuelles_des_hotspots_paris_wi-fi/
* https://www.metrochicagodata.org/Education/Libraries-WiFi-Usage/vbts-zqt4?

I figured that they would contain some of the same information.
I looked through all of them and determined that they contained
monthly data on the number of wifi sessions.

Some interesting parts of that process were:

* check the titles to determine that they concerned wifi
* translate french to english
* look for the word "session" in the column names
* aggregate the new york dataset by month (it started as hotspot rows)
