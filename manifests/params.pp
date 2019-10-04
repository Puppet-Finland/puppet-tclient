#
# == Class: tclient::params
#
# Defines some variables based on the operating system
#
class tclient::params {

    case $::osfamily {
        'RedHat': {
            $fping_package_name = 'fping'
            $snappy_package_name = 'snappy-devel'
        }
        'Debian': {
            $fping_package_name = 'fping'
            $snappy_package_name = 'libsnappy-dev'
        }
        default: {
            $fping_package_name = 'fping'
            $snappy_package_name = 'libsnappy-dev'
        }
    }
}
