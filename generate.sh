#!/bin/bash

#temporary folder for text files
COUNTRIES="countries"

#name of the zip file
COUNTRIES_ZIP="${COUNTRIES}.zip"

#name of the output folder
SUBNETS="subnets"

#YOUR MAXMIND LICENSE KEY
YOUR_LICENSE_KEY="<insert here>"

wget -q -O $COUNTRIES_ZIP "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country-CSV&license_key=$YOUR_LICENSE_KEY&suffix=zip"
unzip -qq -o $COUNTRIES_ZIP

cp -r GeoLite2-Country-CSV_* $COUNTRIES
rm -rf GeoLite2-Country-CSV_*

mkdir -p $SUBNETS
rm $SUBNETS/*.txt

IFS=","
while read geoname_id locale_code continent_code continent_name country_iso_code country_name is_in_european union
do
    if [ ! "$country_iso_code" ]; then
        continue
    fi

    if [ "$country_iso_code" = 'country_iso_code' ]; then
        continue
    fi

    for data in $(cat $COUNTRIES/GeoLite2-Country-Blocks-IPv4.csv | grep $geoname_id | awk -F',' '{print $1}')
    do
        echo "$data" >> "${SUBNETS}/${country_iso_code}.txt"
    done

    for data in $(cat $COUNTRIES/GeoLite2-Country-Blocks-IPv6.csv | grep $geoname_id | awk -F',' '{print $1}')
    do
        echo "$data" >> "${SUBNETS}/${country_iso_code}.txt"
    done


done < $COUNTRIES/GeoLite2-Country-Locations-en.csv

rm $COUNTRIES_ZIP
rm -rf $COUNTRIES

exit 0
