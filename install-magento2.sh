#!/bin/bash

# Functions
printMessage() {
    echo "Permissions set for: $1"
}

# Graceful Exit
set -e

# Local Vars
root=magento2
groupWrite=("var" "vendor" "generated" "pub/static" "pub/media" "app/etc")

echo "Starting Magento 2 Installation"

# Download Project
sudo composer create-project --repository=https://repo.magento.com/ magento/project-community-edition ${root}
wait

# Permissions To Deploy
printMessage ${root}
sudo chown -R www-data:www-data ${root}

echo "Changing Directory: $root"
cd "${root}"

for dir in "${groupWrite[@]}"; do
  sudo chmod -R g+w ${dir}
  printMessage ${dir}
done
sudo chmod u+x bin/magento
echo "Permissions set for: bin/magento"
wait

# Configure Application & Install
echo "Install Magento2"
php bin/magento setup:install --db-user=app --db-password=secret --base-url=http://m2local.com --backend-frontname=admin --admin-firstname=Drew --admin-lastname=Ruppel --admin-email=druppel@goldencomm.com --admin-user=druppel@goldencomm.com --admin-password=secret11 --language=en_US --currency=USD --use-rewrites=1 --use-sample-data
wait

# Deploy DI Compilation
echo "Compile DI Files"
php bin/magento setup:di:compile
wait

# Deploy Frontend Assets
echo "Deploy Static Content"
php bin/magento setup:static-content:deploy -f
wait

# Final Permissions
printMessage ${root}
sudo chown -R www-data:www-data ./
wait

echo "Magento 2 Installation Complete"
