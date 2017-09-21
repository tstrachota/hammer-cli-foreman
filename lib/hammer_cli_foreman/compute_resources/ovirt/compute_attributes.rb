require 'hammer_cli_foreman/compute_resources/compute_attributes_base'

module HammerCLIForeman
  module ComputeResources
    module Ovirt
      class ComputeAttributes < ComputeAttributesBase
        def name
          'ovirt'
        end


 # cores: '2'
 #          memory: '536870912'
 #          interfaces_attributes:
 #            '0':
 #              name: eth0
 #            '1':
 #              name: eth1
 #          cluster_id: 9ce445e8-4c03-11e1-b3c8-5254009970cc
 #          cluster_name: Cluster2
 #          template_id: 05a5144f-8ef7-4151-b7f9-5014510b489e
 #          template_name: hwp_large
 #        Storage:
 #         1) Attributes:
 #              size_gb: '15'
 #              id: ''
 #              preallocate: false
 #              size: '16106127360'
 #              storage_domain_id: 312f6445-79da-4ce4-907d-9a871125e3ca
 #              storage_domain_name: nfs
 #              bootable: false
 #         2) Attributes:
 #              size_gb: '5'
 #              id: ''
 #              preallocate: true
 #              bootable: true
 #              size: '5368709120'
 #              storage_domain_id: 382ec55a-f886-4fa1-b880-0a9fa778aa5b
 #              storage_domain_name: covirt


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
