require 'hammer_cli_foreman/compute_resources/compute_attributes_base'

module HammerCLIForeman
  module ComputeResources
    module VMware
      class ComputeAttributes < ComputeAttributesBase
        def name
          'vmware'
        end

            #             "attributes" => {
            #                       "cpus" => "1",
            #                   "firmware" => "bios",
            #                    "cluster" => "",
            #                   "guest_id" => "otherGuest",
            #                  "add_cdrom" => false,
            #                 "annotation" => "",
            #           "scsi_controllers" => {
            #         "0" => {
            #             "type" => "VirtualLsiLogicController",
            #              "key" => 1000
            #         },
            #         "1" => {
            #             "type" => "VirtualLsiLogicSASController",
            #              "key" => 1001
            #         }
            #     },
            #      "interfaces_attributes" => {
            #         "0" => {
            #                "type" => "VirtualE1000",
            #             "network" => "dvportgroup-107686"
            #         },
            #         "1" => {
            #                "type" => "VirtualVmxnet3",
            #             "network" => "network-47067"
            #         }
            #     },
            #         "volumes_attributes" => {
            #         "0" => {
            #                       "thin" => true,
            #                       "name" => "Hard disk",
            #                       "mode" => "independent_persistent",
            #             "controller_key" => 1000,
            #                       "size" => "10737418240",
            #                    "size_gb" => 10,
            #                "storage_pod" => "StorageCluster"
            #         },
            #         "1" => {
            #                       "thin" => false,
            #                       "name" => "Hard disk",
            #                       "mode" => "independent_nonpersistent",
            #             "controller_key" => 1001,
            #                       "size" => "8589934592",
            #                    "size_gb" => 8,
            #                  "datastore" => "",
            #                "storage_pod" => "StorageCluster",
            #                 "eager_zero" => false,
            #                  "eagerzero" => true
            #         }
            #     },
            #           "cores_per_socket" => "1",
            #                     "memory" => 786432,
            #                "folder_path" => "/Datacenters/CFME/vm",
            #                "folder_name" => "vm",
            #                 "guest_name" => "Other Operating System (32-bit)",
            #        "hardware_version_id" => "Default",
            #      "hardware_version_name" => nil,
            #     "memory_hot_add_enabled" => false,
            #        "cpu_hot_add_enabled" => false
            # }



        def fields(dsl)
          dsl.build do
            field :cpus, _('CPUs')
            field :cores_per_socket, _('Cores per socket')
            field :memory, _('Memory'), Fields::Memory
            field :firmware, _('Firmware')
            field :cluster, _('Cluster') #TODO: nilify cluster
            # TODO: resource pool
            field nil, _('Folder'), Fields::SingleReference, :key => :folder, :id_key => 'folder_path'
            field nil, _('Guest OS'), Fields::SingleReference, :key => :guest
            field nil, _('Virtual H/W version'), Fields::SingleReference, :key => :hardware_version



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
