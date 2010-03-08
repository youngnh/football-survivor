#!/bin/bash

for file in `ls week*-schedule.txt`
do 
# set schedule to right week
weeknum=${file#week}
week=${weeknum%%-schedule.txt}
sed -r "s/\( [0-9][0-9]?/( $week/" schedule.sed > tmp
sed -r -f tmp $file > ${file%%.txt}.el
done
cat `ls week*-schedule.el` > nfl-schedule.el