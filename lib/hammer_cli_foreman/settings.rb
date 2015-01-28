
module HammerCLIForeman

  class Settings < HammerCLIForeman::Command

    resource :settings

    class ListCommand < HammerCLIForeman::ListCommand

    end

    autoload_subcommands
  end

end
