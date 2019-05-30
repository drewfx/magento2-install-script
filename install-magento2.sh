#!/bin/sh

# Gracefull Exit
set -e

# Local Vars
dir=$PWD
approot=magento2

echo 'Starting Magento 2 Installation'

# Download Projectso
sudo composer create-project --repository=https://repo.magento.com/ magento/project-community-edition $approot
wait

# Permissions To Deploy
echo 'Settings Permissions'
sudo chown -R www-data:www-data $approot

echo "Changing Directory: $approot"
cd "$approot"

echo "In $PWD"

echo 'Settings Permissions for Deployment Folders'
sudo chmod -R g+w {var,vendor,generated,pub/static,pub/media,app/etc}
sudo chmod u+x bin/magento
wait

# Configure Application & Install
echo 'Install Magento2'
php bin/magento setup:install --db-user=app --db-password=secret --base-url=http://m2local.com --backend-frontname=admin --admin-firstname=Drew --admin-lastname=Ruppel --admin-email=druppel@goldencomm.com --admin-user=druppel@goldencomm.com --admin-password=secret11 --language=en_US --currency=USD --use-rewrites=1 --use-sample-data
wait

# Deploy DI Compilation
echo 'Compile DI Files'
php bin/magento setup:di:compile
wait

# Deploy Frontend Assets
echo 'Deploy Static Content'
php bin/magento setup:static-content:deploy -f
wait

# Final Permissions
sudo chown -R www-data:www-data ./
wait

echo 'Magento 2 Installation Complete'
