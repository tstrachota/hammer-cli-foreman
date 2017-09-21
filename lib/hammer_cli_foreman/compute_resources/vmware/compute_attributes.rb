require 'hammer_cli_foreman/compute_resources/compute_attributes_base'

module HammerCLIForeman
  module ComputeResources
    module VMware
      class ComputeAttributes < ComputeAttributesBase
        def name
          'vmware'
        end

        def fields(dsl)
          dsl.build do
            field :cpus, _('CPUs')
            field :cores_per_socket, _('Cores per socket')
            field :memory, _('Memory'), Fields::Memory
            field :firmware, _('Firmware')
            field nil, _('Cluster'), Fields::SingleReference, :key => :cluster
            field nil, _('Resource pool'), Fields::SingleReference, :key => :resource_pool
            field nil, _('Folder'), Fields::SingleReference, :key => :folder, :id_key => 'folder_path'
            field nil, _('Guest OS'), Fields::SingleReference, :key => :guest
            field nil, _('Virtual H/W version'), Fields::SingleReference, :key => :hardware_version

            field :memory_hot_add_enabled, _('Memory hot add'), Fields::Boolean
            field :cpu_hot_add_enabled, _('CPU hot add'), Fields::Boolean
            field :add_cdrom, _('CD-ROM drive'), Fields::Boolean

            field :annotation, _('Annotation Notes')
            field nil, _('Image'), Fields::SingleReference, :key => :image

            collection :interfaces_attributes, _("Network interfaces") do
              field nil, _('Type'), Fields::SingleReference, :key => :type
              field nil, _('Network'), Fields::SingleReference, :key => :network
            end

            collection :scsi_controllers, _("Storage") do
              field :type, _('SCSI controller')
              collection :volumes, _("Volumes") do
                field :name, _('Disk name')
                field nil, _('Data store'), Fields::SingleReference, :key => :datastore
                field :mode, _('Disk mode')
                field :size, _('Size'), Fields::Memory
                field :thin, _('Thin provision'), Fields::Boolean
                field :eagerzero, _('Eager zero'), Fields::Boolean
              end
            end
          end
        end

        def transform_attributes(attrs)
          attrs = super(attrs)

          # TODO unify nics_attributes and interfaces_attributes
          attrs['interfaces_attributes'] = attrs['interfaces_attributes'].values if attrs.has_key?('interfaces_attributes')
          attrs['scsi_controllers'] = attrs['scsi_controllers'].map do |key, ctrl|
            ctrl['volumes'] = attrs['volumes_attributes'].find_all{|v| v['controller_key'] == ctrl['key']}
            ctrl
          end
          attrs
        end
      end
    end
  end
end
