#! /bin/bash

#Data

connect="mysql -u LOGIN -pPASSWORD -h IP_ADDRESS DATABASE"
id=ID_IN_DB
name="SERVER_NAME"
ssddisk="/dev/mapper/centos-root"
hdddisk="/dev/sdb1"
date=$(date +"%H:%M:%S")

#ScanMetrics

checkRamUnits=$(free -h | grep Mem | awk '{print $7}' | grep G | wc -l)
if [[ $checkRamUnits == 1 ]]; then ram=$(free -h | grep Mem | awk '{ print $7 }' | sed 's/G//g' | sed -r 's/\..+//'); fi
if [[ $checkRamUnits == 0 ]]; then ram=$(free -h | grep Mem | awk '{ print $7 }' | sed 's/M//g'); fi

checkSsdUnits=$(df -h | grep $ssddisk | awk '{ print $4 }' | grep G | wc -l )
if [[ $checkSsdUnits == 1 ]]; then ssd=$(df -h | grep $ssddisk | awk '{ print $4 }' | sed 's/G//g' | sed -r 's/\..+//'); fi
if [[ $checkSsdUnits == 0 ]]; then ssd=$(df -h | grep $ssddisk | awk '{ print $4 }' | sed 's/M//g'); fi

checkHddUnits=$(df -h | grep $hdddisk | awk '{ print $4 }' | grep G | wc -l)
if [[ $checkHddUnits == 1 ]]; then hdd=$(df -h | grep $hdddisk | awk '{ print $4 }' | sed 's/G//g' | sed -r 's/\..+//'); fi
if [[ $checkHddUnits == 0 ]]; then hdd=$(df -h | grep $hdddisk | awk '{ print $4 }' | sed 's/M//g'); fi

freecpu=$(top -n 1 | grep %Cpu | awk '{ print $8 }' | sed -r 's/\..+//')
cpu=$(( 100 - $freecpu ))

upload=$(speedtest | grep Upload | awk '{ print $3 }' | sed -r 's/\..+//')

download=$(speedtest | grep Download | awk '{ print $3 }' | sed -r 's/\..+//')

#DataProcessing

if [[ $checkRamUnits == 0 ]]; then ramStatus="low memory"; fi
if [[ $checkSsdUnits == 0 ]];then ssdStatus="low ssd"; fi
if [[ $checkHddUnits == 0 ]]; then hddStatus="low hdd"; fi
if [[ $cpu > 89 ]]; then cpuStatus="hight CPU"; fi
if [[ upload < 20 ]]; then uploadStatus="low upload speed"; fi
if [[ $download < 20 ]]; then downloadStatus="low download speed"; fi

status=$ramStatus" "$ssdStatus" "$hddStatus" "$cpuStatus" "$uploadStatus" "$downloadStatus
checkStatus=$( echo $status | wc -m)
if [[ $checkStatus < 10 ]]; then status="OK"; fi

#Query in DB

echo "UPDATE servers SET ram = $ram, ssd = $ssd, hdd = $hdd, cpu = $cpu, upload = $upload, download = $download, status = '$status', date = '$date'  WHERE servers.id = 2 AND servers.name='acc'" | $connect


#View in console
echo $ram
echo $ssd
echo $hdd
echo $cpu
echo $upload
echo $download
echo $status

# Log journal

date >> /script/metrics.log
