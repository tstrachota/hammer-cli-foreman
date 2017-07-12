module HammerCLIForeman

  class Auth < HammerCLI::AbstractCommand

    class LoginCommand < HammerCLI::AbstractCommand
      command_name "login"
      desc _("Set credentials")

      option ["-u", "--username"], "USERNAME", _("username to access the remote system")
      option ["-p", "--password"], "PASSWORD", _("password to access the remote system")

      def execute
        if !(HammerCLIForeman.foreman_api_connection.authenticator.is_a?(HammerCLIForeman::Api::SessionAuthenticatorWrapper))
          print_message(_("Can't perform login. Make sure you have sessions enabled."))
          return HammerCLI::EX_USAGE
        end

        # Make sure we reflect also credentials set for the main hammer command
        # ( hammer -u test auth login )
        HammerCLI::Settings.load({
          :_params => {
            :username => option_username || HammerCLI::Settings.get('_params', 'username'),
            :password => option_password || HammerCLI::Settings.get('_params', 'password')
          }
        })

        HammerCLIForeman.foreman_api_connection.logout
        context[:api_connection].drop_all

        HammerCLIForeman.foreman_api_connection.login

        print_message(_("Successfully logged in as '%s'.") % HammerCLIForeman.foreman_api_connection.authenticator.user)
        HammerCLI::EX_OK
      end
    end

    class LogoutCommand < HammerCLI::AbstractCommand
      command_name "logout"
      desc _("Wipe your credentials")

      def execute
        HammerCLIForeman.foreman_api_connection.logout
        context[:api_connection].drop_all
        print_message(_("Logged out."))
        HammerCLI::EX_OK
      end
    end

    class InfoCommand < HammerCLI::AbstractCommand
      command_name "status"
      desc _("Information about current connections")

      def execute
        print_message(HammerCLIForeman.foreman_api_connection.login_status)
        HammerCLI::EX_OK
      end
    end

    autoload_subcommands
  end

end
