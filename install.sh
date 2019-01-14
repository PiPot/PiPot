#!/bin/bash
#
# Installer for the PiPot honeypot project.
# More information can be found on: https://github.com/PiPot/PiPot
#
dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
clear
date=`date +%Y-%m-%d`
install_log="${dir}/PiPotInstall_${date}_log.txt"
echo "Welcome to the PiPot installer!"
echo ""
echo "Detailed information will be written to $install_log"
echo ""
echo "-------------------------------"
echo "|   Installing dependencies   |"
echo "-------------------------------"
echo ""
echo "* Updating package list        "
apt-get update >> "$install_log" 2>&1
echo "* Installing nginx, python & pip      "
apt-get -q -y install dnsutils nginx python python-dev python-pip >> "$install_log" 2>&1
if [ ! -f /etc/init.d/mysql* ]; then
    echo "* Installing MySQL (root password will be empty!)"
    DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server >> "$install_log" 2>&1
fi
echo "* Update setuptools            "
easy_install -U setuptools >> "$install_log" 2>&1
echo "* Installing pip dependencies"
pip install twisted pyopenssl sqlalchemy flask passlib pymysql service_identity pycrypto flask-wtf netifaces gunicorn >> "$install_log" 2>&1
echo ""
echo "-------------------------------"
echo "|   Configuration of PiPot    |"
echo "-------------------------------"
echo ""
echo "In order to configure PiPot, we need some information from you. Please reply to the next questions:"
echo ""
read -e -p "Password of the 'root' user of MySQL: " -i "" db_root_password
# Verify password
while ! sudo mysql -u root --password="${db_root_password}"  -e ";" ; do
       read -e -p "Invalid password, please retry: " -i "" db_root_password
done
read -e -p "Database name for storing data: " -i "pipot" db_name
sudo mysql -u root --password="${db_root_password}" -e "CREATE DATABASE IF NOt EXISTS ${db_name};" >> "$install_log" 2>&1
# Check if DB exists
db_exists=`mysql --login-path=root_login -se"USE ${db_name};" 2>&1`
if [ ! "${db_exists}" == "" ]; then
    echo "Failed to create the database! Please check the installation log!"
    exit -1
fi
read -e -p "Username to connect to ${db_name}: " -i "pipot" db_user
# Check if user exists
db_user_exists=`mysql --login-path=root_login -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '${db_user}')"`
db_user_password=""
if [ ${db_user_exists} = 0 ]; then
    rand_pass=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
    read -e -p "Password for ${db_user} (will be created): " -i "${rand_pass}" db_user_password
    # Attempt to create the user
    mysql --login-path=root_login -e "CREATE USER '${db_user}'@'localhost' IDENTIFIED BY '${db_user_password}';" >> "$install_log"
    db_user_exists=`mysql --login-path=root_login -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '$db_user')"`
    if [ ${db_user_exists} = 0 ]; then
        echo "Failed to create the user! Please check the installation log!"
        exit -1
    fi
else
    read -e -p "Password for ${db_user}: " db_user_password
    # Check if we have access
    while ! mysql --login-path=check_login -e ";" ; do
       read -e -p "Invalid password, please retry: " -i "" db_user_password
    done
fi
# Grant user access to database
mysql --login-path=root_login -e "GRANT ALL ON ${db_name}.* TO '${db_user}'@localhost;" >> "$install_log" 2>&1
# Check if user has access
db_access=`mysql --login-path=user_login -se "USE ${db_name};" 2>&1`
if [ ! "${db_access}" == "" ]; then
    echo "Failed to grant user access to database! Please check the installation log!"
    exit -1
