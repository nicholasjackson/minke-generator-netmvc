require "generators/netmvc/version"

require 'minke/generators/register'
require 'minke/generators/config'

module Minke
  module Generators
    module NetMVC
      # Register the template with minke
      config = Minke::Generators::Config.new
      config.name = 'minke-generator-netmvc'
      config.template_location = File.expand_path(File.dirname(__FILE__)) + '/netmvc/scaffold'

      config.build_settings = Minke::Generators::BuildSettings.new

      config.build_settings.build_commands = Minke::Generators::BuildCommands.new.tap do |bc|
        bc.fetch = [['/bin/bash', '-c', 'dotnet restore --packages ./.nuget']]
        bc.build = [['/bin/bash', '-c', 'NUGET_PACKAGES=./.nuget dotnet build']]
        bc.test = [['/bin/bash', '-c', 'NUGET_PACKAGES=./.nuget dotnet test']]
      end

      config.build_settings.docker_settings = Minke::Generators::DockerSettings.new.tap do |bs|
        bs.image = 'microsoft/dotnet:latest'
        bs.binds = ["<%= src_root %>:/src"]
        bs.working_directory = '/src' # working directory is added via a class patch to enable lazy load
      end

      Minke::Generators.register config
    end
  end
end
