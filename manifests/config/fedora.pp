#
# == Class: tclient::config::fedora
#
# Fedora-specific tclient configurations
#
class tclient::config::fedora {

    package { [ 'iproute', 'net-tools' ]:
        ensure => installed,
    }
}
