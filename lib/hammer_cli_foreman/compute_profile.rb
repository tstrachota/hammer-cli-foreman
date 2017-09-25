require 'hammer_cli_foreman/image'
require 'hammer_cli_foreman/compute_resources/all'

module HammerCLIForeman
  class ComputeProfile < HammerCLIForeman::Command
    resource :compute_profiles

    def self.provider_attributes
      @provider_attributes ||= {
        'libvirt' => HammerCLIForeman::ComputeResources::Libvirt::ComputeAttributes.new,
        'ec2' => HammerCLIForeman::ComputeResources::EC2::ComputeAttributes.new,
        'openstack' => HammerCLIForeman::ComputeResources::Openstack::ComputeAttributes.new,
        'google' => HammerCLIForeman::ComputeResources::GCE::ComputeAttributes.new,
        'vmware' => HammerCLIForeman::ComputeResources::VMware::ComputeAttributes.new,
        'rackspace' => HammerCLIForeman::ComputeResources::Rackspace::ComputeAttributes.new,
        'ovirt' => HammerCLIForeman::ComputeResources::Ovirt::ComputeAttributes.new,
        'default' => HammerCLIForeman::ComputeResources::Default::ComputeAttributes.new
      }
    end

    def self.get_provider(name)
      provider_attributes[name] || provider_attributes['default']
    end

    class ListCommand < HammerCLIForeman::ListCommand
      output do
        field :id, _("Id")
        field :name, _("Name")
      end

      build_options
    end

    class InfoCommand < HammerCLIForeman::InfoCommand
      def self.vm_attrs_fields(dsl)
        dsl.build do
          HammerCLIForeman::ComputeProfile.provider_attributes.each do |k,t|
            label _("VM attributes"), :path => ["#{t.name}_vm_attrs".to_sym], :hide_blank => true do
              t.fields(self)
            end
          end
        end
      end

      output ListCommand.output_definition do
        collection :compute_attributes, _("Compute attributes") do
          adaptors [:json, :yaml, :csv] do
            field nil, _('Compute resource'), Fields::SingleReference,
              :key => :compute_resource,
              :details => [
                { :label => _('Type'), :key => :provider_friendly_name }
              ]
          end
          adaptors [:base, :table] do
            field nil, nil, Fields::SingleReference, :key => :compute_resource, :details => :provider_friendly_name
          end
          field :id, _('Id'), Fields::Id
          field :name, _('Name')

          InfoCommand.vm_attrs_fields(self)
        end
      end

      def extend_data(record)
        record['compute_attributes'].each do |attrs|
          provider_name = attrs.fetch('provider_friendly_name', 'default')
          transformer = HammerCLIForeman::ComputeProfile.get_provider(provider_name.downcase)
          attrs[transformer.name + '_vm_attrs'] = transformer.transform_attributes(attrs['attributes'])
          attrs
        end
        record
      end

      build_options
    end

    autoload_subcommands
  end
end
