#!/bin/bash
curl -u admin:Anjana http://18.218.195.244:9000/api/qualitygates/project_status?projectKey=Java_app > check.json
scan_status=$(cat check.json | grep -i status | cut -d ":" -f 3 | cut -d "," -f 1 | tr -d '"')
if [[ $scan_status -eq OK ]]
then
  echo "Anjana sonar scan status is $scan_status........!!!"
else
  echo "Anjana Sonar scan status is $scan_status please check ......!"
  exit 1;
fi
