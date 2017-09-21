require 'hammer_cli_foreman/compute_resources/compute_attributes_base'

module HammerCLIForeman
  module ComputeResources
    module Rackspace
      class ComputeAttributes < ComputeAttributesBase
        def name
          'rackspace'
        end

        def fields(dsl)
          dsl.build do
            field nil, _('Flavor'), Fields::SingleReference, :key => :flavor
            field nil, _('Image'), Fields::SingleReference, :key => :image
          end
        end
      end
    end
  end
end
