# systemMetrics

Data Base name: metrics

Table name: servers

Table structure:

NAME id	TYPE int(11)

NAME name TYPE varchar(254)	

NAME ram TYPE	int(11)

NAMEssd TYPE	int(11)

NAME hdd TYPE	int(11)

NAME cpu TYPE	int(11)

NAMEupload TYPE	int(11)

NAME download	TYPE int(11)

NAME status	TYPE varchar(254)

NAME date	TYPE time

Install SPEEDTEST:

curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.rpm.sh | sudo bash

yum install speedtest -y
