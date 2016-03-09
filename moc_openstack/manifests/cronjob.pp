class moc_openstack::cronjob (
  $base_dir  = '/etc/yum.repos.d/',
  $repo_server = '127.0.0.1',
) {

  if $::environment == 'production' {
    $rhel7_file_path = "${base_dir}rhel7local-prod.repo"
    $epel_file_path = "${base_dir}epel7local-prod.repo"
    $suricata_file_path = "${base_dir}suricata7local-prod.repo"
    $rhel7_link = "http://${repo_server}/repos/rhel7local-prod.repo"
    $epel_link = "http://${repo_server}/repos/epel7local-prod.repo"
    $suricata_link = "http://${repo_server}/repos/suricata7local-prod.repo"
  } else {
    $rhel7_file_path = "${base_dir}rhel7local.repo"
    $epel_file_path = "${base_dir}epel7local.repo"
    $suricata_file_path = "${base_dir}suricaa7local.repo"
    $rhel7_link = "http://${repo_server}/repos/rhel7local.repo"
    $epel_link = "http://${repo_server}/repos/epel7local.repo"
    $suricata_link = "http://${repo_server}/repos/suricata7local.repo"
  }

  exec {'backup_redhat_repo':
    command => "/bin/cp /etc/yum.repos.d/redhat.repo /etc/yum.repos.d/redhat.repo.default",
  } ->
  exec {'disable_redhat_repos':
    command => "/bin/sed -i '/enabled/c\enabled = 0 ' /etc/yum.repos.d/redhat.repo",
  } ->
  exec {'disable_epel_repos':
    command => "/bin/sed -i '/enabled/c\enabled = 0 ' /etc/yum.repos.d/epel*.repo",
  } ->
  file {$rhel7_file_path:
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => $rhel7_link,
    replace => true,
  } ->
  file {$epel_file_path:
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => $epel_link,
    replace => true,
  } ->
  file {$suricata_file_path:
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => $suricata_link,
    replace => true,
  }

  class { 'yum_cron':
    enable           => true,
    download_updates => true,
    apply_updates    => true,
  }

}
