require 'hammer_cli_foreman/compute_resources/compute_attributes_base'

module HammerCLIForeman
  module ComputeResources
    module EC2
      class ComputeAttributes < ComputeAttributesBase
        def name
          'ec2'
        end

        def fields(dsl)
          dsl.build do
            field nil, _('Flavor'), Fields::SingleReference, :key => :flavor
            field nil, _('Image'), Fields::SingleReference, :key => :image
            field :availability_zone, _('Availability zone')
            field nil, _('Subnet'), Fields::SingleReference, :key => :subnet
            collection :security_groups, _("Security groups") do
              field nil, nil, Fields::Reference
            end
            field :managed_ip, _('Managed IP')
          end
        end

        def transform_attributes(attrs)
          attrs = super(attrs)
          attrs["availability_zone"] ||= _('No preference')
          attrs["subnet_id"] ||= 'EC2'
          attrs
        end
      end
    end
  end
end
