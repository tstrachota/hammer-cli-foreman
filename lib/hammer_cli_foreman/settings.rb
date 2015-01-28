
module HammerCLIForeman

  class Settings < HammerCLIForeman::Command

    resource :settings

    class ListCommand < HammerCLIForeman::ListCommand

      output do
        field :name, _('Name')
        field :value, _('Value')
        field :description, _('Description')
      end

      build_options
    end

    autoload_subcommands
  end

end
