require "pleaserun/platform/base"
require "pleaserun/cli"
require "pleaserun/detector"
Puppet::Type.type(:pleaserun).provide(:default) do
  desc "The default and most awesome pleaserun experience."

  def runner
    return @runner if @runner

    # XXX: Split these into separate "providers"
    platform, version = PleaseRun::Detector.detect

    # silly hack for now until I properly refactor this.
    cli = PleaseRun::CLI.new([])
    cli.setup_logger
    runner_klass = cli.load_platform(platform)

    @runner = runner_klass.new(version)
    @runner.name = @resource[:name]
    @runner.program = @resource[:program]
    # Args are optional.
    @runner.args = @resource[:args] if @resource[:args]
    return @runner
  end

  def create
    runner.files.each do |path, content, perms|
      puts path
      # TODO(sissel): Create File resources instead?
      fd = File.new(path, "w", perms)
      fd.write(content)
      fd.close
    end

    # TODO(sissel): Create Exec resources instead?
    runner.install_actions.each do |action|
      system(action)
      if !$?.success?
        fail "Install action failed, action was '#{action}'"
      end
    end
  end

  def destroy
    runner.files.each do |path, content, perms|
      File.unlink(path)
    end
  end

  def exists?
    # TODO(sissel): Use file existence checks?
    # Do all the files exist and are they the same as required?
    return runner.files.all? do |path, content, perms|
      File.file?(path) && File.read(path) == content
    end
  end
end
