#!/bin/bash

currentYear=$(date +%Y)
weekNumber=$(date +%V) # ISO Standard week number

dayOfMonth=$(date -u +%-d)

# this prevents from having 1801 at the last week of the year 2019. It should be 1901.
if [ ${weekNumber} -eq 1 ] && [ ${dayOfMonth} -gt 24 ]; then
  currentYear=$((currentYear + 1))
fi 

# this prevents from having 1053 at the last week of the year 2010. It should be 0953.
if [ ${weekNumber} -ge 52 ] && [ ${dayOfMonth} -le 7 ]; then
  currentYear=$((currentYear - 1))
fi

# Get the branch names from the remote references, filter for release/ branches and sort
latest=`git ls-remote --refs origin | awk -F 'refs/heads/' '{print $2}' | grep '^release/' | sort -V | tail -1`

latestYearweek=`echo $latest | cut -d. -f2`
latestBuild=`echo $latest | cut -d. -f3`

head=$(cat ./package.json | grep -m 1 headVersion | sed 's/[^0-9.]//g')
yearweek="${currentYear:2:2}${weekNumber}"
build="0"
if [ -n "$latestBuild" ] && [ "$yearweek" == "$latestYearweek" ]; then
  build=$(($latestBuild + 1))
fi

echo $version
