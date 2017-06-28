# Fetch the code
#git clone https://github.com/arnavm/eg.git
cd /home/eg

# Compile cgi-bin programs
cd cgi-bin/jsmn-example
make
cd ../jsmn
make
cd ..
make

# Copy them to the system cgi-bin folder
cp subtleKnife postdeposit /usr/lib/cgi-bin/
# cp script/ucsc/ucsc2jsonhub.py /usr/lib/cgi-bin/
cp query/querybw query/querybb /usr/lib/cgi-bin/

# Make directories
mkdir /srv/epgg
mkdir /srv/epgg/data
cd /srv/epgg/data
mkdir data
cd data/
mkdir subtleKnife
cd subtleKnife
mkdir seq
mkdir /var/www/html/browser

# Prepare for hg19
mkdir /srv/epgg/data/data/subtleKnife/hg19
mkdir /srv/epgg/data/data/subtleKnife/hg19/config
mkdir /srv/epgg/data/data/subtleKnife/hg19/session
chown www-data.www-data /srv/epgg/data/data/subtleKnife/hg19/session

# Prepare for mm10
mkdir /srv/epgg/data/data/subtleKnife/mm10
mkdir /srv/epgg/data/data/subtleKnife/mm10/config
mkdir /srv/epgg/data/data/subtleKnife/mm10/session
chown www-data.www-data /srv/epgg/data/data/subtleKnife/mm10/session

# Prepare for sacCer3
mkdir /srv/epgg/data/data/subtleKnife/sacCer3
mkdir /srv/epgg/data/data/subtleKnife/sacCer3/config
mkdir /srv/epgg/data/data/subtleKnife/sacCer3/session
chown www-data.www-data /srv/epgg/data/data/subtleKnife/sacCer3/session

# Prepare trash directories
mkdir /var/www/html/browser/t
mkdir /srv/epgg/data/trash
chown www-data.www-data /var/www/html/browser/t /srv/epgg/data/trash
ln -s /srv/epgg/data/trash /usr/lib/

# Install browser
cd /home/eg/browser/
cp -r css/ index.html js/ images/ /var/www/html/browser/
cd /home/eg/config/
cp -r treeoflife /srv/epgg/data/data/subtleKnife/
cp hg19/tracks.json /srv/epgg/data/data/subtleKnife/hg19/config
cp hg19/publichub.json /srv/epgg/data/data/subtleKnife/hg19/config
cp mm10/tracks.json /srv/epgg/data/data/subtleKnife/mm10/config
cp mm10/publichub.json /srv/epgg/data/data/subtleKnife/mm10/config
cp sacCer3/tracks.json /srv/epgg/data/data/subtleKnife/sacCer3/config
cp sacCer3/publichub.json /srv/epgg/data/data/subtleKnife/sacCer3/config

# Fetch genome data
cd /srv/epgg/data/data/subtleKnife/hg19
wget http://egg.wustl.edu/d/hg19/refGene.gz
wget http://egg.wustl.edu/d/hg19/refGene.gz.tbi
wget http://egg.wustl.edu/d/hg19/gencodeV17.gz
wget http://egg.wustl.edu/d/hg19/gencodeV17.gz.tbi
wget http://egg.wustl.edu/d/hg19/xenoRefGene.gz
wget http://egg.wustl.edu/d/hg19/xenoRefGene.gz.tbi

cd  /srv/epgg/data/data/subtleKnife/mm10
wget http://egg.wustl.edu/d/mm10/refGene.gz
wget http://egg.wustl.edu/d/mm10/refGene.gz.tbi
#wget http://egg.wustl.edu/d/mm10/gencodeV17.gz
#wget http://egg.wustl.edu/d/mm10/gencodeV17.gz.tbi
wget http://egg.wustl.edu/d/mm10/xenoRefGene.gz
wget http://egg.wustl.edu/d/mm10/xenoRefGene.gz.tbi

cd  /srv/epgg/data/data/subtleKnife/sacCer3
wget http://egg.wustl.edu/d/sacCer3/sgdGene.gz
wget http://egg.wustl.edu/d/sacCer3/sgdGene.gz.tbi
wget http://egg.wustl.edu/d/sacCer3/xenoRefGene.gz
wget http://egg.wustl.edu/d/sacCer3/xenoRefGene.gz.tbi

# Initialize databases
cd /home
service mysql start
mysql -u root -Bse "CREATE DATABASE hg19;
CREATE DATABASE mm10;
CREATE DATABASE sacCer3;
CREATE USER 'eguser'@'localhost' IDENTIFIED BY 'eguser';
GRANT ALL ON *.* TO 'eguser'@'localhost' IDENTIFIED BY 'eguser' WITH GRANT OPTION;
FLUSH PRIVILEGES;"

cd eg/config
mysql -u eguser -p"eguser" hg19 < sessionUtils.sql
mysql -u eguser -p"eguser" mm10 < sessionUtils.sql
mysql -u eguser -p"eguser" sacCer3 < sessionUtils.sql

cd hg19
mysql -u eguser -p"eguser" hg19 < makeDb.sql
cd ../mm10
mysql -u eguser -p"eguser" mm10 < makeDb.sql
cd ../sacCer3
mysql -u eguser -p"eguser" sacCer3 < makeDb.sql

cd /home/
git clone https://github.com/epgg/load.git
cd load/hg19
mysql -u eguser -p"eguser" hg19 < load.sql
cd ../mm10
mysql -u eguser -p"eguser" mm10 < load.sql
cd ../sacCer3
mysql -u eguser -p"eguser" sacCer3 < load.sql

service mysql stop

#Enable embedding
echo '<Location /cgi-bin>' >> /etc/apache2/apache2.conf
echo 'Header set Access-Control-Allow-Origin "*"' >> /etc/apache2/apache2.conf
echo '</Location>' >> /etc/apache2/apache2.conf
