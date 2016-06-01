# == Class: quickstack::compute_common
#
# A base class to configure compute nodes
#
# === Parameters
# [*nova_host*]
#   The private network ip for the controller, or nova VIP, if HA.
# [*vncproxy_host*]
#   The ip or hostname to use for constructing the VNC console base URL.
#   Typically the public network ip or hostname for the controller, or nova VIP, if HA.
#   Defaults to the value of nova_host if unset.

class quickstack::compute_common (
  $amqp_host                    = $quickstack::params::amqp_host,
  $amqp_password                = $quickstack::params::amqp_password,
  $amqp_port                    = '5672',
  $amqp_provider                = $quickstack::params::amqp_provider,
  $amqp_username                = $quickstack::params::amqp_username,
  $amqp_ssl_port                = '5671',
  $auth_host                    = $quickstack::params::controller_pub_host,
  $ceilometer                   = 'false',
  $ceilometer_metering_secret   = $quickstack::params::ceilometer_metering_secret,
  $ceilometer_user_password     = $quickstack::params::ceilometer_user_password,
  $manage_ceph_conf             = false,
  $ceph_cluster_network         = '',
  $ceph_public_network          = '',
  $ceph_fsid                    = '',
  $ceph_images_key              = '',
  $ceph_volumes_key             = '',
  $ceph_rgw_key                 = '',
  $ceph_mon_host                = [ ],
  $ceph_mon_initial_members     = [ ],
  $ceph_conf_include_osd_global = true,
  $ceph_osd_pool_size           = '',
  $ceph_osd_journal_size        = '',
  $ceph_osd_mkfs_options_xfs    = '-f -i size=2048 -n size=64k',
  $ceph_osd_mount_options_xfs   = 'inode64,noatime,logbsize=256k',
  $ceph_conf_include_rgw        = false,
  $ceph_rgw_hostnames           = [ ],
  $ceph_extra_conf_lines        = [ ],
  $cinder_backend_gluster       = $quickstack::params::cinder_backend_gluster,
  $cinder_backend_nfs           = 'false',
  $cinder_backend_rbd           = 'false',
  $cinder_catalog_info          = 'volume:cinder:internalURL',
  $glance_host                  = $quickstack::params::controller_pub_host,
  $glance_backend_rbd           = 'true',
  $libvirt_images_rbd_pool      = $quickstack::params::libvirt_rbd_pool,
  $libvirt_images_rbd_ceph_conf = '/etc/ceph/ceph.conf',
  $libvirt_inject_password      = 'false',
  $libvirt_inject_key           = 'false',
  $libvirt_images_type          = 'rbd',
  $mysql_ca                     = $quickstack::params::mysql_ca,
  $mysql_host                   = $quickstack::params::mysql_host,
  $nova_host                    = $quickstack::params::controller_pub_host,
  $nova_db_password             = $quickstack::params::nova_db_password,
  $nova_user_password           = $quickstack::params::nova_user_password,
  $private_network              = '',
  $private_iface                = '',
  $private_ip                   = '',
  $rabbit_hosts                 = undef,
  $rbd_user                     = $quickstack::params::cinder_rbd_user,
  $rbd_secret_uuid              = $quickstack::params::cinder_rbd_secret_uuid,
  $network_device_mtu           = $quickstack::params::network_device_mtu,
  $ssl                          = $quickstack::params::ssl,
  $mysql_ssl                    = $quickstack::params::mysql_ssl,
  $amqp_ssl                     = $quickstack::params::amqp_ssl,
  $horizon_ssl                  = $quickstack::params::horizon_ssl,
  $verbose                      = $quickstack::params::verbose,
  $vnc_keymap                   = 'en-us',
  $vncproxy_host                = undef,
  $glance_priv_url              = $quickstack::params::glance_priv_url,
  $use_ssl                      = $quickstack::params::use_ssl_endpoints,
  $enabled_ssl_apis             = ['osapi_compute'],
  $key_file                     = $quickstack::params::nova_key,
  $cert_file                    = $quickstack::params::nova_cert,
  $ca_file                      = $quickstack::params::root_ca_cert,
  $auth_uri                     = $quickstack::params::keystone_pub_url,
  $identity_uri                 = $quickstack::params::keystone_admin_url,
  $neutron                      = $quickstack::params::neutron,
  $ceph_nodes                   = $quickstack::params::ceph_nodes,
  $ceph_enpoints                = $quickstack::params::ceph_endpoints,
  $ceph_user                    = $quickstack::params::ceph_user,
  $nova_uuid                    = $quickstack::params::nova_uuid,
  $rbd_key                      = $quickstack::params::rbd_key,
  $ceph_iface                   = $quickstack::params::ceph_iface,
  $ceph_vlan                    = $quickstack::params::ceph_vlan,
  $sensu_rabbitmq_host          = $quickstack::params::sensu_rabbitmq_host,
  $sensu_rabbitmq_user          = $quickstack::params::sensu_rabbitmq_user,
  $sensu_rabbitmq_password      = $quickstack::params::sensu_rabbitmq_password,
  $sensu_client_subscriptions_compute = 'moc-sensu',
  $sensu_client_keepalive       = { "thresholds" => { "warning" => 60, "critical" => 300 }, "handlers" => ["node-email"], "refresh" => 3600 },
  $public_net                   = $quickstack::params::public_net,
  $private_net                  = $quickstack::params::private_net,
  $ntp_local_servers            = $quickstack::params::ntp_local_servers,
  $elasticsearch_host           = $quickstack::params::elasticsearch_host,
  $backups_user                 = $quickstack::params::backups_user,
  $backups_script_src           = $quickstack::params::backups_script_compute,
  $backups_script_local		    = $quickstack::params::backups_script_local_name,
  $backups_dir                  = $quickstack::params::backups_directory,
  $backups_log                  = $quickstack::params::backups_log,
  $backups_email                = $quickstack::params::backups_email,
  $backups_ssh_key              = $quickstack::params::backups_ssh_key,
  $backups_sudoers_d		    = $quickstack::params::backups_sudoers_d,
  $backups_hour                 = $quickstack::params::backups_local_hour,
  $backups_min                  = $quickstack::params::backups_local_min, 
  $allow_resize_to_same_host    = $quickstack::params::allow_resize,
  $allow_migrate_to_same_host   = $quickstack::params::allow_migrate,
  $repo_server                  = $quickstack::params::repo_server,
) inherits quickstack::params {

  if str2bool_i("$use_ssl") {
    $auth_protocol = 'https'
  } else {
    $auth_protocol = 'http'
  }

  # Create entries in /etc/hosts
  class {'hosts':}

  class {'quickstack::openstack_common': }

  # Temporary fix for glanceclient bug: 1244291
  class {'moc_openstack::ssl::temp_glance_fix':
    require => Package['nova-common'],
  }

  if str2bool_i("$use_ssl") {
    if str2bool_i("$amqp_ssl") {
      $qpid_protocol = 'ssl'
      $real_amqp_port = $amqp_ssl_port
    } else {
      $qpid_protocol = 'tcp'
      $real_amqp_port = $amqp_port
    }

    if str2bool_i("$mysql_ssl") {
      $nova_sql_connection = "mysql://nova:${nova_db_password}@${mysql_host}/nova?ssl_ca=${mysql_ca}"
    } else {
      $nova_sql_connection = "mysql://nova:${nova_db_password}@${mysql_host}/nova"
    }

    class {'moc_openstack::ssl::install_rootca':
      before => Package['nova-common'],
    }
  } else {
    $qpid_protocol = 'tcp'
    $real_amqp_port = $amqp_port
    $nova_sql_connection = "mysql://nova:${nova_db_password}@${mysql_host}/nova"
  }

  if str2bool_i($kvm_capable) {
    $libvirt_type = 'kvm'
  } else {
    include quickstack::compute::qemu
    $libvirt_type = 'qemu'
  }

  if str2bool_i("$cinder_backend_gluster") {
    if defined('gluster::client') {
      class { 'gluster::client': }
    } else {
      include ::puppet::vardir
      class { 'gluster::mount::base': repo => false }
    }


    if ($::selinux != "false") {
      selboolean{'virt_use_fusefs':
          value => on,
          persistent => true,
      }
    }

    nova_config {
      'DEFAULT/qemu_allowed_storage_drivers': value => 'gluster';
    }
  }
  if str2bool_i("$cinder_backend_nfs") {
    package { 'nfs-utils':
      ensure => 'present',
    }

    if ($::selinux != "false") {
      selboolean{'virt_use_nfs':
          value => on,
          persistent => true,
      }
    }
  }

  if (str2bool_i("$cinder_backend_rbd") or str2bool_i("$glance_backend_rbd")) {
    include ::quickstack::ceph::client_packages
    if $ceph_fsid {
      class { '::quickstack::ceph::config':
        manage_ceph_conf        => $manage_ceph_conf,
        fsid                    => $ceph_fsid,
        cluster_network         => $ceph_cluster_network,
        public_network          => $ceph_public_network,
        mon_initial_members     => $ceph_mon_initial_members,
        mon_host                => $ceph_mon_host,
        images_key              => $ceph_images_key,
        volumes_key             => $ceph_volumes_key,
        rgw_key                 => $ceph_rgw_key,
        conf_include_osd_global => $ceph_conf_include_osd_global,
        osd_pool_default_size   => $ceph_osd_pool_size,
        osd_journal_size        => $ceph_osd_journal_size,
        osd_mkfs_options_xfs    => $ceph_osd_mkfs_options_xfs,
        osd_mount_options_xfs   => $ceph_osd_mount_options_xfs,
        conf_include_rgw        => $ceph_conf_include_rgw,
        rgw_hostnames           => $ceph_rgw_hostnames,
        extra_conf_lines        => $ceph_extra_conf_lines,
      } -> Class['quickstack::ceph::client_packages']
    }
    package {'python-rbd': } ->
    Class['quickstack::ceph::client_packages'] -> Package['nova-compute']
  }

  if str2bool_i("$cinder_backend_rbd") {
    nova_config {
      'libvirt/images_rbd_pool':      value => $libvirt_images_rbd_pool;
      'libvirt/images_rbd_ceph_conf': value => $libvirt_images_rbd_ceph_conf;
      'libvirt/images_type':          value => $libvirt_images_type;
      'libvirt/rbd_user':             value => $rbd_user;
      'libvirt/rbd_secret_uuid':      value => $rbd_secret_uuid;
      'libvirt/live_migration_flag':  value => '"VIR_MIGRATE_UNDEFINE_SOURCE,VIR_MIGRATE_PEER2PEER,VIR_MIGRATE_LIVE,VIR_MIGRATE_PERSIST_DEST"';
    }
    class { '::nova::compute::libvirt':
      libvirt_virt_type        => $libvirt_type,
      vncserver_listen         => '0.0.0.0',
      libvirt_inject_key       => $libvirt_inject_key,
      libvirt_inject_partition => -2,
      libvirt_inject_password  => $libvirt_inject_password,
      libvirt_disk_cachemodes  => ['"network=writeback"'],
    }

    Package['nova-common'] ->
    # This defines the cinder secret for libvirt
    class { 'moc_openstack::configure_nova_ceph':
           nova_uuid     => $nova_uuid,
           ceph_key      => $ceph_key,
    }
  } else {
    class { '::nova::compute::libvirt':
      libvirt_virt_type        => $libvirt_type,
      vncserver_listen         => '0.0.0.0',
      libvirt_inject_partition => -1,
    }
  }

  nova_config {
    'DEFAULT/cinder_catalog_info':        value => $cinder_catalog_info;
    'DEFAULT/allow_resize_to_same_host':  value => $allow_resize_to_same_host;
    'DEFAULT/allow_migrate_to_same_host': value => $allow_migrate_to_same_host;
  }

  if $rabbit_hosts {
    nova_config { 'DEFAULT/rabbit_host': ensure => absent }
    nova_config { 'DEFAULT/rabbit_port': ensure => absent }
  }

  class { '::nova':
    #database_connection => $nova_sql_connection,
    image_service       => 'nova.image.glance.GlanceImageService',
    glance_api_servers  => "${glance_priv_url}/v1",
    rpc_backend         => amqp_backend('nova', $amqp_provider),
    qpid_hostname       => $amqp_host,
    qpid_protocol       => $qpid_protocol,
    qpid_port           => $real_amqp_port,
    qpid_username       => $amqp_username,
    qpid_password       => $amqp_password,
    rabbit_host         => $amqp_host,
    rabbit_port         => $real_amqp_port,
    rabbit_userid       => $amqp_username,
    rabbit_password     => $amqp_password,
    rabbit_use_ssl      => $amqp_ssl,
    rabbit_hosts        => $rabbit_hosts,
    verbose             => $verbose,
    controller_pub_host => $controller_pub_host,
    use_ssl             => $use_ssl,
    enabled_ssl_apis    => ['osapi_compute'],
    key_file            => $key_file,
    cert_file           => $cert_file,
    ca_file             => $ca_file,
  }

  $compute_ip = find_ip("$private_network",
                        "$private_iface",
                        "$private_ip")
  class { '::nova::compute':
    enabled                       => true,
    vncproxy_host                 => pick($vncproxy_host, $nova_host),
    vncserver_proxyclient_address => $compute_ip,
    network_device_mtu            => $network_device_mtu,
    vnc_keymap                    => $vnc_keymap,
    auth_protocol                 => $auth_protocol,
    auth_uri                      => $auth_uri,
    identity_uri                  => $identity_uri,
  }

  if str2bool_i("$neutron") {
    class { '::nova::api':
      enabled           => false,
      admin_password    => $nova_user_password,
      auth_host         => $controller_priv_host,
      auth_protocol     => $auth_protocol,
      auth_uri          => $keystone_pub_url,
      identity_uri      => $keystone_admin_url,
      neutron_metadata_proxy_shared_secret => $neutron_metadata_proxy_secret,
    }
  } else {
    class { '::nova::api':
      enabled           => false,
      admin_password    => $nova_user_password,
      auth_host         => $controller_priv_host,
      auth_protocol     => $auth_protocol,
      auth_uri          => $keystone_pub_url,
      identity_uri      => $keystone_admin_url,
    }
  }

  if str2bool_i("$ceilometer") {
    class { 'ceilometer':
      metering_secret => $ceilometer_metering_secret,
      qpid_protocol   => $qpid_protocol,
      qpid_username   => $amqp_username,
      qpid_password   => $amqp_password,
      rabbit_host     => $amqp_host,
      rabbit_hosts    => $rabbit_hosts,
      rabbit_port     => $real_amqp_port,
      rabbit_userid   => $amqp_username,
      rabbit_password => $amqp_password,
      rabbit_use_ssl  => $amqp_ssl,
      rpc_backend     => amqp_backend('ceilometer', $amqp_provider),
      verbose         => $verbose,
    }

    class { 'ceilometer::agent::auth':
      auth_url      => "${auth_protocol}://${auth_host}:35357/v2.0",
      auth_password => $ceilometer_user_password,
    }

    class { 'ceilometer::agent::compute':
      enabled => true,
    }
    Package['openstack-nova-common'] -> Package['ceilometer-common']
  }

  include quickstack::tuned::virtual_host

#  firewall { '000 block vnc access for all except controller':
#    proto  => 'tcp',
#    dport  => '5900-5999',
#    source => "!$controller_private_ip",
#    action => 'drop',
#  }

#Customization for intalling ceph and conf files  
  class { 'moc_openstack::install_ceph':
    ceph_nodes     => $ceph_nodes,
    ceph_endpoints => $ceph_endpoints,
    ceph_user      => $ceph_user,
    ceph_vlan      => $ceph_vlan,
    ceph_key       => $ceph_key,
    ceph_iface     => $ceph_iface,
  }

  class { 'moc_openstack::firewall':
    interface   => $ceph_iface,
    public_net  => $public_net,
    private_net => $private_net,
  }

# Ensure ruby has lastest version
  package { "ruby":
    ensure => latest,
  }

  package { "rubygems":
    ensure => latest,
  }

#Customization for configuring sensu
  class { '::sensu':
    sensu_plugin_name     => 'sensu-plugin',
    sensu_plugin_version  => 'installed',
    sensu_plugin_provider => 'gem',
    purge_config          => true,
    rabbitmq_host         => $sensu_rabbitmq_host,
    rabbitmq_user         => $sensu_rabbitmq_user,
    rabbitmq_password     => $sensu_rabbitmq_password,
    rabbitmq_vhost        => '/sensu',
    subscriptions         => $sensu_client_subscriptions_compute,
    client_keepalive      => $sensu_client_keepalive,
    plugins               => [
       "puppet:///modules/sensu/plugins/check-ip-connectivity.sh",
       "puppet:///modules/sensu/plugins/check-mem.sh",
       "puppet:///modules/sensu/plugins/cpu-metrics.rb",
       "puppet:///modules/sensu/plugins/disk-usage-metrics.rb",
       "puppet:///modules/sensu/plugins/load-metrics.rb",
       "puppet:///modules/sensu/plugins/check-ceph.rb",
       "puppet:///modules/sensu/plugins/check-disk-fail.rb",
       "puppet:///modules/sensu/plugins/memory-metrics.rb",
       "puppet:///modules/sensu/plugins/uptime-metrics.py",
       "puppet:///modules/sensu/plugins/check_keystone-api.sh",
       "puppet:///modules/sensu/plugins/keystone-token-metrics.rb",
       "puppet:///modules/sensu/plugins/nova-hypervisor-metrics.py",
       "puppet:///modules/sensu/plugins/nova-server-state-metrics.py",
       "puppet:///modules/sensu/plugins/cpu-pcnt-usage-metrics.rb",
       "puppet:///modules/sensu/plugins/disk-metrics.rb"
    ]
  }
  
  class {'quickstack::ntp':
    servers => $ntp_local_servers,
  }

  class { 'filebeat':
    outputs => {
      'logstash'  => {
        'hosts'       =>  [$elasticsearch_host],
        'loadbalance' => true
      }
    },
    logging => {
      'level' => "info"
    }
  }

  filebeat::prospector { 'generic':
      paths => ["/var/log/*.log", "/var/log/secure", "/var/log/messages", "/var/log/ceph/*", "/var/log/nova/*", "/var/log/neutron/*", "/var/log/openvswitch/*", "/var/log/cinder/", "/var/log/glance/", "/var/log/horizon/", "/var/log/httpd/", "/var/log/keystone/*"]
  }

  # Installs scripts for automated backups
  class {'backups':
    user           => $backups_user,
    script_src     => $backups_script_src,
    script_local   => $backups_script_local,
    backups_dir    => $backups_dir,
    log_file       => $backups_log,
    ssh_key        => $backups_ssh_key,
    sudoers_d	   => $backups_sudoers_d,
    cron_email     => $backups_email,
    cron_hour      => $backups_hour,
    cron_min       => $backups_min, 
  }

  class {'moc_openstack::cronjob':
    repo_server => $repo_server,
    randomwait => 180,
  }

}
