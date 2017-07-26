require 'hammer_cli_foreman/compute_resources/compute_attributes_base'

module HammerCLIForeman
  module ComputeResources
    module GCE
      class ComputeAttributes < ComputeAttributesBase
        def name
          'google'
        end

        def fields(dsl)
          dsl.build do
            field :machine_type, _('Machine type')
            # TODO: Image
            field :network, _('Network')
            field :external_ip, _('External IP'), Fields::Boolean
            collection :volumes_attributes, _("Storage") do
              field :size, _('Size'), Fields::Memory
            end
          end
        end
      end
    end
  end
end
