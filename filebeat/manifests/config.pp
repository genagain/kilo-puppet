class filebeat::config {
  $filebeat_config = {
    'filebeat'   => {
      'registry_file' => $filebeat::registry_file,
    },
    'prospectors'=> $filebeat::prospectors,
    'output'     => $filebeat::outputs,
    'logging'    => $filebeat::logging,
  }

  case $::kernel {
    'Linux'   : {
      file {'filebeat.yml':
        ensure  => file,
        path    => '/etc/filebeat/filebeat.yml',
        content => template("${module_name}/filebeat.yml.erb"),
        owner   => 'root',
        group   => 'root',
        mode    => $filebeat::config_file_mode,
        notify  => Service['filebeat'],
      }

      file {'filebeat-config-dir':
        ensure  => directory,
        path    => $filebeat::config_dir,
        owner   => 'root',
        group   => 'root',
        mode    => $filebeat::config_dir_mode,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
      }
    } # end Linux

    'Windows' : {
      file {'filebeat.yml':
        ensure  => file,
        path    => 'C:/Program Files/Filebeat/filebeat.yml',
        content => template("${module_name}/filebeat.yml.erb"),
        notify  => Service['filebeat'],
      }

      file {'filebeat-config-dir':
        ensure  => directory,
        path    => $filebeat::config_dir,
        recurse => $filebeat::purge_conf_dir,
        purge   => $filebeat::purge_conf_dir,
      }
    } # end Windows

    default : {
      fail($filebeat::kernel_fail_message)
    }
  }
}
