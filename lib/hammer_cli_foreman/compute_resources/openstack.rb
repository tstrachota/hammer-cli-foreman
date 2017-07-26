require 'hammer_cli_foreman/compute_resources/openstack/host_help_extenstion'
require 'hammer_cli_foreman/compute_resources/openstack/compute_attributes'

module HammerCLIForeman
  module ComputeResources
    module Openstack
      HammerCLIForeman::Host.extend_cr_help(HostHelpExtenstion.new)
    end
  end
end
