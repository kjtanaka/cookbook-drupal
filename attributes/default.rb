default['drupal']['version'] = "7.32"
#default['drupal']['version'] = "6.33"
default['drupal']['download_url'] = "http://ftp.drupal.org/files/projects/drupal-#{node['drupal']['version']}.tar.gz"
default['drupal']['db_root_password'] = "DrupalDBPassw0rd"
default['drupal']['db_name'] = "drupal"
default['drupal']['db_user'] = "drupaladmin"
default['drupal']['db_user_password'] = "DrupalDBPassw0rd"
default['drupal']['backup_name'] = "drupal-backup"
default['drupal']['install_dir'] = "/var/www/html"
default['drupal']['work_dir'] = "/root/drupal_work_dir"
default['drupal']['hostname'] = "drupal.example.org"
default['drupal']['packages'] = %w[wget rsync httpd php php-mysql php-mbstring gd php-gd php-xml postfix mailx]

# MySQL config
default['drupal']['mysql_max_allowed_packet'] = "32M"

# _https
default['drupal']['ca_key'] = "/etc/pki/tls/private/ca.key"
default['drupal']['ca_csr'] = "/etc/pki/tls/private/ca.csr"
default['drupal']['ca_crt'] = "/etc/pki/tls/certs/ca.crt"
