# Initialize databases
cd /home
service mysql start
mysql -u root -Bse "CREATE DATABASE hg19;
CREATE DATABASE mm10;
CREATE DATABASE sacCer3;
CREATE DATABASE hg38;
CREATE USER 'eguser'@'localhost' IDENTIFIED BY 'eguser';
GRANT ALL ON *.* TO 'eguser'@'localhost' IDENTIFIED BY 'eguser' WITH GRANT OPTION;
FLUSH PRIVILEGES;"

cd eg/config
mysql -u eguser -p"eguser" hg19 < sessionUtils.sql
mysql -u eguser -p"eguser" hg38 < sessionUtils.sql
mysql -u eguser -p"eguser" mm10 < sessionUtils.sql
mysql -u eguser -p"eguser" sacCer3 < sessionUtils.sql

cd hg19
mysql -u eguser -p"eguser" hg19 < makeDb.sql
cd ../hg38
mysql -u eguser -p"eguser" hg38 < makeDb.sql
cd ../mm10
mysql -u eguser -p"eguser" mm10 < makeDb.sql
cd ../sacCer3
mysql -u eguser -p"eguser" sacCer3 < makeDb.sql

cd /home/
git clone https://github.com/epgg/load.git
cd load/hg19
mysql -u eguser -p"eguser" hg19 < load.sql
cd ../hg38
mysql -u eguser -p"eguser" hg38 < load.sql
cd ../mm10
mysql -u eguser -p"eguser" mm10 < load.sql
cd ../sacCer3
mysql -u eguser -p"eguser" sacCer3 < load.sql

service mysql stop

#Enable embedding
echo '<Location /cgi-bin>' >> /etc/apache2/apache2.conf
echo 'Header set Access-Control-Allow-Origin "*"' >> /etc/apache2/apache2.conf
echo '</Location>' >> /etc/apache2/apache2.conf