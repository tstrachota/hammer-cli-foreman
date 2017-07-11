require 'hammer_cli_foreman/compute_resources/compute_attributes_base'

module HammerCLIForeman
  module ComputeResources
    module Libvirt
      class ComputeAttributes < ComputeAttributesBase
        def name
          'libvirt'
        end

        def fields(dsl)
          dsl.build do
            field :cpus, _('CPUs')
            field :memory, _('Memory'), Fields::Memory
            # TODO: image
            collection :nics_attributes, _("Network interfaces") do
              field :type, _('Type')
              field :bridge, _('Bridge')
            end
            collection :volumes_attributes, _("Storage") do
              field :pool_name, _('Storage pool')
              field :capacity, _('Size'), Fields::Memory
              field :allocation, _('Allocation'), Fields::Memory
              field :format_type, _('Format')
            end
          end
        end
      end
    end
  end
end