fi
# Request information for generating the config.py file
server_ip=`dig +short myip.opendns.com @resolver1.opendns.com`
read -e -p "Server IP: " -i "${server_ip}" config_server_ip
read -e -p "Server interface (SSL): " -i "443" config_server_port
read -e -p "Application root (if not a whole (sub)domain, enter the path. None if whole (sub)domain): " -i "None" config_application_root
read -e -p "Instance name: " -i "PiPot Command & Control" config_instance_name
read -e -p "Path to SSL certificate: " -i "/usr/src/pipot/server/cert/pipot.crt" config_ssl_cert
read -e -p "Path to SSL key: " -i "/usr/src/pipot/server/cert/pipot.key" config_ssl_key
read -e -p "Port for SSL Collector to listen on: " -i "1235" config_collector_ssl
read -e -p "Port for UDP Collector to listen on: " -i "1234" config_collector_udp
config_db_uri="mysql+pymysql://${db_user}:${db_user_password}@localhost:3306/${db_name}"
# Request info for creating admin account
echo ""
echo "We need some information for the admin account"
read -e -p "Admin username: " -i "admin" admin_name
read -e -p "Admin email: " admin_email
read -e -p "Admin password: " admin_password
echo "Creating admin account: "
python "${dir}/init_db.py" "${config_db_uri}" "${admin_name}" "${admin_email}" "${admin_password}"
echo ""
echo "-------------------------------"
echo "| Finalizing install of PiPot |"
echo "-------------------------------"
echo ""
echo "* Generating secret keys"
# Write two secret keys (1 for session, 1 for CSRF)
head -c 24 /dev/urandom > "${dir}/../secret_key"
head -c 24 /dev/urandom > "${dir}/../secret_csrf"
# Write config file
echo "* Generating config file"
echo "# Auto-generated configuration by install.sh
SERVER_IP = '${config_server_ip}'
SERVER_PORT = ${config_server_port}
INSTANCE_NAME = '${config_instance_name}'
APPLICATION_ROOT = ${config_application_root}
CSRF_ENABLED = True
DATABASE_URI = '${config_db_uri}'
COLLECTOR_UDP_PORT = ${config_collector_udp}
COLLECTOR_SSL_PORT = ${config_collector_ssl}
" > "${dir}/../config.py"
echo "* Making necessary scripts executable (if they aren't already)"
chmod +x "${dir}/../bin/pipotd" "${dir}/../bin/create_image.sh" "${dir}/../../client/bin/chroot.sh" >> "$install_log" 2>&1
echo "* Creating startup script"
cp "${dir}/pipot" /etc/init.d/pipot >> "$install_log" 2>&1
chmod 755 /etc/init.d/pipot >> "$install_log" 2>&1
update-rc.d pipot defaults >> "$install_log" 2>&1
echo "* Creating Nginx config"
cp "${dir}/nginx.conf" /etc/nginx/sites-available/pipot >> "$install_log" 2>&1
sed -i "s/NGINX_PORT/${config_server_port}/g" /etc/nginx/sites-available/pipot >> "$install_log" 2>&1
sed -i "s/NGINX_HOST/${config_server_ip}/g" /etc/nginx/sites-available/pipot >> "$install_log" 2>&1
sed -i "s#NGINX_CERT#${config_ssl_cert}#g" /etc/nginx/sites-available/pipot >> "$install_log" 2>&1
sed -i "s#NGINX_KEY#${config_ssl_key}#g" /etc/nginx/sites-available/pipot >> "$install_log" 2>&1
ln -s /etc/nginx/sites-available/pipot /etc/nginx/sites-enabled/pipot >> "$install_log" 2>&1
echo "* Reloading nginx"
service nginx reload >> "$install_log" 2>&1
echo "* Downloading base image"
wget https://sourceforge.net/projects/minibian/files/2016-03-12-jessie-minibian.tar.gz >> "$install_log" 2>&1
tar -xvf 2016-03-12-jessie-minibian.tar.gz >> "$install_log" 2>&1
rm 2016-03-12-jessie-minibian.tar.gz >> "$install_log" 2>&1
mv 2016-03-12-jessie-minibian.img "${dir}/../honeypot_images/base.img" >> "$install_log" 2>&1
echo ""
echo "* Starting PiPot..."
service pipot start
echo "PiPot installed!"
