.PHONY: download
download:
	mkdir -p data
	test -e data/chicago.csv || wget -O data/chicago.csv https://www.metrochicagodata.org/api/views/vbts-zqt4/rows.csv?accessType=DOWNLOAD
	test -e data/paris.csv || wget -O data/paris.csv http://parisdata.opendatasoft.com/explore/dataset/utilisations_mensuelles_des_hotspots_paris_wi-fi/download
	test -e data/newyork.csv || wget -O data/newyork.csv https://data.ny.gov/api/views/2zez-gixy/rows.csv?accessType=DOWNLOAD

plot:
	Rscript plot.r
