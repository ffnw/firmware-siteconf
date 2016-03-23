#!/bin/sh

rm /var/www/html/nightly/* 
cp output/images/factory/* /var/www/html/nightly/
cp output/images/sysupgrade/* /var/www/html/nightly/