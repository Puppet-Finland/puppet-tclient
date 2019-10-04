#
# @summary configure t_client.sh tests
#
# @param manage_tclient_rc
#   Manage t_client.rc or not.
# @param test_run_list
#   List of t_client tests to run. The default is the full, generally useful 
#   battery of tests. If IPv6 connectivity is missing, then '1 2 3 4 5 6' is 
#   more useful.
# @setup_time_wait
#   Wait this many seconds for OpenVPN to startup before launching t_client tests.
# @public_test_server
#   The OpenVPN test server's IP address or hostname of the OpenVPN test
#   server. Passed on to --remote on OpenVPN command-line
# @ipv4_http_proxy
#   Currently not useful as public proxy is not available.
# @ipv6_http_proxy
#   Currently not useful as public proxy is not available.
# @ipv4_socks_proxy
#   Currently not useful as public proxy is not available.
# @ipv6_socks_proxy
#   Currently not useful as public proxy is not available.
#
class tclient
(
    String  $public_test_server,
    # Test 1: TCP / p2mp tun
    String  $ping4_hosts_1,
    String  $ping6_hosts_1,
    # Test 2: UDP / p2mp tun
    String  $ping4_hosts_2,
    String  $ping6_hosts_2,
    # Test 3: UDP / p2mp tun, topology subnet
    String  $ping4_hosts_3,
    String  $ping6_hosts_3,
    # Test 4: UDP / p2mp tap
    String  $ping4_hosts_4,
    String  $ping6_hosts_4,
    # Test 5: UDP / p2mp tun, top net30, ipv6 /112
    String  $ping4_hosts_5,
    String  $ping6_hosts_5,
    # Test 6: UDP / p2mp tun, top subnet, --fragment 500
    String  $ping4_hosts_6,
    String  $ping6_hosts_6,
    Boolean $manage_tclient_rc = true,
    String  $test_run_list = '1 1a 2 2a 2b 2c 3 4 4a 5 6',
    Integer $setup_time_wait = 30,
    String  $ipv4_http_proxy = '127.0.0.1',
    String  $ipv6_http_proxy = '::1',
    String  $ipv4_socks_proxy = '127.0.0.1',
    String  $ipv6_socks_proxy = '::1'
)
{

    include ::openvpn::buildenv
    include ::tclient::prequisites

    file { '/home/buildbot':
        ensure => directory,
        owner  => $::os::params::adminuser,
        group  => $::os::params::admingroup,
        mode   => '0755',
    }

    if $manage_tclient_rc {

        $file_defaults = {
            'ensure'  => 'present',
            'owner'   => $::os::params::adminuser,
            'group'   => $::os::params::admingroup,
            'require' => File['/home/buildbot'],
        }

        file { 'tclient-t_client.rc':
            name    => '/home/buildbot/t_client.rc',
            content => template('tclient/t_client.rc.erb'),
            mode    => '0644',
            *       => $file_defaults,
        }
        file { "tclient-${::fqdn}.crt":
            name   => '/home/buildbot/test-client.crt',
            source => "puppet:///files/tclient-${::fqdn}.crt",
            mode   => '0644',
            *      => $file_defaults,
        }
        file { "tclient-${::fqdn}.key":
            name   => '/home/buildbot/test-client.key',
            source => "puppet:///files/tclient-${::fqdn}.key",
            mode   => '0600',
            *      => $file_defaults,
        }
        file { 'tclient-ca.crt':
            name   => '/home/buildbot/test-ca.crt',
            source => 'puppet:///files/tclient-ca.crt',
            mode   => '0644',
            *      => $file_defaults,
        }
        file { 'tclient-ta.key':
            name   => '/home/buildbot/test-ta.key',
            source => 'puppet:///files/tclient-ta.key',
            mode   => '0644',
            *      => $file_defaults,
        }
    }


    # Fedora does not have iproute2 installed by default
    if $::operatingsystem == 'Fedora' {
        include ::tclient::config::fedora
    }
}
