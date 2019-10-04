#
# == Class: tclient::prequisites
#
# Prepare for tclient setup
#
class tclient::prequisites {

    include ::tclient::params
    include ::openvpn::buildenv

    package { 'git':
      ensure => 'present',
    }

    package { 'fping':
        ensure => installed,
        name   => $::tclient::params::fping_package_name,
    }

    package { 'snappy-devel':
        ensure => installed,
        name   => $::tclient::params::snappy_package_name,
    }
}
