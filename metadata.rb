name             'drupal'
maintainer       'Indiana University, FutureGrid Project'
maintainer_email 'kj.tanaka@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures drupal'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'mysql'
depends 'database'
depends 'iptables'
depends 'selinux'
