default['drupal']['version'] = "7.28"
#default['drupal']['version'] = "6.31"
default['drupal']['db_root_password'] = "DrupalDBPassw0rd"
default['drupal']['db_name'] = "drupal"
default['drupal']['db_user'] = "drupaladmin"
default['drupal']['db_user_password'] = "DrupalDBPassw0rd"
default['drupal']['backup_name'] = "drupal-backup"
default['drupal']['install_dir'] = "/var/www/html"
default['drupal']['work_dir'] = "/root/drupal_work_dir"

# _https
default['drupal']['ca_key'] = "/etc/pki/tls/private/ca.key"
default['drupal']['ca_csr'] = "/etc/pki/tls/private/ca.csr"
default['drupal']['ca_crt'] = "/etc/pki/tls/certs/ca.crt"
