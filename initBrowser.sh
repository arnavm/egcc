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

# Prepare for hg38
mkdir /srv/epgg/data/data/subtleKnife/hg38
mkdir /srv/epgg/data/data/subtleKnife/hg38/config
mkdir /srv/epgg/data/data/subtleKnife/hg38/session
chown www-data.www-data /srv/epgg/data/data/subtleKnife/hg38/session

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
cp hg38/tracks.json /srv/epgg/data/data/subtleKnife/hg38/config
cp hg38/publichub.json /srv/epgg/data/data/subtleKnife/hg38/config
cp mm10/tracks.json /srv/epgg/data/data/subtleKnife/mm10/config
cp mm10/publichub.json /srv/epgg/data/data/subtleKnife/mm10/config
cp sacCer3/tracks.json /srv/epgg/data/data/subtleKnife/sacCer3/config
cp sacCer3/publichub.json /srv/epgg/data/data/subtleKnife/sacCer3/config
