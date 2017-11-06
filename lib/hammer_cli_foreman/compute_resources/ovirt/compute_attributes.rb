require 'hammer_cli_foreman/compute_resources/compute_attributes_base'

module HammerCLIForeman
  module ComputeResources
    module Ovirt
      class ComputeAttributes < ComputeAttributesBase
        def name
          'ovirt'
        end

        def fields(dsl)
          dsl.build do
            field nil, _('Cluster'), Fields::SingleReference, :key => :cluster
            field nil, _('Template'), Fields::SingleReference, :key => :template
            field :cores, _('Cores')
            field :memory, _('Memory'), Fields::Memory
            collection :interfaces_attributes, _("Network interfaces") do
              field :name, _('Name')
              # TODO: network
            end
            collection :volumes_attributes, _("Storage") do
              field :size, _('Size'), Fields::Memory
              field nil, _('Storage domain'), Fields::SingleReference, :key => :storage_domain
              field :preallocate, _('Preallocate disk'), Fields::Boolean
              field :bootable, _('Bootable'), Fields::Boolean
            end
          end
        end
      end
    end
  end
end
