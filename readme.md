[One day](https://twitter.com/thomaslevine/status/377805863131426816),
I discovered datasets about
[wifi](http://parisdata.opendatasoft.com/explore/dataset/utilisations_mensuelles_des_hotspots_paris_wi-fi/)
and [cheap coffee](http://parisdata.opendatasoft.com/explore/dataset/liste-des-cafes-a-un-euro/)
on [Paris's open data portal](http://parisdata.opendatasoft.com/).
I guess they like their cafes.

Or do they? Maybe everyone has datasets about wifi and coffee.
Let's find out. And to keep things simple, let's just start with wifi.
I want to find out **which portals have data about wifi locations and usage**
and then to **connect these datasets to each other** in a meaningful way.

This article explains how I went about that. I see this endeavour as
a prototype of some [grand plans]()
to automate the discovery and linking of related datasets, but you can
also see this as a tutorial on connecting open data from different portals
in R.

## Finding related datasets
I tried to find all the datasets about wifi locations and usage.
I just did some simple text searches.

I flipped through a few pages of [OpenPrism]()
and came up with these datasets of public wifi usage.

* https://data.ny.gov/Social-Services/Public-Pay-Telephone-Wifi-Metrics/2zez-gixy?
* http://parisdata.opendatasoft.com/explore/dataset/utilisations_mensuelles_des_hotspots_paris_wi-fi/
* https://www.metrochicagodata.org/Education/Libraries-WiFi-Usage/vbts-zqt4?

A bit of searching[^search1] through files I'd
[downloaded from Socrata]()
got me to datasets of library internet usage.

* https://data.hawaii.gov/d/e85y-zk7s 
* https://data.austintexas.gov/d/xcd2-xf2f

And searching[^search2] through files I'd
[downloaded from CKAN]()
got me to mostly broken links but also to some lists of
wifi access points without usage.

* Rome [ProvinciaWIFI](http://www.opendata.provincia.roma.it/dataset/provinciawifi)
* New York City [Wifi Hotspot Locations](https://data.cityofnewyork.us/Recreation/Wifi-Hotspot-Locations/ehc4-fktp?)
* Greek public wifi ([Δημόσια Σημεία Πρόσβασης WiFi](http://geodata.gov.gr/geodata/index.php?option=com_sobi2&sobi2Task=sobi2Details&catid=17&sobi2Id=98&Itemid=10))

I eventually added "hotspot" to my search and found
[Bronx Wi Fi Hotspot Locations](https://bronx.lehman.cuny.edu/d/m2pz-m9hq).

I figured that they would contain some of the same information.
I looked through all of them and determined that they contained
monthly data on the number of internet sessions.

Some interesting parts of that process were:

* check the titles to determine that they concerned wifi
* follow links to the real dataset, and sometimes give up because the link was bad
* translate to english from other languages
* look for the word "session" in the column names
* aggregate the new york dataset by month (it started as hotspot rows)
* determine whether the dataset is about "wifi" or "internet"
* determine whether the dataset concerns more than libraries

## Conclusions

### 1. OpenPrism is pretty good.
Even though OpenPrism is a pretty stupid text search, it got me to the best of the
datasets. If you're looking for open data of a particular kind and don't want to
download all of the Socrata and CKAN data,[^download] just search OpenPrism;
it seems to do pretty well.

To be fair, I was still doing a rather simple text search on my downloads of data
portal data, and [I know better](http://thomaslevine.com/!/openprism/#naive-search-method)
than that, but I was still using more power in my searching than is available in
OpenPrism.

## Footnotes

[^search1]: In case you're curious, the search command looked like this.
    `datasets[grepl('(internet|wifi)', datasets$name, ignore.case = T),c('portal', 'id', 'name')]`
[^search2]: In case you're curious, I did things like
    `grep -lir '\(wifi\|internet\)' portals/ckan` and
    `find . -name *wifi*|sed -e 's+^..++' | sed -e 's+/+/dataset/+' -e 's+^+http://+'`
[^download]: I can send them to you, but that still takes a while.
