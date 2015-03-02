
Puppet::Type.newtype(:pleaserun) do
  @doc = "Install and manage service configurations. The basic goal of this
    type is to allow you to create sysv, upstart, systemd, launchd, or any other
    'run this process' configuration."

  ensurable

  newparam(:name) do
    desc "The name of the service."
    isnamevar

    validate do |value|
      if !value.is_a?(String)
        raise ArgumentError, "Name must be a String, not #{value.class}"
      end
    end
  end

  newparam(:program) do
    desc "The program to run. This must be the fully-qualified path name to the program to execute as the service."

    validate do |value|
      if !value.is_a?(String)
        raise ArgumentError, "Program must be a String, not #{value.class}"
      end
    end
  end

  newparam(:platform) do
    desc "The name of the platform to target, such as sysv, upstart, etc"

    validate do |value|
      if !value.is_a?(String)
        raise ArgumentError, "Platform must be a String, not #{value.class}"
      end
    end
  end

  newparam(:target_version) do
    desc "The version of the platform to target, such as 'lsb-3.1' for sysv or '1.5' for upstart"

    validate do |value|
      if !value.is_a?(String)
        raise ArgumentError, "Version must be a String, not #{value.class}"
      end
    end
  end

  newparam(:args) do
    desc "The arguments to pass to the program."

    validate do |value|
      value = [value] if value.is_a?(String)
      if !value.is_a?(Array)
        raise ArgumentError, "Args must be an Array of Strings, is #{value.class}"
      end

      value.each_with_index do |arg, i|
        if !arg.is_a?(String)
          raise ArgumentError, "All Args must be Strings, args[#{i}] is a #{arg.class}"
        end
      end
    end


    munge do |value|
      if value.is_a?(String)
        [value]
      end
    end
  end
end
