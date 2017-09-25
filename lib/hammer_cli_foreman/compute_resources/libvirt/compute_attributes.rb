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
            field nil, _('Image'), Fields::SingleReference, :key => :image
            collection :interfaces_attributes, _("Network interfaces") do
              field :type, _('Type')
              field :bridge, _('Network'), Fields::Field, :hide_blank => true
              field :network, _('Network'), Fields::Field, :hide_blank => true
              field :model, _('Model')
            end
            collection :volumes_attributes, _("Storage") do
              field :pool, _('Storage pool')
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
