require 'hammer_cli_foreman/compute_resources/compute_attributes_base'

module HammerCLIForeman
  module ComputeResources
    module Openstack
      class ComputeAttributes < ComputeAttributesBase
        def name
          'openstack'
        end

        def fields(dsl)
          dsl.build do
            field nil, _('Flavor'), Fields::SingleReference, :key => :flavor
            field :availability_zone, _('Availability zone')
            # TODO: Image
            field nil, _('Tenant'), Fields::SingleReference, :key => :tenant
            field nil, _('Security group'), Fields::SingleReference, :key => :security_group

            collection :nics_attributes, _("Network interfaces") do
              custom_field Fields::Reference
            end
            field :floating_ip_network, _('Floating IP network')
            field :boot_from_volume, _('Boot from volume'), Fields::Boolean

            field :boot_volume_size, _('New boot volume size'), Fields::Memory
            field :scheduler_hint_filter, _('Scheduler hint filter')
          end
        end
      end
    end
  end
end
