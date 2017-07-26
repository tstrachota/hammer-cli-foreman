require 'hammer_cli_foreman/compute_resources/compute_attributes_base'

module HammerCLIForeman
  module ComputeResources
    module EC2
      class ComputeAttributes < ComputeAttributesBase
        def name
          'ec2'
        end

            #                     "id" => 2,
            #                   "name" => "m1.small - Small Instance",
            #    "compute_resource_id" => 2,
            #  "compute_resource_name" => "Ondruv EC2",
            # "provider_friendly_name" => "EC2",
            #     "compute_profile_id" => 1,
            #   "compute_profile_name" => "1-Small",
            #               "vm_attrs" => {
            #              "flavor_id" => "m1.small",
            #      "availability_zone" => "",
            #              "subnet_id" => "",
            #     "security_group_ids" => [
            #         [0] ""
            #     ],
            #             "managed_ip" => "public"
            # }



        def fields(dsl)
          dsl.build do
            field nil, _('Flavor'), Fields::SingleReference, :key => :flavor
            # Image
            field :availability_zone, _('Availability zone')
            field nil, _('Subnet'), Fields::SingleReference, :key => :subnet
            # Security groups
            field :managed_ip, _('Managed IP')
          end
        end

        def transform_attributes(attrs)
          attrs = super(attrs)
          attrs["availability_zone"] ||= _('No preference') # TODO: shouldn't this be moved to default value formatter
          attrs["subnet_id"] ||= 'EC2' # TODO: shouldn't this be moved to default value formatter
          attrs
        end
      end
    end
  end
end
