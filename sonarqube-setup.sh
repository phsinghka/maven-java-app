sudo apt update && sudo apt upgrade -y 
sudo apt install openjdk-17-jdk -y 

wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.6.0.92116.zip

sudo apt install unzip -y 

unzip sonarqube-10.6.0.92116.zip
sudo mv sonarqube-10.6.0.92116 /opt/sonarqube

sudo apt install postgresql postgresql-contrib -y 

sudo -i -u postgres
createuser sonar
createdb sonarqube

psql
ALTER USER sonar WITH ENCRYPTED password 'your_password';
GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
\q

cd /opt/sonarqube/conf/sonar.properties

sonar.jdbc.username=sonar
sonar.jdbc.password=your_password
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
sonar.web.host=0.0.0.0
sonar.web.port=9000

sudo vim /etc/sysctl.conf

vm.max_map_count=262144

