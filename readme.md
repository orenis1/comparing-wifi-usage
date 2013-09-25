## Detecting related datasets




Paris open data: wifi and coffee.


I flipped through a few pages of OpenPrism and came up with these
datasets of public wifi usage.

* https://data.ny.gov/Social-Services/Public-Pay-Telephone-Wifi-Metrics/2zez-gixy?
* http://parisdata.opendatasoft.com/explore/dataset/utilisations_mensuelles_des_hotspots_paris_wi-fi/
* https://www.metrochicagodata.org/Education/Libraries-WiFi-Usage/vbts-zqt4?

A bit of searching through files I'd
[downloaded from Socrata]()
got me to datasets of library internet usage.[^search1]

* https://data.hawaii.gov/d/e85y-zk7s 
* https://data.austintexas.gov/d/xcd2-xf2f

And searching through files I'd
[downloaded from CKAN]()
got me to   .[^search2]

* http://www.opendata.provincia.roma.it/dataset/provinciawifi

I figured that they would contain some of the same information.
I looked through all of them and determined that they contained
monthly data on the number of internet sessions.

Some interesting parts of that process were:

* check the titles to determine that they concerned wifi
* translate french to english
* look for the word "session" in the column names
* aggregate the new york dataset by month (it started as hotspot rows)
* determine whether the dataset is about "wifi" or "internet"
* determine whether the dataset concerns more than libraries

[^search1]: In case you're curious, the search command looked like this.
    `datasets[grepl('(internet|wifi)', datasets$name, ignore.case = T),c('portal', 'id', 'name')]`
[^search2]: In case you're curious, I did things like
    `grep -lir '\(wifi\|internet\)' portals/ckan` and
    `find portals/ckan -name *wifi*`.
