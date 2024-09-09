sudo apt update
sudo apt install openjdk-17-jdk
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
tar -xvf latest-unix.tar.gz

sudo mv sonatype-work/ /opt/sonatype-work/ 
sudo mv nexus-3.72.0-04/ /opt/nexus

sudo useradd nexus
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work

sudo vi /opt/nexus/bin/nexus.rc

run_as_user="nexus"

sudo /opt/nexus/bin/nexus start
